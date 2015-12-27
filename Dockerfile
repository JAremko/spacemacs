FROM debian:sid

MAINTAINER JAremko <w3techplaygound@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

#add repos

RUN apt-get update -y                                      && \
    apt-get upgrade -y                                     && \

    apt-get purge -y ca-certificates                       && \
    apt-get install -y ca-certificates                     && \
    update-ca-certificates -f                              && \

    apt-get install -y tar sudo bash fontconfig curl git      \
      htop unzip openssl mosh rsync                        && \

    apt-get autoclean -y                                   && \    
    rm -rf /tmp/* /var/lib/apt/lists/*

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

RUN mkdir -p $HOME/.ssh   && \
    chmod 664 $HOME/.ssh 
    
ENV HOME /home/${UNAME}

LABEL HOME=$HOME

ENV GOPATH $HOME/workspace
ENV GOROOT /usr/lib/go
ENV GOBIN $GOROOT/bin

ENV NODEBIN /usr/lib/node_modules/bin

ENV PATH $PATH:$GOBIN:$GOPATH/bin:$NODEBIN

#bash

RUN echo "export HOME=$HOME" >> $HOME/.bashrc                             && \
    echo "export GOPATH=$GOPATH" >> $HOME/.bashrc                         && \
    echo "export GOROOT=$GOROOT" >> $HOME/.bashrc                         && \
    echo "export GOBIN=$GOBIN" >> $HOME/.bashrc                           && \
    echo "export NODEBIN=$NODEBIN" >> $HOME/.bashrc                       && \
    echo "export PATH=$PATH:$GOBIN:$GOPATH/bin:$NODEBIN" >> $HOME/.bashrc && \
    . $HOME/.bashrc                                                       && \

    sudo find / -name ".git" -prune -exec rm -rf "{}" \;                  && \
    sudo rm -rf /var/cache/apk/* /tmp/*

#Golang

ENV GOPATH /usr/share/go

RUN sudo apt-get update -y                                             && \
    sudo apt-get install -y mercurial golang-go                        && \

    sudo chown ${uid}:${gid} -R $GOROOT                                && \
    sudo chown ${uid}:${gid} -R $GOPATH                                && \
    
    go get -u                                                             \
    
      golang.org/x/tools/cmd/benchcmp                                     \
      golang.org/x/tools/cmd/bundle                                       \
      golang.org/x/tools/cmd/callgraph                                    \
      golang.org/x/tools/cmd/cover                                        \
      golang.org/x/tools/cmd/digraph                                      \
      golang.org/x/tools/cmd/eg                                           \
      golang.org/x/tools/cmd/fiximports                                   \
      golang.org/x/tools/cmd/godex                                        \
      golang.org/x/tools/cmd/godoc                                        \
      golang.org/x/tools/cmd/goimports                                    \
      golang.org/x/tools/cmd/gomvpkg                                      \
      golang.org/x/tools/cmd/gorename                                     \
      golang.org/x/tools/cmd/gotype                                       \
      golang.org/x/tools/cmd/html2article                                 \
      golang.org/x/tools/cmd/oracle                                       \
      golang.org/x/tools/cmd/present                                      \
      golang.org/x/tools/cmd/ssadump                                      \
      golang.org/x/tools/cmd/stress                                       \
      golang.org/x/tools/cmd/stringer                                     \
      golang.org/x/tools/cmd/tip                                          \
      golang.org/x/tools/cmd/vet                                          \
      github.com/rogpeppe/godef                                           \
      github.com/tools/godep                                              \  
      golang.org/x/tools/refactor/eg                                      \
      golang.org/x/tools/refactor/importgraph                             \
      golang.org/x/tools/refactor/rename                                  \
      golang.org/x/tools/refactor/satisfy                                 \
      github.com/nsf/gocode                                               \
      github.com/kisielk/errcheck                                         \
      github.com/golang/lint/golint                                       \
      github.com/jstemmer/gotags                                          \  
      github.com/golang/mock/gomock                                       \
      github.com/golang/mock/mockgen                                      \
      github.com/onsi/ginkgo/ginkgo                                       \
      github.com/onsi/gomega                                              \
      github.com/sclevine/agouti                                          \
      github.com/dustin/go-humanize                                       \
      github.com/gosuri/uiprogress                                        \
      github.com/fsouza/go-dockerclient                                   \                         
      github.com/dougm/goflymake                                          \
      github.com/mattn/goveralls                                          \
      gopkg.in/godo.v2/cmd/godo                                        && \

    sudo chown ${uid}:${gid} -R $GOROOT                                && \
    sudo chown ${uid}:${gid} -R $GOPATH                                && \

    sudo find / -name ".git" -prune -exec rm -rf "{}" \;               && \
    sudo apt-get autoclean -y                                          && \
    sudo rm -rf /tmp/* /var/lib/apt/lists/*

ENV GOPATH $HOME/workspace

#Fonts

ADD https://github.com/adobe-fonts/source-code-pro/archive/2.010R-ro/1.030R-it.zip /tmp/scp.zip
ADD http://www.ffonts.net/NanumGothic.font.zip /tmp/ng.zip

RUN sudo mkdir -p /usr/local/share/fonts               && \
    sudo unzip /tmp/scp.zip -d /usr/local/share/fonts  && \
    sudo unzip /tmp/ng.zip -d /usr/local/share/fonts   && \
    sudo chown ${uid}:${gid} -R /usr/local/share/fonts && \
    sudo chmod 777 -R /usr/local/share/fonts           && \
    sudo fc-cache -fv                                  && \
    sudo rm -rf /tmp/*                                                                                    

#Iceweasel

RUN sudo apt-get update -y              && \
    sudo apt-get install -y iceweasel   && \
    sudo rm -rf /var/cache/apk/* /tmp/*

#Phantomjs

RUN sudo apt-get update -y              && \
    sudo apt-get install -y phantomjs   && \
    sudo rm -rf /var/cache/apk/* /tmp/*

#Docker

RUN sudo curl -sSL https://test.docker.com/ | sh && \
    sudo apt-get autoclean -y                    && \
    sudo rm -rf /var/cache/apk/* /tmp/*

#fish

RUN sudo apt-get update -y                                                                 && \
    sudo apt-get install -y fish                                                           && \
    sudo sed -i 's/\/bin\/ash/\/usr\/bin\/fish/g' /etc/passwd                              && \

    mkdir -p $HOME/.config/fish                                                            && \

    echo "set -x HOME $HOME" >> $HOME/.config/fish/config.fish                             && \
    echo "set -x GOPATH $GOPATH" >> $HOME/.config/fish/config.fish                         && \
    echo "set -x GOROOT $GOROOT" >> $HOME/.config/fish/config.fish                         && \
    echo "set -x GOBIN $GOBIN" >> $HOME/.config/fish/config.fish                           && \
    echo "set -x NODEBIN $NODEBIN" >> $HOME/.config/fish/config.fish                       && \
    echo "set -g fish_key_bindings fish_vi_key_bindings" >> $HOME/.config/fish/config.fish && \
    echo "set --universal fish_user_paths $fish_user_paths $GOBIN $GOPATH/bin $NODEBIN"       \
      >> $HOME/.config/fish/config.fish                                                    && \

    fish -c source $HOME/.config/fish/config.fish                                          && \
    curl -L https://github.com/oh-my-fish/oh-my-fish/raw/master/bin/install >                 \
      /tmp/ohmf-install                                                                    && \
    fish /tmp/ohmf-install                                                                 && \
    
    sudo apt-get autoclean -y                                                              && \
    sudo find / -name ".git" -prune -exec rm -rf "{}" \;                                   && \
    sudo rm -rf /tmp/* /var/lib/apt/lists/* 
    
#Spacemacs

COPY .spacemacs $HOME/.spacemacs
COPY private /tmp/private

RUN sudo apt-get update -y                                             && \
    sudo apt-get install -y emacs ispell iamerican-insane                 \
    ibritish-insane irussian dbus-x11                                  && \
 
    git clone https://github.com/syl20bnr/spacemacs.git $HOME/.emacs.d && \
    cd $HOME/.emacs.d                                                  && \
    git submodule update --init --recursive                            && \ 
    
    sudo mv -f /tmp/private  $HOME/.emacs.d/private                    && \
                
    git clone https://github.com/AndreaCrotti/yasnippet-snippets.git      \
      /tmp/snippets                                                    && \
    sudo mv -f /tmp/snippets $HOME/.emacs.d/private/snippets           && \
      
    sudo find $HOME/                                                      \
      \( -type d -exec chmod u+rwx,g+rwx,o+rx {} \;                       \
      -o -type f -exec chmod u+rw,g+rw,o+r {} \; \)                    && \
     
    sudo chown -R ${uid}:${gid} $HOME                                  && \
    
    export SHELL=/usr/bin/fish                                         && \
    emacs -nw -batch -u "${UNAME}" -q -kill                            && \

    sudo apt-get purge -y software-properties-common                   && \ 
    sudo apt-get autoclean -y                                          && \
    sudo find / -name ".git" -prune -exec rm -rf "{}" \;               && \
    sudo rm -rf /tmp/* /var/lib/apt/lists/*

EXPOSE 80 8080

COPY start.bash /usr/local/bin/start.bash

ENTRYPOINT ["bash", "/usr/local/bin/start.bash"]
