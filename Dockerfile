FROM jare/spacebox

MAINTAINER JAremko <w3techplaygound@gmail.com>

ENV UNAME="jare"

RUN git config --global user.name JAremko \
    && git config --global user.email w3techplayground@gmail.com

# Ubuntu Xenial
RUN apt-get update \
    && apt-get install firefox \
    && rm -rf /tmp/* /var/lib/apt/lists/*

COPY .spacemacs "${UHOME}/.spacemacs"
COPY private "${UHOME}/.emacs.d/private"

RUN install-deps
