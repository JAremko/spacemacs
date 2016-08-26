FROM debian:testing

MAINTAINER JAremko <w3techplaygound@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Basic stuff

COPY cleanup.sh /usr/local/bin/cleanup.sh
COPY aptupd.sh /usr/local/bin/aptupd.sh

RUN echo  'Acquire::Retries       "3";'  >> /etc/apt/apt.conf.d/70debconf && \
    echo  'Acquire::http::Timeout "20";' >> /etc/apt/apt.conf.d/70debconf && \
    echo  'Acquire::ftp::Timeout  "20";' >> /etc/apt/apt.conf.d/70debconf

RUN sh /usr/local/bin/aptupd.sh                          && \
    apt-get install -y tar sudo bash fontconfig curl git    \
      htop unzip openssl mosh rsync make                 && \
    sh /usr/local/bin/cleanup.sh 

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

# Bash

RUN echo "export HOME=$HOME" >> $HOME/.bashrc                             && \
    echo "export GOPATH=$GOPATH" >> $HOME/.bashrc                         && \
    echo "export GOROOT=$GOROOT" >> $HOME/.bashrc                         && \
    echo "export GOBIN=$GOBIN" >> $HOME/.bashrc                           && \
    echo "export NODEBIN=$NODEBIN" >> $HOME/.bashrc                       && \
    echo "export PATH=$PATH:$GOBIN:$GOPATH/bin:$NODEBIN" >> $HOME/.bashrc && \
    . $HOME/.bashrc                                                     

# Fonts

ADD https://github.com/adobe-fonts/source-code-pro/archive/2.010R-ro/1.030R-it.zip /tmp/scp.zip
ADD http://www.ffonts.net/NanumGothic.font.zip /tmp/ng.zip

RUN sudo mkdir -p /usr/local/share/fonts               && \
    sudo unzip /tmp/scp.zip -d /usr/local/share/fonts  && \
    sudo unzip /tmp/ng.zip -d /usr/local/share/fonts   && \
    sudo chown ${uid}:${gid} -R /usr/local/share/fonts && \
    sudo chmod 777 -R /usr/local/share/fonts           && \
    sudo fc-cache -fv                                  && \
    sudo sh /usr/local/bin/cleanup.sh 

# Fish

RUN sudo sh /usr/local/bin/aptupd.sh                                                       && \
    sudo apt-get -y install fish                                                           && \

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
    
    sudo sh /usr/local/bin/cleanup.sh

# Emacs

RUN sudo sh /usr/local/bin/aptupd.sh                               && \
    sudo apt-get install -y emacs ispell iamerican-insane dbus-x11    \
      libegl1-mesa                                                 && \

    sudo sh /usr/local/bin/cleanup.sh

# Spacemacs

COPY .spacemacs $HOME/.spacemacs
                   
RUN git clone https://github.com/AndreaCrotti/yasnippet-snippets.git               \
      /tmp/snippets                                                             && \

    git clone https://github.com/syl20bnr/spacemacs.git -b develop                 \
      ${HOME}/.emacs.d                                                          && \
   
    sudo mv -f /tmp/snippets $HOME/.emacs.d/private/snippets                    && \
      
    sudo find $HOME/                                                               \
      \( -type d -exec chmod u+rwx,g+rwx,o+rx {} \;                                \
      -o -type f -exec chmod u+rw,g+rw,o+r {} \; \)                             && \
     
    sudo chown -R ${uid}:${gid} $HOME                                           && \
    export SHELL=/usr/bin/fish                                                  && \

    emacs -nw -batch -u "${UNAME}" -q -kill                                     && \
    # Sometimes it does something.
    emacs -nw -batch -u "${UNAME}" -q -kill                                     && \
    sed -i "s/download-packages 'all/download-packages 'used-but-keep-unused/g"    \
      ${HOME}/.spacemacs                                                        && \
    emacs -nw -batch -u "${UNAME}" -q -kill                                     && \

    sudo sh /usr/local/bin/cleanup.sh

COPY start.bash /usr/local/bin/start.bash

ENTRYPOINT ["bash", "/usr/local/bin/start.bash"]
