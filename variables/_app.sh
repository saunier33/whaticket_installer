#!/bin/bash
#
# Variables to be used for background styling.

# app variables

jwt_secret=3123123213123
jwt_refresh_secret=75756756756

deploy_password=$(openssl rand -base64 8)

mysql_root_password=$(openssl rand -base64 32)

db_pass=$(openssl rand -base64 32)

db_user=whaticket
db_name=whaticket

deploy_email=deploy@whaticket.com
