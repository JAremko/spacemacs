#### Dockerized Spacemacs(GUI)  

[![screenshot](http://i.imgur.com/PjGF8iY.png)](http://i.imgur.com/PjGF8iY.png)

#### What's inside?

  - [Spacemacs](https://github.com/syl20bnr/spacemacs)
  - [Golang](https://golang.org/)
  - [Docker](https://www.docker.com/)
  - [Firefox](https://www.mozilla.org/en-US/firefox/new/)
  - [Fish](http://fishshell.com/)

You can set container's user by changing those lines in the Dockerfile:
```
  ENV uid 1000
  ENV gid 1000
  ENV UNAME jare
```
#### Usage: 

 - **Create /usr/local/bin/spacemacs.bash**
```bash
  #!/bin/bash

  #Keep Spacemacs container up-to-date
  docker pull jare/spacemacs:latest

  SPACE_HOME="$(docker inspect --format '{{.Config.Labels.HOME}}' \
    jare/spacemacs:latest)"

  echo '3...2...1...'

  docker run -ti --rm -v $('pwd'):"${SPACE_HOME}/workspace" \
    -v /etc/localtime:/etc/localtime:ro                     \
    -v /home/jare/.ssh/id_rsa:/home/jare/.ssh/id_rsa:ro     \
    -v /var/run/docker.sock:/var/run/docker.sock            \
    -v /tmp/.X11-unix:/tmp/.X11-unix                        \
    -v /etc/machine-id:/etc/machine-id:ro                   \
    -e DISPLAY=$DISPLAY                                     \
    -e "GEMAIL=w3techplayground@gmail.com"                  \
    -e "GNAME=JAremko"                                      \
    -p 80:80 -p 8080:8080                                   \
    --name spacemacs jare/spacemacs:latest
```

 - **Add this line to .bashrc** `alias spacemacs='bash /usr/local/bin/spacemacs.bash'`
