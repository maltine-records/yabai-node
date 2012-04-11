socket = io.connect()

socket.on 'connect', () ->
	console.log 'connect'

socket.on 'message', (msg) ->
	console.log msg

socket.on 'yabai', (msg) ->
	yabai = msg.data.yabai
	$('#display').text(yabai)

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

socket.on 'announce', (msg) ->
	$('#announce').text(msg.announce)

@yabai = () ->
	socket.emit 'yabai', [1]

@oquno = ()->
	socket.emit 'oquno', [1]

@oquno = ()->
	socket.emit 'youpy', [1]

@announce = ()->
	data =
		announce: $('#announce').val()
	socket.emit 'announce', data

