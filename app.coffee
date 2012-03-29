#! /usr/bin/env coffee
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
	client.get('yabai', (err, value) ->
		if yabai == null
			client.set('yabai', '1')
			yabai = 1
		else
			client.incr('yabai', (err, reply) ->
				console.log reply
				yabai = reply
				data =
					title: 'YABAI'
					yabai: yabai
				res.render 'index.html.eco', data: data
			)
	)


if cluster.isMaster
	for i in [0...os.cpus().length]
		worker = cluster.fork()
else
	app.listen(process.env.PORT || 3000)


