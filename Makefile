CC       = node_modules/coffee-script/bin/coffee
OBJS     = public/javascripts/yabai.js
REDISCLI = redis-cli
.SUFFIXES: .coffee .js


run: $(OBJS)
	-$(CC) app.coffee

.coffee.js:
	$(CC) -c $<

clean:
	-$(REDISCLI) del yabai
	rm -f $(OBJS)

