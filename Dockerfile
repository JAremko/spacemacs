FROM jare/alpine:latest

MAINTAINER JAremko <w3techplaygound@gmail.com>

RUN apk add --update tar sudo bash fontconfig curl git htop unzip mosh-client && rm -rf /var/cache/apk/*

# Setup user

ENV uid 1000
ENV gid 1000
ENV UNAME jare

RUN mkdir -p /home/${UNAME}/workspace                                                   && \
    echo "${UNAME}:x:${uid}:${gid}:${UNAME},,,:/home/${UNAME}:/bin/bash" >> /etc/passwd && \
    echo "${UNAME}:x:${uid}:" >> /etc/group                                             && \
    echo "${UNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${UNAME}                   && \
    echo "docker:x:999:${UNAME}" >> /etc/group                                          && \
    chmod 0440 /etc/sudoers.d/${UNAME}                                                  && \
    chown ${uid}:${gid} -R /home/${UNAME}

USER ${UNAME}

ENV HOME /home/${UNAME}

ENV GOPATH /home/${UNAME}/workspace
ENV GOROOT /usr/lib/go
ENV GOBIN $GOROOT/bin

ENV NODEBIN /usr/lib/node_modules/bin

ENV PATH $PATH:$GOBIN:$GOPATH/bin:$NODEBIN

#bash

RUN echo "export GOPATH=/home/${UNAME}/workspace" >> /home/${UNAME}/.profile         && \
    echo "export GOROOT=/usr/lib/go" >> /home/${UNAME}/.profile                      && \
    echo "export GOBIN=$GOROOT/bin" >> /home/${UNAME}/.profile                       && \
    echo "export NODEBIN=/usr/lib/node_modules/bin" >> /home/${UNAME}/.profile       && \
    echo "export PATH=$PATH:$GOBIN:$GOPATH/bin:$NODEBIN" >> /home/${UNAME}/.profile  && \
    echo "source /home/${UNAME}/.profile" >> /home/${UNAME}/.bashrc                  && \
    . /home/${UNAME}/.bashrc                                                         && \

    sudo find / -name ".git" -prune -exec rm -rf "{}" \;                             && \
    sudo rm -rf /var/cache/apk/* /tmp/*

#Golang

RUN sudo apk --update add mercurial go godep                          \ 
      --update-cache --repository                                     \		
      http://dl-3.alpinelinux.org/alpine/edge/community            && \
    sudo chown ${uid}:${gid} -R /usr/lib/go                        && \
    go get -u golang.org/x/tools/cmd/benchcmp                      && \
    go get -u golang.org/x/tools/cmd/callgraph                     && \
    go get -u golang.org/x/tools/cmd/digraph                       && \
    go get -u golang.org/x/tools/cmd/eg                            && \
    go get -u golang.org/x/tools/cmd/fiximports                    && \
    go get -u golang.org/x/tools/cmd/godex                         && \
    go get -u golang.org/x/tools/cmd/godoc                         && \
    go get -u github.com/nsf/gocode                                && \
    go get -u golang.org/x/tools/cmd/gomvpkg                       && \
    go get -u golang.org/x/tools/cmd/gorename                      && \
    go get -u golang.org/x/tools/cmd/html2article                  && \
    go get -u github.com/kisielk/errcheck                          && \
    go get -u golang.org/x/tools/cmd/oracle                        && \
    go get -u golang.org/x/tools/cmd/ssadump                       && \
    go get -u golang.org/x/tools/cmd/stringer                      && \
    go get -u golang.org/x/tools/cmd/vet                           && \
    go get -u golang.org/x/tools/cmd/vet/whitelist                 && \
    go get -u code.google.com/p/rog-go/exp/cmd/godef               && \
    go get -u github.com/golang/lint/golint                        && \
    go get -u github.com/jstemmer/gotags                           && \
    go get -u gopkg.in/godo.v2/cmd/godo                            && \
    go get -u github.com/fsouza/go-dockerclient                    && \
    sudo apk del mercurial                                         && \

    sudo find / -name ".git" -prune -exec rm -rf "{}" \;           && \
    sudo rm -rf /var/cache/apk/* /home/${UNAME}/workspace/* /tmp/*
    
#Fonts

ADD http://www.fontsquirrel.com/fonts/download/source-code-pro /tmp/scp.zip

RUN sudo mkdir -p /usr/share/fonts/local              && \
    sudo unzip /tmp/scp.zip -d /usr/share/fonts/local && \
    sudo fc-cache -f                                  && \
    sudo rm -rf /tmp/*                                                                                    

#firefox

RUN sudo apk add --update firefox --update-cache --repository    \
      http://dl-3.alpinelinux.org/alpine/edge/testing         && \ 
    sudo rm -rf /var/cache/apk/*

#Docker

RUN sudo apk add --update docker --update-cache --repository    \
      http://dl-3.alpinelinux.org/alpine/edge/community      && \
    sudo rm -rf /var/cache/apk/*

#fish

RUN sudo apk add --update fish --update-cache                                                          \
      --repository http://dl-3.alpinelinux.org/alpine/edge/community                                && \
    sudo sed -i 's/\/bin\/ash/\/usr\/bin\/fish/g' /etc/passwd                                       && \

    echo "/usr/bin/fish" >> /etc/shells                                                             && \
    mkdir -p /home/${UNAME}/.config/fish                                                            && \
    echo "set -x HOME /home/${UNAME}" >> /home/${UNAME}/.config/fish/config.fish                    && \
    echo "set -x GOPATH /home/${UNAME}/workspace" >> /home/${UNAME}/.config/fish/config.fish        && \
    echo "set -x GOROOT /usr/lib/go" >> /home/${UNAME}/.config/fish/config.fish                     && \
    echo "set -x GOBIN $GOROOT/bin" >> /home/${UNAME}/.config/fish/config.fish                      && \
    echo "set -x NODEBIN /usr/lib/node_modules/bin" >> /home/${UNAME}/.config/fish/config.fish      && \
    echo "set -g fish_key_bindings fish_vi_key_bindings" >> /home/${UNAME}/.config/fish/config.fish && \
    echo "set --universal fish_user_paths $fish_user_paths $GOBIN $GOPATH/bin $NODEBIN"                \
      >> /home/${UNAME}/.config/fish/config.fish                                                    && \
    fish -c source /home/${UNAME}/.config/fish/config.fish                                          && \
    curl -L https://github.com/oh-my-fish/oh-my-fish/raw/master/bin/install > /tmp/ohmf-install     && \
    fish /tmp/ohmf-install                                                                          && \

    sudo find / -name ".git" -prune -exec rm -rf "{}" \;                                            && \
    sudo rm -rf /var/cache/apk/* /tmp/*
    
#Spacemacs

COPY .spacemacs /home/${UNAME}/
 
RUN sudo apk --update add mesa-gl libxext-dev libxrender-dev mesa-dri-swrast \
      libxtst-dev emacs-xorg gdk-pixbuf --update-cache --repository          \
      http://dl-3.alpinelinux.org/alpine/edge/testing                     && \
    git clone https://github.com/syl20bnr/spacemacs.git                      \
      /home/${UNAME}/.emacs.d                                             && \
    rm -rf /home/${UNAME}/.emacs.d/private/snippets                       && \
    git clone https://github.com/AndreaCrotti/yasnippet-snippets.git         \
      /home/${UNAME}/.emacs.d/private/snippets                            && \
      
    sudo find /home/${UNAME}/                                                \
      \( -type d -exec chmod u+rwx,g+rwx,o+rx {} \;                          \
      -o -type f -exec chmod u+rw,g+rw,o+r {} \; \)                       && \
     
    export SHELL=/usr/bin/fish                                            && \ 
    emacs -nw -batch -u "jare" -kill                                      && \

    sudo find / -name ".git" -prune -exec rm -rf "{}" \;                  && \
    sudo rm -rf /var/cache/apk/* /tmp/*


EXPOSE 80 8080

COPY start.bash /usr/local/bin/start.bash

ENTRYPOINT ["bash", "/usr/local/bin/start.bash"]
