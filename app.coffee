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

	socket.on 'reload', (data) ->
		socket.broadcast.emit 'reload'

	socket.on 'announce', (data) ->
		socket.broadcast.emit 'announce', data

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
	keynameHour = "Yb:H:" + Math.ceil(dh.getTime()/1000)
	keynameMin  = "Yb:M:" + Math.ceil(dm.getTime()/1000)
	keynameSec  = "Yb:S:" + Math.ceil(now.getTime()/1000)

	client.incr keynameHour
	client.incr keynameMin
	client.incr keynameSec
	# depends redis 2.2 or lator
	client.expire keynameHour, (60 * 60 * 24) * 3
	client.expire keynameMin,  (60 * 60) * 3
	client.expire keynameSec,  60 * 3

	client.keys 'Yb:S:*', (err, replies) ->
		SPAN    = 20 #seconds
		now    = new Date();
		from    = Math.ceil(now.getTime()/1000 - SPAN) 
		targets = []

		for val in replies
			ii = parseInt val.substring(5), 10
			if ii > from
				targets.push "Yb:S:" + ii
		# node.js で時刻見るより redis に入れるときに
		# EXPIRE が SPAN 秒のやつも追加で入れちゃっていい気もしてきた


		client.mget targets, (err, replies) ->
			soku = 0
			for val in replies
				soku += parseInt val
			soku = soku/replies.length if replies.length
			client.set "Yabai:Soku", soku
			data =
				currentSoku: soku
			socket.emit 'currentSoku', data: data
			socket.broadcast.emit 'currentSoku', data: data

incrYabai = () ->
	date = new Date()
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
