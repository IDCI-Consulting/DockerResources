#!/bin/bash

git clone $GIT_REPO_URL -b $GIT_BRANCH /var/www/html
composer install -d /var/www/html
