CC       = node_modules/coffee-script/bin/coffee
OBJS     = public/javascripts/yabai.js
REDISCLI = redis-cli
TARGET   = app.js
PAGER    = lv
.SUFFIXES: .coffee .js


run: $(OBJS)
	-$(CC) app.coffee


autorespawn: $(OBJS)
	while :; do $(CC) app.coffee ; date >> respawn.log; done

.coffee.js:
	$(CC) -c $<

#clean:
#	-$(REDISCLI) FLUSHDB
#	rm -f $(OBJS) $(TARGET)

view: $(TARGET)
	$(PAGER) $?


setup:
	@npm install coffee-script
	@npm install express
	@npm install socket.io
	@npm install eco
	@npm install redis
	@npm install cluster
	@npm install jsonreq


dbsize:
	$(REDISCLI) dbsize

