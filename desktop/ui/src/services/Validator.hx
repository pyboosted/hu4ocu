package services;

enum ValidatorType {
  Url;
  Text;
  Email;
  Phone;
  Zipcode;
  Checkbox;
  Password;
}

enum ValidatorRule {
  Required;
  Accepted;
  Min(m:Int);
  Max(m:Int);
  Confirmed(f:String);
  Type(t:ValidatorType);
}

class Validator {

  static var REGEXP: Map<ValidatorType, EReg> = [
    Url     => ~/^(?:(?:https?|ftp):\/\/)(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,}))\.?)(?::\d{2,5})?(?:[\/?#]\S*)?$/i,
    Email   => ~/[A-Z0-9._%-]+@[A-Z0-9.-]+.[A-Z][A-Z][A-Z]?/i,
    Phone   => ~/^\+?[0-9-\s]{6,18}$/,
    Zipcode => ~/^[a-z0-9][a-z0-9\- ]{0,10}[a-z0-9]$/i,
  ];

  var valid: Bool;
  var data: Map<String, Dynamic>;
  var rules: Map<String, Array<ValidatorRule>>;
  var errors: Map<String, Array<String>>;
  var touches: Array<String>;

  public function new(rules: Map<String, Array<ValidatorRule>>):Void {
    this.valid = false;
    this.rules = rules;
    this.touches = [];
    this.errors = new Map();
    this.data = new Map();
    for (field in rules.keys()) {
      this.data.set(field, hasRule(field, Type(Checkbox)) ? false : '');
      validate(field);
    }
    checkValidation();
  }

  inline function isTouched(field: String):Bool return touches.indexOf(field) != -1;

  public function hasErrors(field: String):Bool return isTouched(field) ? errors.exists(field) : false;
  public function getError(field: String):String return hasErrors(field) ? errors.get(field)[0] : '';

  public function passes():Bool return valid;
  public function fails():Bool return !valid;

  public function get(field: String, ?trim: Bool = true):Dynamic return trim ? StringTools.trim(data.get(field)) : data.get(field);
  public function set(field: String, value: Dynamic, ?revalidate: Bool = false):Void {
    data.set(field, value);
    if (revalidate) {
      validate(field);
      checkValidation();
    }
  }

  public function input(field: String, value: Dynamic):Void {
    if (!isTouched(field)) touches.push(field);
    data.set(field, value);
    if (hasRule(field, Type(Password))) {
      for (f in rules.keys()) {
        if (hasRule(f, Confirmed(field))) validate(f);
      }
    }
    validate(field);
    checkValidation();
  }

  public function clear(?fields: Array<String>) {
    if (fields == null) fields = [for(k in data.keys()) k];
    for (field in fields) {
      touches.remove(field);
      data.set(field, hasRule(field, Type(Checkbox)) ? false : '');
      validate(field);
    }
    checkValidation();
  }

  function hasRule(field: String, rule: ValidatorRule):Bool {
    for (r in rules[field]) {
      if (rule.equals(r)) return true;
    }
    return false;
  }

  function checkValidation():Void {
    valid = [for (k in errors.keys()) k].length == 0;
  }

  function validate(field: String):Void {
    var value = data.get(field);
    var errs: Array<String> = [];
    for (rule in rules.get(field)) {
      switch(rule) {

        case Type(t):
          switch (t) {
            case Zipcode:
              if(!REGEXP.get(Zipcode).match(value)) errs.push('The field must be a valid zip code');
            case Email:
              if(!REGEXP.get(Email).match(value)) errs.push('The field must be a valid email address');
            case Phone:
              if(!REGEXP.get(Phone).match(value)) errs.push('The field must be a valid phone number');
            case Url:
              if(!REGEXP.get(Url).match(value)) errs.push('The field must be a valid URL');
            case _:
          }

        case Required:
          if(value == null || StringTools.trim(value).length == 0) errs.push('The field is required');

        case Confirmed(f):
          if(!data.exists(f) || value != data.get(f)) errs.push('The confirmation does not match');

        case Accepted:
          if(value != true) errs.push('The field must be accepted');

        case Min(min):
          if(value.length < min) errs.push('The field must be at least ${min} characters');

        case Max(max):
          if(value.length > max) errs.push('The field may not be greater than ${max} characters');

      }
    }
    if (errs.length == 0) errors.remove(field);
    else errors.set(field, errs);
  }
}