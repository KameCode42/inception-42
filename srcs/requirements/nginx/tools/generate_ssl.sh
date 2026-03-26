#!/bin/bash
set -eu

# genere un certificat auto-singer si il n'existe pas
if [ ! -f /etc/nginx/ssl/nginx.crt ]; then
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout /etc/nginx/ssl/nginx.key \
		-out /etc/nginx/ssl/nginx.crt \
		-subj "/C=FR/ST=France/L=Paris/O=42/CN=${DOMAIN_NAME}" 2>/dev/null

# # lance nginx en foreground (PID 1)
echo "Starting Nginx..."
exec nginx -g "daemon off;"
