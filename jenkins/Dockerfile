#For Debian 9
FROM debian:stretch-slim

RUN set -x \
  && apt-get update && apt-get upgrade -y \
  && apt-get update && apt-get install -y nginx \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/www/html/index.nginx-debian.html  

COPY index.html /var/www/html/

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
