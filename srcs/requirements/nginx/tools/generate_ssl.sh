#!/bin/bash
set -eu

# genere un certificat auto-singer si il n'existe pas
# -keyout : stocke la clef
# -out : stocke le certificat
# -subj : rempli automatiquement le certificat
if [ ! -f /etc/nginx/ssl/nginx.crt ]; then
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout /etc/nginx/ssl/nginx.key \
		-out /etc/nginx/ssl/nginx.crt \
		-subj "/C=FR/ST=France/L=Paris/O=42/CN=${DOMAIN_NAME}" 2>/dev/null

echo "Demarrage Nginx..."

# lance nginx en foreground (PID 1)
# daemon off : garde nginx actif au premier plan
exec nginx -g "daemon off;"
