# vim: noet sts=4:ts=4:sw=4
socket = io.connect('http://maltinerecords2.cs8.biz')

socket.on 'connect', () ->
	console.log 'connect'

socket.on 'message', (msg) ->
	console.log msg

socket.on 'yabai:ore', (msg) ->
	yabai = msg.data.yabai
	$('#display').text(yabai)

@othersEffectTimer = 0
socket.on 'yabai:orera', (msg) ->
	yabai = msg.data.yabai
	$('#display').text(yabai)
	$('.yabaiButton').addClass('orera');
	clearTimeout(@othersEffectTimer)
	@othersEffectTimer = setTimeout () ->
	  $('.yabaiButton').removeClass('orera');
	, 50

socket.on 'currentSoku', (msg) ->
	currentSoku = msg.data.currentSoku
	$('#groovegauge').width(currentSoku*30)
	$('#currentSoku').text(currentSoku)

socket.on 'oquno', (msg) ->
	return unless location.pathname == '/'
	$('.ui-content').css('background-image', 'url(http://oq.la/i)')

socket.on 'youpy', (msg) ->
	return unless location.pathname == '/'
	attr =
		rel: 'stylesheet'
		href: 'http://oq.la/y2'
	$('head').append($('<link>').attr(attr))
socket.on 'pikachu', (msg) ->
	return unless location.pathname == '/'
	$('.ui-content').css('background-image', 'url(/img/pikachu.gif)')
	
socket.on 'reload', (msg) ->
	return unless location.pathname == '/'
	location.reload()

socket.on 'normal', (msg) ->
	return unless location.pathname == '/'
	# oquno
	$("#image > img").remove()
	$.mobile.changePage($("#top"))
	# youpy
	$("head > link[href*='oq.la']").remove()
	# pikachu
	$('.ui-content').css('background-image', 'none')

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
	$('.ui-content').css('background-image', 'url(' + msg.background + ')')
	

@myEffectTimer = 0
@yabai = () ->
	@yabaiStart()
	@yabaiRelease()

@yabaiStart = (event) ->
	$('.yabaiButton').addClass('ore')
	clearTimeout(@myEffectTimer)
	socket.emit 'yabai'


@yabaiRelease = (event) ->
	@myEffectTimer = setTimeout () ->
    $('.yabaiButton').removeClass('ore')
	, 50


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


$('.yabaiButton').live('touchstart', @yabaiStart)
$('.yabaiButton').live('touchend', @yabaiRelease)
$('.yabaiButton').live('mousedown', @yabaiStart)
$('.yabaiButton').live('mouseup', @yabaiRelease)

