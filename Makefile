# Variables

mysql_password    = MYSQL_PASSWORD
mysql_user        = MYSQL_USER
mysql_dbname      = MYSQL_DBNAME

mongo_collection  = MONGO_COLLECTION
mongo_dbname      = MONGO_DBNAME

target_container ?= php
sources          ?= src

mysql_container_name = $(shell docker-compose ps |grep '^[a-Z-]*-mysql' |sed 's/-mysql .*/-mysql/')
mongo_container_name = $(shell docker-compose ps |grep '^[a-Z-]*-mongo' |sed 's/-mongo .*/-mongo/')

# Bash Commands

.PHONY: command
command:
	docker-compose run --rm $(target_container) $(cmd)

.PHONY: bash
bash:
	docker-compose exec '$(target_container)' bash

# Mysql commands

.PHONY: mysql-export
mysql-export:
	docker exec -i $(mysql_container_name) bash -c "mysqldump -p$(mysql_password) -u$(mysql_user) $(mysql_dbname)" > $(path)

.PHONY: mysql-import
mysql-import:
	docker exec -i $(mysql_container_name) bash -c "mysql -p$(mysql_password) -u$(mysql_user) $(mysql_dbname)" < $(path)

# Mongo commands

.PHONY: mongo-export
mongo-export:
	docker exec -i $(mongo_container_name) bash -c "mongoexport --db $(mongo_dbname) --collection $(mongo_collection)" > $(path)

.PHONY: mongo-import
mongo-import:
	docker exec -i $(mongo_container_name) bash -c "mongoimport --db $(mongo_dbname) --collection $(mongo_collection)" < $(path)


# NodeJs commands

.PHONY: npm-install
npm-install:
	docker-compose run --rm node npm install

.PHONY: gulp
gulp:
	docker-compose run --rm node gulp $(task)


# PHP commands

.PHONY: composer-add-github-token
composer-add-github-token:
	docker-compose run --rm php composer config --global github-oauth.github.com $(token)

.PHONY: composer-update
composer-update:
	docker-compose run --rm php composer update

.PHONY: composer-install
composer-install:
	docker-compose run --rm php composer install

.PHONY: phploc
phploc:
	docker run -i -v `pwd`:/project jolicode/phaudit bash -c "phploc $(sources); exit $$?"

.PHONY: phpcs
phpcs:
	docker run -i -v `pwd`:/project jolicode/phaudit bash -c "phpcs $(sources) --standard=PSR2; exit $$?"

.PHONY: phpcpd
phpcpd:
	docker run -i -v `pwd`:/project jolicode/phaudit bash -c "phpcpd $(sources); exit $$?"

.PHONY: phpdcd
phpdcd:
	docker run -i -v `pwd`:/project jolicode/phaudit bash -c "phpdcd $(sources); exit $$?"


# Symfony bundle commands

.PHONY: phpunit
phpunit: ./vendor/bin/phpunit
	docker-compose run --rm php ./vendor/bin/phpunit --coverage-text


# Symfony2.x app commands

.PHONY: pac
pac:
	docker-compose run --rm php php app/console $(cmd)

.PHONY: phpunit
phpunit: ./vendor/phpunit/phpunit/phpunit.php ./app/phpunit.xml.dist
	docker-compose run --rm php php ./vendor/phpunit/phpunit/phpunit.php -c app/

default: pac


# Symfony3.x app commands

.PHONY: pbc
pbc:
	docker-compose run --rm php php bin/console $(cmd)

default: pbc
