# Variables

target_container ?= php
php_sources      ?= src
js_sources       ?= Resources/public/js

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
	docker exec -i $(mysql_container_name) bash -c 'mysqldump -p$$MYSQL_PASSWORD -u$$MYSQL_USER $$MYSQL_DATABASE' > $(path)

.PHONY: mysql-import
mysql-import:
	docker exec -i $(mysql_container_name) bash -c 'mysql -p$$MYSQL_PASSWORD -u$$MYSQL_USER $$MYSQL_DATABASE' < $(path)

# Mongo commands

.PHONY: mongo-export
mongo-export:
	docker exec -i $(mongo_container_name) bash -c 'mongoexport --db $$MONGO_DATABASE --collection $(mongo_collection)' > $(path)

.PHONY: mongo-import
mongo-import:
	docker exec -i $(mongo_container_name) bash -c 'mongoimport --db $$MONGO_DATABASE --collection $(mongo_collection)' < $(path)


# NodeJs commands

.PHONY: npm-install
npm-install:
	docker-compose run --rm node npm install

.PHONY: gulp
gulp:
	docker-compose run --rm node gulp $(task)

.PHONY: eslint
eslint:
	docker-compose run --rm node eslint $(js_sources)


# PHP commands

.PHONY: composer-add-github-token
composer-add-github-token:
	docker-compose run --rm php composer config --global github-oauth.github.com $(token)

.PHONY: composer-update
composer-update:
	docker-compose run --rm php composer update $(options)

.PHONY: composer-install
composer-install:
	docker-compose run --rm php composer install $(options)

.PHONY: phploc
phploc:
	docker run -i -v `pwd`:/project jolicode/phaudit bash -c "phploc $(php_sources); exit $$?"

.PHONY: phpcs
phpcs:
	docker run -i -v `pwd`:/project jolicode/phaudit bash -c "phpcs $(php_sources) --standard=PSR2; exit $$?"

.PHONY: phpcpd
phpcpd:
	docker run -i -v `pwd`:/project jolicode/phaudit bash -c "phpcpd $(php_sources); exit $$?"

.PHONY: phpdcd
phpdcd:
	docker run -i -v `pwd`:/project jolicode/phaudit bash -c "phpdcd $(php_sources); exit $$?"


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
