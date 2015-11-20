// Generated by Haxe
(function (console) { "use strict";
var WheelClient = function() {
	this.config = null;
	var _g = this;
	this.doc = window.document;
	this.doc.addEventListener("DOMContentLoaded",function() {
		electron_IPC.send("ready");
		_g.config = electron_IPC.sendSync("wheel.get");
		_g.usersInput = _g.doc.getElementById("users");
		_g.shuffleBtn = _g.doc.getElementById("shuffle");
		_g.saveBtn = _g.doc.getElementById("save");
		_g.startBtn = _g.doc.getElementById("start");
		_g.stopBtn = _g.doc.getElementById("stop");
		_g.speedingLabel = _g.doc.getElementById("speeding");
		_g.slowingLabel = _g.doc.getElementById("slowing");
		_g.winnerLabel = _g.doc.getElementById("winner");
		_g.startBtn.addEventListener("click",function(_) {
			_g.config = electron_IPC.sendSync("wheel.start");
			_g.updateBtns();
		});
		_g.stopBtn.addEventListener("click",function(_1) {
			_g.config = electron_IPC.sendSync("wheel.stop");
			_g.updateBtns();
		});
		_g.shuffleBtn.addEventListener("click",function(_2) {
			_g.config = electron_IPC.sendSync("wheel.shuffle");
			_g.updateUsers();
			_g.updateBtns();
		});
		_g.saveBtn.addEventListener("click",function(_3) {
			var users = _g.usersInput.value.split("\n");
			_g.config = electron_IPC.sendSync("wheel.update",users);
			_g.updateUsers();
			_g.updateBtns();
		});
		var timer = new haxe_Timer(500);
		timer.run = function() {
			_g.config = electron_IPC.sendSync("wheel.get");
			_g.updateBtns();
		};
		_g.updateUsers();
		_g.updateBtns();
	});
};
WheelClient.main = function() {
	var client = new WheelClient();
};
WheelClient.prototype = {
	updateUsers: function() {
		this.usersInput.value = this.config.list.join("\n");
	}
	,updateBtns: function() {
		if(this.config.status == "not_running") {
			if(this.config.list.length > 0) this.shuffleBtn.style.display = "inline"; else this.shuffleBtn.style.display = "none";
			this.saveBtn.style.display = "inline";
			if(this.config.list.length > 0) this.startBtn.style.display = "inline"; else this.startBtn.style.display = "none";
			this.stopBtn.style.display = "none";
			this.slowingLabel.style.display = "none";
			this.speedingLabel.style.display = "none";
			this.winnerLabel.style.display = "none";
		}
		if(this.config.status == "speeding") {
			this.shuffleBtn.style.display = "none";
			this.saveBtn.style.display = "none";
			this.startBtn.style.display = "none";
			this.stopBtn.style.display = "none";
			this.slowingLabel.style.display = "none";
			this.speedingLabel.style.display = "inline";
			this.winnerLabel.style.display = "none";
		}
		if(this.config.status == "running") {
			this.shuffleBtn.style.display = "none";
			this.saveBtn.style.display = "none";
			this.startBtn.style.display = "none";
			this.stopBtn.style.display = "inline";
			this.slowingLabel.style.display = "none";
			this.speedingLabel.style.display = "none";
			this.winnerLabel.style.display = "none";
		}
		if(this.config.status == "slowing") {
			this.shuffleBtn.style.display = "none";
			this.saveBtn.style.display = "none";
			this.startBtn.style.display = "none";
			this.stopBtn.style.display = "none";
			this.slowingLabel.style.display = "inline";
			this.speedingLabel.style.display = "none";
			this.winnerLabel.style.display = "none";
		}
		if(this.config.status == "stopped") {
			this.shuffleBtn.style.display = "inline";
			this.saveBtn.style.display = "inline";
			this.startBtn.style.display = "none";
			this.stopBtn.style.display = "none";
			this.slowingLabel.style.display = "none";
			this.speedingLabel.style.display = "none";
			this.winnerLabel.style.display = "inline";
			this.winnerLabel.innerHTML = "Победитель: " + this.config.list[this.config.winner];
		}
	}
};
var electron_IPC = require("ipc");
var haxe_Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
haxe_Timer.prototype = {
	run: function() {
	}
};
WheelClient.main();
})(typeof console != "undefined" ? console : {log:function(){}});
