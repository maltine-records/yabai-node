#! /usr/bin/env node_modules/coffee-script/bin/coffee
# author: takano32 <tak@no32 dot tk>
# vim: noet sts=4:ts=4:sw=4
#

os = require 'os'
coffee = require 'coffee-script'

express = require 'express'
app = express()
http = require 'http'
server = http.createServer(app)

eco = require 'eco'
app.engine ".eco", eco

io = require 'socket.io'
socket = io.listen(server)

app.use express.static(__dirname + '/public')


redis = require 'redis'
client = redis.createClient()

client.on "error", (err) ->
	console.log "Error: #{err}"

app.get '/', (req, res) ->
	# client.del('yabai', redis.print)
	client.get 'Yabai:yabai', (err, reply) ->
		data =
			title: 'YABAI'
			yabai: reply
		res.render 'index.html.eco', data: data
		
app.get '/cebui', (req, res) ->
	client.get 'yabai', (err, reply) ->
		data =
			title: 'CEBUI'
			yabai: reply
		res.render 'admin.html.eco', data: data


# API
app.get '/yabasa', (req, res) ->
	client.get "Yabai:Soku", (err, reply) ->
		res.charset = 'utf-8'
		res.header 'Content-Type', 'application/json'
		try
			soku = reply.toString()
			data =
				soku: soku
			res.send(data)
		catch e
			res.send("{}")

server.listen process.env.PORT || 3000

socket.set "log level", 2

socket.sockets.on 'connection', (socket) ->
	console.log 'connection'
	clientSoku = 0

	socket.on 'yabai', (data) ->
		addr = socket.handshake.address.address
		if(clientSoku++ > 30)
			socket.disconnect()
			console.log addr + " was forced to disconnect; suspicious rate too fast of Tashiro.";
			return

		client.incr 'Yabai:yabai', (err, reply) ->
			data =
				yabai: reply
			socket.volatile.emit 'yabai:ore', data: data
			socket.volatile.broadcast.emit 'yabai:orera', data: data
		updateSoku(socket)
		incrYabai(addr)
		client.incr 'Yabai:odo'
		client.incr 'Yabai:trip:a'



	socket.on 'oquno', (data) ->
		socket.broadcast.emit 'oquno'

	socket.on 'youpy', (data) ->
		socket.broadcast.emit 'youpy'

	socket.on 'pikachu', (data) ->
		socket.broadcast.emit 'pikachu'

	socket.on 'reload', (data) ->
		socket.broadcast.emit 'reload'

	socket.on 'normal', (data) ->
		socket.broadcast.emit 'normal'

	socket.on 'announce', (data) ->
		socket.broadcast.emit 'announce', data

	socket.on 'fire', (req) ->
		json = require 'jsonreq'
		json.get 'http://hnnhn.com/fire/json/', (err, res) ->
			data =
				images: res.images
			socket.emit 'fire', data

	socket.on 'background', (data) ->
		socket.broadcast.emit 'background', data

	socket.on 'disconnect', ->
		clearInterval timerId

	timerId = setInterval ->
#		console.warn("-");
		clientSoku = 0
		client.get "Yabai:Soku", (err, reply) ->
			try
				soku = reply.toString()
				data =
					currentSoku: soku
				socket.volatile.emit 'currentSoku', data: data
			catch e
				console.error e
				throw e
	,1000


setInterval ->
	client.keys 'Yabai:S:*', (err, replies) ->
		SPAN    = 60 #seconds
		now     = new Date()
		from    = Math.ceil(now.getTime()/1000 - SPAN)
		targets = []

		skiplen = "Yabai:S:".length
		for val in replies
			ii = parseInt val.substring(skiplen), 10
			if ii > from
				targets.push "Yabai:S:" + ii

		client.mget targets, (err, replies) ->
			soku = 1.0
			try
				# sigmoid: 1/1+exp(-ax)
				# max is 1, and min(0) is 0.5. so 8*sigmoid-3 will be [1,5]
				# if a is smaller, soku will increase slower
				soku = 8.0 / (1.0 + Math.exp(-replies.length/10)) - 3 if replies.length
				client.set "Yabai:Soku", soku
			catch e
#					console.log e
				client.set "Yabai:Soku", soku
				#throw e
, 1000


updateSoku = (socket) ->
	now  = new Date()
	year = now.getFullYear()
	month = now.getMonth()
	date = now.getDate()
	hours = now.getHours()
	minutes = now.getMinutes()

	dh    = new Date(year, month, date, hours, 0, 0, 0)
	dm    = new Date(year, month, date, hours, minutes, 0, 0)
	keynameHour = "Yabai:H:" + Math.ceil(dh.getTime()/1000)
	keynameMin  = "Yabai:M:" + Math.ceil(dm.getTime()/1000)
	keynameSec  = "Yabai:S:" + Math.ceil(now.getTime()/1000)

	client.incr keynameHour
	client.incr keynameMin
	client.incr keynameSec
	# depends redis 2.2 or lator
	client.expire keynameHour, (60 * 60 * 24) * 3
	client.expire keynameMin,  (60 * 60) * 3
	client.expire keynameSec,  60 * 3


incrYabai = (addr) ->
	date = new Date()
	client.incr "Yabai:yabai:count:at:#{Math.floor((date)/1000)}"
	client.incr "Yabai:yabai:from:#{addr}:at:#{Math.floor((date)/1000)}"
	console.log "Yabai:yabai:from:#{addr}:at:#{Math.floor((date)/1000)}"
