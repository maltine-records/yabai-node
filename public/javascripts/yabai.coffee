socket = io.connect()

socket.on 'connect', () ->
	console.log 'connect'

socket.on 'message', (msg) ->
	console.log msg

socket.on 'yabai', (msg) ->
	yabai = msg.data.yabai
	$('#display').text(yabai)

@yabai = () ->
	socket.emit 'yabai', [1]

