CC       = node_modules/coffee-script/bin/coffee
OBJS     = public/javascripts/yabai.js
REDISCLI = redis-cli
TARGET   = app.js
PAGER    = lv
.SUFFIXES: .coffee .js


run: $(OBJS)
	-$(CC) app.coffee

run3: $(OBJS)
	- PORT=3000 $(CC) app.coffee &
	- PORT=3001 $(CC) app.coffee &
	- PORT=3002 $(CC) app.coffee &
	- $(CC) balancer.coffee

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
	npm install


dbsize:
	$(REDISCLI) dbsize

