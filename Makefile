CC       = node_modules/coffee-script/bin/coffee
OBJS     = public/javascripts/yabai.js
REDISCLI = redis-cli
TARGET   = app.js
PAGER    = lv
.SUFFIXES: .coffee .js


run: $(OBJS)
	-$(CC) app.coffee

.coffee.js:
	$(CC) -c $<

clean:
	-$(REDISCLI) FLUSHDB
	rm -f $(OBJS) $(TARGET)

view: $(TARGET)
	$(PAGER) $?


dbsize:
	$(REDISCLI) dbsize

