#!/usr/bin/env bash
set -Eeuo pipefail

genRandStr(){
    cat /dev/urandom | tr -dc [:alnum:] | head -c $1
}

sed -i -e "s/salt0/$(genRandStr 32)/g" -e "s/salt1/$(genRandStr 16)/g" -e "s/salt2/$(genRandStr 16)/g" -e "s/salt3/$(genRandStr 16)/g" -e "s/_judger_socket_password_/$(genRandStr 32)/g" /var/www/uoj/app/.config.php

exec "$@"
