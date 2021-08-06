FROM alpine:3.12.3

ENV TEXT_EXTRACTION_CONFIG=config.json

# install and initialize
RUN    apk update \
    && apk --no-cache add bash tzdata perl xclip \
    && cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && apk add --no-cache --virtual .build-deps \
               gcc musl-dev g++ libgcc libstdc++ make libc-dev linux-headers \
               perl-utils perl-dev perl-extutils-libbuilder perl-extutils-pkgconfig perl-extutils-depends \
    && PERL_AUTOINSTALL='--defaultdeps' cpan -r \
    && PERL_AUTOINSTALL='--defaultdeps' cpan install Clipboard JSON String::Util \
    && apk --purge del .build-deps \
    && mkdir -p /code \
    && rm -rf /root/.cache /var/cache/apk/* /tmp/*

CMD ["perl", "-de0"]
