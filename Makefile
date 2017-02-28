# Variables

target_container    ?= php
php_sources         ?= .
js_sources          ?= Resources/public/js
phpcs_ignored_files ?= vendor/*,app/cache/*

# Change the previous variable with the following parameters for standalone bundle
#phpcs_ignored_files ?= vendor/*,app/cache/*,Tests/cache/*

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

# NodeJs commands

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
	docker run --rm -i -v `pwd`:/project jolicode/phaudit bash -c "phploc $(php_sources); exit $$?"

.PHONY: phpcs
phpcs:
	docker run --rm -i -v `pwd`:/project jolicode/phaudit bash -c "phpcs $(php_sources) --extensions=php --ignore=$(phpcs_ignored_files) --standard=PSR2; exit $$?"

.PHONY: phpcpd
phpcpd:
	docker run --rm -i -v `pwd`:/project jolicode/phaudit bash -c "phpcpd $(php_sources); exit $$?"

.PHONY: phpdcd
phpdcd:
	docker run --rm -i -v `pwd`:/project jolicode/phaudit bash -c "phpdcd $(php_sources); exit $$?"


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
