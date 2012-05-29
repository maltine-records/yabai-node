socket = io.connect()

socket.on 'connect', () ->
	console.log 'connect'

socket.on 'message', (msg) ->
	console.log msg

socket.on 'yabai', (msg) ->
	yabai = msg.data.yabai
	$('#display').text(yabai)

socket.on 'currentSoku', (msg) ->
	currentSoku = msg.data.currentSoku
	$('#groovegauge').width(currentSoku*30)
	$('#currentSoku').text(currentSoku)

socket.on 'oquno', (msg) ->
	return unless location.pathname == '/'
	attr =
		title: 'oquno'
		alt: 'oquno'
		src: 'http://oq.la/i'
	$('#oquno').append($('<img>').attr(attr))
	$.mobile.changePage($("#oquno"))

socket.on 'youpy', (msg) ->
	return unless location.pathname == '/'
	attr =
		rel: 'stylesheet'
		href: 'http://oq.la/y2'
	$('head').append($('<link>').attr(attr))
socket.on 'pikachu', (msg) ->
	return unless location.pathname == '/'
	attr =
		background: '/img/pikachu.gif'
	$('body').attr(attr)
	
socket.on 'reload', (msg) ->
	return unless location.pathname == '/'
	location.reload()

socket.on 'normal', (msg) ->
	return unless location.pathname == '/'
	# oquno
	# $("#oquno > img[src*='oq.la']").remove()
	$.mobile.changePage($("#top"))
	# youpy
	$("head > link[href*='oq.la']").remove()
	# pikachu
	$("body").removeAttr("background")

socket.on 'announce', (msg) ->
	return unless location.pathname == '/'
	$('#announce').text(msg.announce)

socket.on 'fire', (msg) ->
	$('.fire').remove()
	for images in msg.images.glitch
		for id, url of images
			attr =
				onClick: "$('#background').val('#{url}');background();"
				class:   "fire"
				type:    'button'
				name:    id
				value:   url
			$('#fire').append($('<button>').attr(attr).text(id))

socket.on 'background', (msg) ->
	return unless location.pathname == '/'
	attr =
		background: msg.background
	$('body').attr(attr)

@yabai = () ->
	socket.emit 'yabai'

@oquno = ()->
	socket.emit 'oquno'

@youpy = ()->
	socket.emit 'youpy'

@pikachu = ()->
	socket.emit 'pikachu'

@reload = ()->
	socket.emit 'reload'

@normal = ()->
	socket.emit 'normal'

@announce = ()->
	data =
		announce: $('#announce').val()
	socket.emit 'announce', data

@fire = () ->
	socket.emit 'fire'

@background = ()->
	data =
		background: $('#background').val()
	socket.emit 'background', data
