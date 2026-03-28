#!/bin/bash
set -eu

# génère un certificat auto-signé s'il n'existe pas
# -keyout : stocke la clé
# -out : stocke le certificat
# -subj : remplit automatiquement le certificat
if [ ! -f /etc/nginx/ssl/nginx.crt ]; then
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout /etc/nginx/ssl/nginx.key \
		-out /etc/nginx/ssl/nginx.crt \
		-subj "/C=FR/ST=France/L=Paris/O=42/CN=${DOMAIN_NAME}" 2>/dev/null
fi

# Lance nginx en foreground (PID 1)
# daemon off : garde nginx actif au premier plan
echo "Demarrage Nginx..."
exec nginx -g "daemon off;"