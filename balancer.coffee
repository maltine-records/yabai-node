#! /usr/bin/env node_modules/coffee-script/bin/coffee
# author: takano32 <tak@no32 dot tk>
# vim: noet sts=4:ts=4:sw=4
#

coffee = require 'coffee-script'
http = require 'http'
httpProxy = require 'http-proxy'

addrs = [
	node1 =
		host: 'localhost'
		port: 3000
	node2 =
		host: 'localhost'
		port: 3001
	node3 =
		host: 'localhost'
		port: 3002
]

proxy = httpProxy.createServer (req, res, proxy) ->
	target = addrs.shift()
	console.log "balancing request to: #{target['host']}:#{target['port']}"
	proxy.proxyRequest(req, res, target)
	addrs.push(target)
proxy.listen 8080

# host1 and host2
###
http.createServer (req, res) ->
	headers =
		'Content-Type': 'text/plain'
	res.writeHead 200, headers
	res.write 'Hi, This is host1.'
	res.end()
.listen 9000, '0.0.0.0'


http.createServer (req, res) ->
	headers =
		'Content-Type': 'text/plain'
	res.writeHead 200, headers
	res.write 'Hi, This is host2.'
	res.end()
.listen 9001, '0.0.0.0'
###
