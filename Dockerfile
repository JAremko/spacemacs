FROM jare/alpine:latest

MAINTAINER JAremko <w3techplaygound@gmail.com>

RUN apk add --update tar sudo fontconfig curl git htop unzip mosh-client && rm -rf /var/cache/apk/*

# Setup user

RUN export uid=1000 gid=1000                                                && \
    mkdir -p /home/jare/workspace                                           && \
    echo "jare:x:${uid}:${gid}:jare,,,:/home/jare:/bin/bash" >> /etc/passwd && \
    echo "jare:x:${uid}:" >> /etc/group                                     && \
    echo "jare ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/jare               && \
    chmod 0440 /etc/sudoers.d/jare                                          && \
    chown ${uid}:${gid} -R /home/jare

USER jare

ENV HOME /home/jare

ENV GOPATH /home/jare/workspace
ENV GOROOT /usr/lib/go
ENV GOBIN $GOROOT/bin

ENV NODEBIN /usr/lib/node_modules/bin

ENV PATH $PATH:$GOBIN:$GOPATH/bin:$NODEBIN

#bash

RUN apk --update add bash                                                        && \
    echo "export GOPATH=/home/jare/workspace" >> /home/jare/.profile             && \
    echo "export GOROOT=/usr/lib/go" >> /home/jare/.profile                      && \
    echo "export GOBIN=$GOROOT/bin" >> /home/jare/.profile                       && \
    echo "export NODEBIN=/usr/lib/node_modules/bin" >> /home/jare/.profile       && \
    echo "export PATH=$PATH:$GOBIN:$GOPATH/bin:$NODEBIN" >> /home/jare/.profile  && \
    echo "source /home/jare/.profile" >> /home/jare/.bashrc                      && \
    . /home/jare/.bashrc                                                         && \

    find / -name ".git" -prune -exec rm -rf "{}" \;                              && \
    rm -rf /var/cache/apk/* /tmp/*

#Golang

RUN apk --update add mercurial go godep                           \ 
      --update-cache --repository                                 \		
      http://dl-3.alpinelinux.org/alpine/edge/community           \		
      --allow-untrusted                                        && \
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
    mv $GOPATH/bin/* $GOBIN/                                   && \
    apk del mercurial                                          && \

    find / -name ".git" -prune -exec rm -rf "{}" \;            && \
    rm -rf /var/cache/apk/* /home/jare/workspace/* /tmp/*
    
#Fonts

ADD http://www.fontsquirrel.com/fonts/download/source-code-pro /tmp/scp.zip

RUN mkdir -p /usr/share/fonts/local              && \
    unzip /tmp/scp.zip -d /usr/share/fonts/local && \
    fc-cache -f                                  && \
    rm -rf /tmp/*                                                                                    

#Spacemacs

COPY .spacemacs /home/jare/

RUN apk --update add emacs-xorg --update-cache --repository             \
      http://dl-3.alpinelinux.org/alpine/edge/testing                && \
    git clone https://github.com/syl20bnr/spacemacs.git                 \
      /home/jare/.emacs.d                                            && \
    rm -rf /home/jare/.emacs.d/private/snippets                      && \
    git clone https://github.com/AndreaCrotti/yasnippet-snippets.git    \
      /home/jare/.emacs.d/private/snippets                           && \
    emacs -nw -batch -u "root" -kill                                 && \

    find / -name ".git" -prune -exec rm -rf "{}" \;                  && \
    rm -rf /var/cache/apk/* /tmp/*

#Docker

RUN apk add --update docker --update-cache --repository                             \
      http://dl-3.alpinelinux.org/alpine/edge/community  && rm -rf /var/cache/apk/*

#fish

RUN apk add --update fish --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community && \
    sed -i 's/\/bin\/ash/\/usr\/bin\/fish/g' /etc/passwd                                                && \

    echo "/usr/bin/fish" >> /etc/shells                                                                 && \
    mkdir -p /home/jare/.config/fish                                                                    && \
    echo "set -x HOME /home/jare" >> /home/jare/.config/fish/config.fish                                && \
    echo "set -x GOPATH /home/jare/workspace" >> /home/jare/.config/fish/config.fish                    && \
    echo "set -x GOROOT /usr/lib/go" >> /home/jare/.config/fish/config.fish                             && \
    echo "set -x GOBIN $GOROOT/bin" >> /home/jare/.config/fish/config.fish                              && \
    echo "set -x NODEBIN /usr/lib/node_modules/bin" >> /home/jare/.config/fish/config.fish              && \
    echo "set -g fish_key_bindings fish_vi_key_bindings" >> /home/jare/.config/fish/config.fish         && \
    echo "set --universal fish_user_paths $fish_user_paths $GOBIN $GOPATH/bin $NODEBIN"                    \
      >> /home/jare/.config/fish/config.fish                                                            && \
    fish -c source /home/jare/.config/fish/config.fish                                                  && \
    curl -L https://github.com/oh-my-fish/oh-my-fish/raw/master/bin/install > /tmp/ohmf-install         && \
    fish /tmp/ohmf-install                                                                              && \

    find / -name ".git" -prune -exec rm -rf "{}" \;                                                     && \
    rm -rf /var/cache/apk/* /tmp/*

EXPOSE 80 8080

COPY start.bash /usr/local/bin/start.bash

ENTRYPOINT ["bash", "/usr/local/bin/start.bash"]
