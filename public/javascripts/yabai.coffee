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
	attr =
		title: 'oquno'
		alt: 'oquno'
		src: 'http://oq.la/i'
	$('#display').prepend($('<img>').attr(attr))

socket.on 'youpy', (msg) ->
	attr =
		rel: 'stylesheet'
		href: 'http://oq.la/y2'
	$('head').append($('<link>').attr(attr))

socket.on 'reload', (msg) ->
	location.reload()

socket.on 'announce', (msg) ->
	$('#announce').text(msg.announce)

@yabai = () ->
	socket.emit 'yabai'

@oquno = ()->
	socket.emit 'oquno'

@youpy = ()->
	socket.emit 'youpy'

@reload = ()->
	socket.emit 'reload'

@announce = ()->
	data =
		announce: $('#announce').val()
	socket.emit 'announce', data

