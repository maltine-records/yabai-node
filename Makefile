CC   = node_modules/coffee-script/bin/coffee
OBJS = public/javascripts/yabai.js


app.js: $(OBJS)
	$(CC) $*.coffee

.SUFFIXES: .coffee .js

.coffee.js:
	$(CC) -c $<

clean:
	rm -f $(OBJS)

