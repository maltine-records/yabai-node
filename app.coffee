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
			console.log reply
			value = reply
			data =
				yabai: value
			socket.emit 'yabai', data: data
			socket.broadcast.emit 'yabai', data: data

	socket.on 'oquno', (data) ->
		socket.broadcast.emit 'oquno'

	socket.on 'announce', (data) ->
		socket.broadcast.emit 'announce', data

app.listen(process.env.PORT || 3000)

