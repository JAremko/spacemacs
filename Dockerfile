FROM spacemacs/emacs-snapshot:develop

MAINTAINER JAremko <w3techplaygound@gmail.com>

ENV UNAME="jare"

# Ubuntu Xenial
RUN apt-get update \
    && apt-get install firefox \
    && rm -rf /tmp/* /var/lib/apt/lists/*

COPY .spacemacs "${UHOME}/.spacemacs"
COPY private "${UHOME}/.emacs.d/private"

# Install Spacemacs layers dependencies and init user
RUN install-deps

USER $UNAME
RUN git config --global user.name JAremko \
    && git config --global user.email w3techplayground@gmail.com
USER root
