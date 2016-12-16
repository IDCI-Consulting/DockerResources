Symfony docker resources
========================

A set of docker resources to get quickly started on a symfony project

Getting started
---------------

* Copy the **docker** directory, the **docker-compose.yml** and **Makefile** in your symfony project.
* Edit the volumes, environment and container_name values in the docker-compose.yml according to your needs. (Do not use special chars in mysql env variables except underscores)
* Edit the Makefile variables

Then run your containers:

```bash
docker network create dev
docker-compose -f docker/proxy.yml up -d # run the proxy
docker-compose up -d                     # run the entire stack
````

Benefit
-------

* Easily change your php version from the docker-compose file
* Use the makefile to auto complete daily commands
* Display all logs (proxy, nginx, php) with the **docker-compose logs -f command**.

Todo
----

Use the greatness of the ELK stack