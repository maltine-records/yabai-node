#! /usr/bin/env node_modules/coffee-script/bin/coffee
# author: takano32 <tak@no32 dot tk>
# vim: noet sts=4:ts=4:sw=4
#

cluster = require 'cluster'
os = require 'os'
express = require 'express'
coffee = require 'coffee-script'

app = express.createServer()

app.use express.static(__dirname + '/public')

eco = require 'eco'
redis = require 'redis'
client = redis.createClient()

client.on "error", (err) ->
	console.log "Error: #{err}"

app.get '/', (req, res) ->
	# client.del('yabai', redis.print)
	client.get 'yabai', (err, reply) ->
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

if cluster.isMaster
	for i in [1...os.cpus().length]
		worker = cluster.fork()
else
	app.listen process.env.PORT || 3000

io = require('socket.io').listen app
io.set "log level", 2

io.sockets.on 'connection', (socket) ->
	console.log 'connection'

	socket.on 'yabai', (data) ->
		client.incr 'yabai', (err, reply) ->
			data =
				yabai: reply
			socket.emit 'yabai', data: data
			socket.broadcast.emit 'yabai', data: data
		updateSoku(socket)
		incrYabai()


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

	setInterval ->
		client.get "Yabai:Soku", (err, reply) ->
			try
				soku = reply.toString()
				data = 
					currentSoku: soku
				socket.emit 'currentSoku', data: data
				socket.broadcast.emit 'currentSoku', data: data
			catch e
				console.error e
	,1000


if cluster.isMaster
	setInterval ->
		client.keys 'Yabai:S:*', (err, replies) ->
			SPAN    = 20 #seconds
			now     = new Date();
			from    = Math.ceil(now.getTime()/1000 - SPAN) 
			targets = []

			skiplen = "Yabai:S:".length
			for val in replies
				ii = parseInt val.substring(skiplen), 10
				if ii > from
					targets.push "Yabai:S:" + ii

			client.mget targets, (err, replies) ->
				soku = 0
				try
					for val in replies
						soku += parseInt val, 10
					soku = soku/replies.length if replies.length
					client.set "Yabai:Soku", soku
				catch e
#					console.log e
	, 1000


app.listen(process.env.PORT || 3000)

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


incrYabai = () ->
	date = new Date()

	###
	yy = date.getYear()
	mm = date.getMonth() + 1
	dd = date.getDate()
	if yy < 2000
		yy += 1900
	if mm < 10
		mm = "0" + mm
	if dd < 10
		dd = "0" + dd
	fmt_date = "#{yy}-#{mm}-#{dd}"

	hh = date.getHours()
	mm = date.getMinutes()
	ss = date.getSeconds()
	if hh < 10
		hh = "0" + hh
	if mm < 10
		mm = "0" + mm
	if ss < 10
		ss = "0" + ss
	fmt_time = "#{hh}:#{mm}:#{ss}"

	client.incr "Yabai:#{fmt_date}_#{fmt_time}"
	###

	client.incr "Yabai:yabai:#{Math.floor((date)/1000)}"
