LIB-ASYNC = -cp libs/hx-async 
LIB-NODE = -cp libs/hx-node/src 
LIB-TOML = -cp libs/haxetoml/src
LIB-MITHRIL = -cp libs/hx-mithril-simple/src
LIB-WS = -cp libs/hx-ws/src
LIB-CASPER = -cp libs/hx-casperjs/src
LIB-MSGPACK = -cp libs/hx-msgpack/src
LIB-ELECTRON = -cp libs/hx-electron/src
LIB-NODESTATIC = -cp libs/hx-nodestatic/src

SHARED = -cp shared
all: desktop widgets utils

desktop: desktop/ui desktop/app
desktop/ui: bin/desktop/html/ui.js
desktop/app: bin/desktop/app.js

bin/desktop/html/ui.js: 
	haxe 	-js bin/desktop/html/ui.js -main UI \
				-cp desktop/ui/src $(SHARED) $(LIB-ASYNC) $(LIB-MITHRIL) $(LIB-ELECTRON)
bin/desktop/html/ui.css: 
	touch bin/desktop/html/ui.css

bin/desktop/app.js:
	haxe 	-js bin/desktop/app.js -main App \
				-cp desktop/app/src $(SHARED) $(LIB-ASYNC) $(LIB-NODE) $(LIB-TOML) $(LIB-WS) $(LIB-ELECTRON) $(LIB-NODESTATIC) -D client
widgets: widgets/wheel widgets/polls
widgets/wheel: bin/widgets/wheel/app.js
widgets/polls: bin/widgets/polls/app.js

bin/widgets/wheel/app.js:
	touch bin/widgets/wheel/app.js
bin/widgets/polls/app.js:
	touch bin/widgets/polls/app.js

utils: bin/utils/rutony-mock.js bin/utils/yt-parser.js
bin/utils/rutony-mock.js:
	haxe 	-js bin/utils/rutony-mock.js -main RutonyMock \
				-cp utils/rutony-mock/src $(SHARED) $(LIB-ASYNC) $(LIB-NODE) $(LIB-TOML) $(LIB-WS)
bin/utils/yt-parser.js:
	haxe 	-js bin/utils/yt-parser.js -main YtParser \
				-cp utils/yt-parser/src $(SHARED) $(LIB-ASYNC) $(LIB-NODE) $(LIB-MSGPACK) $(LIB-CASPER)
run: all
	./node_modules/.bin/electron .

clean: clean/desktop clean/widgets clean/utils
clean/desktop:
	-rm bin/desktop/app.js
	-rm bin/desktop/html/ui.js
clean/widgets:
	-rm bin/widgets/wheel/app.js
	-rm bin/widgets/polls/app.js
clean/utils:
	-rm bin/utils/rutony-mock.js
	-rm bin/utils/yt-parser.js

.PHONY: all clean clean/desktop clean/widgets clean/utils desktop desktop/ui desktop/app widgets widgets/wheel widgets/polls utils
