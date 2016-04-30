FROM jare/spacemacs:base

MAINTAINER JAremko <w3techplaygound@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

COPY init_iceweasel.bash /usr/local/bin/init_iceweasel.bash

# Iceweasel
RUN sudo sh /usr/local/bin/aptupd.sh                                  && \
    sudo apt-get install -y iceweasel libgl1-mesa-dri libgl1-mesa-glx && \
    bash /usr/local/bin/init_iceweasel.bash                           && \
    sudo sh /usr/local/bin/cleanup.sh
   
# Node.js

USER root

RUN sh /usr/local/bin/aptupd.sh                            && \
    curl -sL https://deb.nodesource.com/setup_5.x | bash - && \
    apt-get install -y nodejs                              && \
    sh /usr/local/bin/cleanup.sh                        

USER ${UNAME}

# TypeScript && js stuff

RUN sudo npm install -g bower typescript typings foundation-cli     \
      yo generator-polymer polymer-ts-gen karma jasmine tslint tern \
      protractor webpack webpack-dev-server typescript-formatter    \
        js-beautify jshint                                        && \
     
    sudo sh /usr/local/bin/cleanup.sh
    
# ruby && Compass && scss

RUN sudo sh /usr/local/bin/aptupd.sh     && \
    sudo apt-get install -y ruby-compass && \
    sudo gem install rubygems-update     && \
    sudo update_rubygems                 && \
    sudo gem update --system             && \
    sudo sh /usr/local/bin/cleanup.sh

# scss stuff

RUN sudo gem install specific_install                                 && \
    sudo gem specific_install                                            \
      https://github.com/brigade/scss-lint.git                        && \
    sudo gem specific_install                                            \
      https://github.com/Sweetchuck/scss_lint_reporter_checkstyle.git && \
    sudo sh /usr/local/bin/cleanup.sh
    
# Slim

RUN sudo gem install slim slim_lint && \
    sudo sh /usr/local/bin/cleanup.sh

# PhantomJS

RUN sudo sh /usr/local/bin/aptupd.sh                                                  && \
    sudo apt-get install -y wget bzip2                                                && \

    PHANTOM_JS=phantomjs-2.1.1-linux-x86_64                                           && \
    cd /tmp/                                                                          && \
    wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2          && \
    sudo mv $PHANTOM_JS.tar.bz2 /usr/local/share/                                     && \
    cd /usr/local/share/                                                              && \
    sudo tar xvjf $PHANTOM_JS.tar.bz2                                                 && \
    sudo ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/share/phantomjs && \
    sudo ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin/phantomjs   && \
    sudo ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/bin/phantomjs         && \
    sudo rm -fr $PHANTOM_JS.tar.bz2                                                   && \

    sudo apt-get -y purge wget bzip2                                                  && \
    sudo sh /usr/local/bin/cleanup.sh
    
# Golang

RUN sudo sh /usr/local/bin/aptupd.sh                                   && \
    sudo apt-get install -y mercurial golang-go                        && \

    sudo chown ${uid}:${gid} -R $GOROOT                                && \
    sudo chown ${uid}:${gid} -R /usr/share/go                          && \
    sudo chown ${uid}:${gid} -R $GOPATH                                && \
    
    go get -u -buildmode=exe -ldflags '-s -w'                             \
    
      golang.org/x/tools/cmd/benchcmp                                     \
      golang.org/x/tools/cmd/bundle                                       \
      golang.org/x/tools/cmd/callgraph                                    \
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
      golang.org/x/tools/refactor/eg                                      \
      golang.org/x/tools/refactor/importgraph                             \
      golang.org/x/tools/refactor/rename                                  \
      golang.org/x/tools/refactor/satisfy                                 \
      
      gopkg.in/check.v1                                                   \

      github.com/rogpeppe/godef                                           \
      github.com/tools/godep                                              \
      github.com/nsf/gocode                                               \
      github.com/kisielk/errcheck                                         \
      github.com/golang/lint/golint                                       \
      github.com/jstemmer/gotags                                          \
      github.com/dougm/goflymake                                          \
      github.com/golang/mock/mockgen                                      \
      github.com/alecthomas/gometalinter                               && \

    gometalinter --install --update                                    && \
    
    rm -rf $GOPATH/*                                                   && \
    
#    export GOPATH=/usr/share/go                                        && \
#    
#    go get -u                                                             \
#      github.com/golang/mock/gomock                                       \
#      github.com/onsi/ginkgo/ginkgo                                       \
#      github.com/onsi/gomega                                              \
#     github.com/sclevine/agouti                                           \
#
#      github.com/GeertJohan/go.rice                                       \
#      github.com/GeertJohan/go.rice/rice                                  \
#      
#      gopkg.in/godo.v2/cmd/godo                                           \
#      github.com/fatih/color                                           && \
      
    sudo chown ${uid}:${gid} -R $GOROOT                                && \
    sudo chown ${uid}:${gid} -R $GOPATH                                && \

    sudo sh /usr/local/bin/cleanup.sh

# Install executable dependent packages
RUN emacs -nw -batch -u "${UNAME}" -q -kill && \
    # Sometimes it does something.
    emacs -nw -batch -u "${UNAME}" -q -kill
    
EXPOSE 80 8080 443 3000
