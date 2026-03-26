FROM		debian:bookworm

RUN 		apt-get update -y && apt-get upgrade -y && \
			apt-get -y install wget && \
			apt-get install -y \
			php8.3-fpm \
			php8.3-mysql \
			mariadb-client \
			&& rm -rf /var/lib/apt/lists/*





ENTRYPOINT	["/usr/local/bin/setup.sh"]
