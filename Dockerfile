FROM jare/alpine:latest

MAINTAINER JAremko <w3techplaygound@gmail.com>

ENV HOME /home/developer

ENV GOPATH /home/developer/workspace
ENV GOROOT /usr/lib/go
ENV GOBIN $GOROOT/bin
ENV NODEBIN /usr/lib/node_modules/bin
ENV PATH $PATH:$GOBIN:$GOPATH/bin:$NODEBIN

#              ssh   mosh
EXPOSE 80 8080 62222 60001/udp

COPY sshd_config /etc/ssh/sshd_config
COPY .spacemacs /home/developer/

ADD https://github.com/jaremko.keys /home/developer/.ssh/authorized_keys
ADD http://www.fontsquirrel.com/fonts/download/source-code-pro /tmp/scp.zip

RUN mkdir -p /usr/share/fonts/local                                                                  && \
    apk add --update fontconfig                                                                      && \
    fc-cache -f                                                                                      && \
    mkdir -p /home/developer/workspace                                                               && \      
    sed -i 's/0:0:root:\/root:\/bin\/ash/0:0:root:\/home\/developer:\/usr\/bin\/fish/g' /etc/passwd  && \
    apk add --update git curl tar fish docker bash mosh htop openssh unzip                              \
      --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community                  && \
    mkdir -p /home/developer/.fonts                                                                  && \
    unzip /tmp/scp.zip -d /usr/share/fonts/local                                                     && \

    echo "/usr/bin/fish" >> /etc/shells                                                              && \
    mkdir -p /home/developer/.config/fish                                                            && \
    echo "set -x HOME /home/developer" >> /home/developer/.config/fish/config.fish                   && \
    echo "set -x GOPATH /home/developer/workspace" >> /home/developer/.config/fish/config.fish       && \
    echo "set -x GOROOT /usr/lib/go" >> /home/developer/.config/fish/config.fish                     && \
    echo "set -x GOBIN $GOROOT/bin" >> /home/developer/.config/fish/config.fish                      && \
    echo "set -x NODEBIN /usr/lib/node_modules/bin" >> /home/developer/.config/fish/config.fish      && \
    echo "set -g fish_key_bindings fish_vi_key_bindings" >> /home/developer/.config/fish/config.fish && \
    echo "set --universal fish_user_paths $fish_user_paths $GOBIN $GOPATH/bin $NODEBIN"                 \
      >> /home/developer/.config/fish/config.fish                                                    && \
    fish -c source /home/developer/.config/fish/config.fish                                          && \
    curl -L https://github.com/oh-my-fish/oh-my-fish/raw/master/bin/install > /tmp/ohmf-install      && \
    fish /tmp/ohmf-install                                                                           && \

    find / -name ".git" -prune -exec rm -rf "{}" \;                                                  && \
    rm -rf /var/cache/apk/* /home/developer/workspace/* /tmp/*

#Golang

RUN apk --update add mercurial go godep                           \
      --update-cache --repository                                 \
      http://dl-3.alpinelinux.org/alpine/edge/community           \
      --allow-untrusted                                        && \
    mkdir -p /home/developer/workspace                         && \
    go get -u golang.org/x/tools/cmd/benchcmp                  && \
    go get -u golang.org/x/tools/cmd/callgraph                 && \
    go get -u golang.org/x/tools/cmd/digraph                   && \
    go get -u golang.org/x/tools/cmd/eg                        && \
    go get -u golang.org/x/tools/cmd/fiximports                && \
    go get -u golang.org/x/tools/cmd/godex                     && \
    go get -u golang.org/x/tools/cmd/godoc                     && \
    go get -u github.com/nsf/gocode                            && \
    go get -u golang.org/x/tools/cmd/gomvpkg                   && \
    go get -u golang.org/x/tools/cmd/gorename                  && \
    go get -u golang.org/x/tools/cmd/html2article              && \
    go get -u github.com/kisielk/errcheck                      && \
    go get -u golang.org/x/tools/cmd/oracle                    && \
    go get -u golang.org/x/tools/cmd/ssadump                   && \
    go get -u golang.org/x/tools/cmd/stringer                  && \
    go get -u golang.org/x/tools/cmd/vet                       && \
    go get -u golang.org/x/tools/cmd/vet/whitelist             && \
    go get -u code.google.com/p/rog-go/exp/cmd/godef           && \
    go get -u github.com/golang/lint/golint                    && \
    go get -u github.com/jstemmer/gotags                       && \
    go get -u gopkg.in/godo.v2/cmd/godo                        && \
    go get -u github.com/fsouza/go-dockerclient                && \
    apk del mercurial                                          && \

    find / -name ".git" -prune -exec rm -rf "{}" \;            && \
    rm -rf /var/cache/apk/* /home/developer/workspace/* /tmp/*

#TypeScript

RUN apk --update add nodejs                                     && \
    mkdir -p /usr/lib/node_modules/bin                          && \
    ln -s /usr/bin/node /usr/local/bin/node                     && \
    ln -s /usr/bin/node /usr/lib/node_modules/bin/node          && \
    curl -L https://www.npmjs.com/install.sh | bash             && \
    npm cache clean -f                                          && \
    npm install -g n                                            && \
    n stable                                                    && \

    npm install --prefix /usr/lib/node_modules/ -g typescript   && \
    npm install tsd -g                                          && \
    npm install http-server -g                                  && \

    find / -name ".git" -prune -exec rm -rf "{}" \;             && \
    rm -rf /var/cache/apk/* /home/developer/workspace/* /tmp/*

#Spacemacs

RUN apk --update add emacs --update-cache --repository                  \
      http://dl-3.alpinelinux.org/alpine/edge/testing                && \
    git clone https://github.com/syl20bnr/spacemacs.git                 \
      --branch develop --single-branch /home/developer/.emacs.d      && \
    rm -rf /home/developer/.emacs.d/private/snippets                 && \
    git clone https://github.com/AndreaCrotti/yasnippet-snippets.git    \
      /home/developer/.emacs.d/private/snippets                      && \
    emacs -nw -batch -u "root" -kill                                 && \

    find / -name ".git" -prune -exec rm -rf "{}" \;                  && \
    rm -rf /var/cache/apk/* /home/developer/workspace/* /tmp/*

ENTRYPOINT ["/usr/bin/emacs"]

