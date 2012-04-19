============================
YABAI Button in CoffeeScript
============================

Base Components
===============

- http://nodejs.org/

  - http://npmjs.org/

    - http://coffeescript.org/

- http://redis.io/

Node Modules
============

install w/ npm

- coffee-script

- express

- socket.io

- eco

- redis

- cluster

- jsonreq

Note
===

::

        json = require 'jsonreq'

        json.get 'http://hnnhn.com/fire/json/', (err, data) ->
                for image in data.images
                        for id, url of image
                                console.log id
                                console.log url
