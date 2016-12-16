nginx_container_name = acme-app-nginx
php_container_name = acme-app-php
mysql_container_name =  acme-app-mysql

.PHONY: pac bash composer-add-github-token composer-update mysql-export mysql-import command

pac:
	docker exec -it $(php_container_name) php app/console $(cmd)

bash:
	docker exec -it $(php_container_name) bash

composer-add-github-token:
	docker exec -it $(php_container_name) composer config --global github-oauth.github.com $(token)

composer-update:
	docker exec -it $(php_container_name) composer update

mysql-export:
	docker exec -i $(mysql_container_name) bash -c "mysqldump -p'app' -u app app" > $(path)

mysql-import:
	docker exec -i $(mysql_container_name) bash -c "mysql -p'app' -u app app" < $(path)

command:
	docker exec -it $(php_container_name) $(cmd)

default: pac
