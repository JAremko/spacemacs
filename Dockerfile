FROM alpine:edge

MAINTAINER JAremko <w3techplaygound@gmail.com>

#add repos

RUN echo "http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories          && \
    echo "http://nl.alpinelinux.org/alpine/latest-stable/main" >> /etc/apk/repositories && \
    echo "http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories       && \
    echo "http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories   

RUN apk upgrade --update-cache --available                  && \
    apk --update add tar sudo bash fontconfig curl git htop    \
      unzip openssl mosh-client ca-certificates             && \
    update-ca-certificates --verbose                        && \
    rm -rf /var/cache/apk/*

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

RUN mkdir -p /home/${UNAME}/.ssh   && \
    chmod 664 /home/${UNAME}/.ssh 
    
ENV HOME /home/${UNAME}

LABEL HOME="${HOME}"

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

RUN sudo apk --update add mercurial go godep                       && \
    sudo chown ${uid}:${gid} -R /usr/lib/go                        && \
    
    go get -u                                                         \
    
      golang.org/x/tools/cmd/benchcmp                                 \
      golang.org/x/tools/cmd/bundle                                   \
      golang.org/x/tools/cmd/callgraph                                \
      golang.org/x/tools/cmd/cover                                    \
      golang.org/x/tools/cmd/digraph                                  \
      golang.org/x/tools/cmd/eg                                       \
      golang.org/x/tools/cmd/fiximports                               \
      golang.org/x/tools/cmd/godex                                    \
      golang.org/x/tools/cmd/godoc                                    \
      golang.org/x/tools/cmd/goimports                                \
      golang.org/x/tools/cmd/gomvpkg                                  \
      golang.org/x/tools/cmd/gorename                                 \
      golang.org/x/tools/cmd/gotype                                   \
      golang.org/x/tools/cmd/html2article                             \
      golang.org/x/tools/cmd/oracle                                   \
      golang.org/x/tools/cmd/present                                  \
      golang.org/x/tools/cmd/ssadump                                  \
      golang.org/x/tools/cmd/stress                                   \
      golang.org/x/tools/cmd/stringer                                 \
      golang.org/x/tools/cmd/tip                                      \
      golang.org/x/tools/cmd/vet                                      \
      
      golang.org/x/tools/refactor/eg                                  \
      golang.org/x/tools/refactor/importgraph                         \
      golang.org/x/tools/refactor/rename                              \
      golang.org/x/tools/refactor/satisfy                             \
      
      github.com/go-godo/godo                                         \
      github.com/nsf/gocode                                           \
      github.com/kisielk/errcheck                                     \
      github.com/golang/lint/golint                                   \
      github.com/jstemmer/gotags                                      \
      
      github.com/golang/mock/gomock                                   \
      github.com/golang/mock/mockgen                                  \
      github.com/dustin/go-humanize                                   \
      github.com/gosuri/uiprogress                                    \
      github.com/onsi/ginkgo/ginkgo                                   \
      github.com/onsi/gomega                                          \
      github.com/sclevine/agouti                                   && \
      
    go get -u github.com/fsouza/go-dockerclient                    && \
    sudo apk del mercurial                                         && \

    sudo find / -name ".git" -prune -exec rm -rf "{}" \;           && \
    sudo rm -rf /var/cache/apk/* /home/${UNAME}/workspace/* /tmp/*
    
#Fonts

ADD https://github.com/adobe-fonts/source-code-pro/archive/2.010R-ro/1.030R-it.zip /tmp/scp.zip
ADD http://www.ffonts.net/NanumGothic.font.zip /tmp/ng.zip

RUN sudo mkdir -p /usr/share/fonts/local               && \
    sudo unzip /tmp/scp.zip -d /usr/share/fonts/local  && \
    sudo unzip /tmp/ng.zip -d /usr/share/fonts/local   && \
    sudo chown ${uid}:${gid} -R /usr/share/fonts/local && \
    sudo chmod 744 -R /usr/share/fonts/local           && \
    sudo fc-cache -f                                   && \
    sudo rm -rf /tmp/*                                                                                    

#firefox

RUN sudo apk --update add firefox && \
    sudo rm -rf /var/cache/apk/*

#Docker

RUN sudo apk --update add docker && \
    sudo rm -rf /var/cache/apk/*

#fish

RUN sudo apk --update add fish                                                                      && \
    sudo sed -i 's/\/bin\/ash/\/usr\/bin\/fish/g' /etc/passwd                                       && \

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
#   curl -L https://github.com/oh-my-fish/oh-my-fish/raw/master/bin/install > /tmp/ohmf-install     && \
#   fish /tmp/ohmf-install                                                                          && \

    sudo find / -name ".git" -prune -exec rm -rf "{}" \;                                            && \
    sudo rm -rf /var/cache/apk/* /tmp/*
    
#Spacemacs

COPY .spacemacs /home/${UNAME}/.spacemacs
COPY private /tmp/private

RUN sudo apk --update add mesa-gl libxext-dev libxrender-dev mesa-dri-swrast       \
      libxtst-dev emacs-xorg gdk-pixbuf                                         && \
 
    git clone https://github.com/syl20bnr/spacemacs.git /home/${UNAME}/.emacs.d && \
    
    mv -f /tmp/private  /home/${UNAME}/.emacs.d/private                         && \
                
    git clone https://github.com/AndreaCrotti/yasnippet-snippets.git               \
    /tmp/snippets                                                               && \
    mv -f /tmp/snippets /home/${UNAME}/.emacs.d/private/snippets                && \
      
    sudo find /home/${UNAME}/                                                      \
      \( -type d -exec chmod u+rwx,g+rwx,o+rx {} \;                                \
      -o -type f -exec chmod u+rw,g+rw,o+r {} \; \)                             && \
     
    sudo chown -R ${uid}:${gid} /home/${UNAME}                                  && \
    
    export SHELL=/usr/bin/fish                                                  && \
    emacs -nw -batch -u "jare" -kill                                            && \

    sudo find / -name ".git" -prune -exec rm -rf "{}" \;                        && \
    sudo rm -rf /var/cache/apk/* /tmp/*

EXPOSE 80 8080

COPY start.bash /usr/local/bin/start.bash

ENTRYPOINT ["bash", "/usr/local/bin/start.bash"]
