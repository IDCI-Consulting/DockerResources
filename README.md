Symfony docker resources
========================

A set of docker resources to get quickly started on a symfony project

Getting started
---------------

* Copy the `docker` directory, the `docker-compose.yml`, the `.env` and `Makefile` in your symfony project
* Remove useless parts in each of theses files
* Change values in `.env` file
* Update `app_dev.php` to allow dockerized applications. (Comment the code from line 12 to 19)

Then run your containers:

```bash
docker network create dev
docker-compose -f docker/proxy-docker-compose.yml up -d         # run the proxy
docker-compose -f docker/elasticsearch-docker-compose.yml up -d # run the elasticsearch
docker-compose up -d                                            # run the entire stack
````

Node.js
-------

If you want to install `npm` & `bower` packages, you can use the Makefile commands:

```sh
$ make npm-install
$ make bower-install
```

Benefit
-------

* Easily change your php version from the `.env`
* Use the makefile to auto complete daily commands
* Display all logs (proxy, nginx, php) with the `docker-compose logs -f command`.

Tests
-----

To execute units and functionals tests:
```sh
$ make phpunit sources=src
```

To execute code sniffer :
```sh
$ make phpcs sources=src
```

'src' is the default sources value.


Todo
----

Use the greatness of the ELK stack
