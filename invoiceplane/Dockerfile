FROM mhzawadi/invoiceplane:dev

RUN apk update

RUN apk add \
    php7-session php7-fpm php7-curl php7-dom php7-xml php7-xmlwriter  \
    php7-tokenizer php7-simplexml php7-gd php7-gmp php7-gettext php7-pcntl  \
    php7-mysqli php7-sockets php7-ctype php7-pecl-mcrypt php7-xmlrpc \
    php7-cli php7-phar php7-iconv php7-mbstring php7-json

CMD ["/bin/sh"]