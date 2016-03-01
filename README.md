#### Dockerized Spacemacs(GUI)  

[![screenshot](http://i.imgur.com/PjGF8iY.png)](http://i.imgur.com/PjGF8iY.png)
*Press `" "`-`"T"`-`"n"` to cycle to the [next theme](https://github.com/JAremko/spacemacs/blob/master/.spacemacs#L113)*  
*[More themes](http://themegallery.robdor.com/)*

##### [Also You might want to look at my Vim+Tmux based thingy `jare/drop-in`](https://hub.docker.com/r/jare/drop-in)  
[![jare/drop-in:latest](https://badge.imagelayers.io/jare/drop-in:latest.svg)](https://imagelayers.io/?images=jare/drop-in:latest 'jare/drop-in:latest')  *- uncompressed size*
[![](http://i.imgur.com/RVTlBBO.png)](http://i.imgur.com/RVTlBBO.png)
*Pros: much lighter, modular and well tested, works via Mosh - better for the remote access*

---------------------------------------------------------------------------------
#### What's inside?

##### jare/spacemacs:base  
  - [Emacs 24](https://www.gnu.org/software/emacs/)
  - [Spacemacs](https://github.com/syl20bnr/spacemacs) (all layers)  
  - [Spacemacs](https://github.com/syl20bnr/spacemacs) (all layers)  
  - *bash, curl, git, openssl, mosh, rsync, make, htop and fish.*     

##### jare/spacemacs:latest  
  - Same as jare/spacemacs:base +
  - [Golang](https://golang.org/) + a ton of tools 
  - [Iceweasel(Firefox)](https://www.mozilla.org/en-US/firefox/new/)   
  - [Compass](http://compass-style.org/)  
  - [PhantomJS](http://phantomjs.org/)  
  - [Node.js](https://nodejs.org/) + some tools  
  - [TypeScript](http://www.typescriptlang.org/) + some tools 
  - [Slim](http://slim-lang.com/) 

You can set container's user by changing those lines in the jare/spacemacs:base Dockerfile:
```
  ENV uid 1000
  ENV gid 1000
  ENV UNAME jare
```
Then you can use it as a base.  

#### Usage: 

 - **Create /usr/local/bin/spacemacs.bash**

```bash
#!/bin/bash

#Keep the container up-to-date
docker pull jare/spacemacs:latest
  
cd /home/jare/Documents/workspace

SPACE_HOME="$(docker inspect --format '{{.Config.Labels.HOME}}' \
jare/spacemacs:latest)"

echo '3...2...1...'

docker run -ti --rm -v $('pwd'):"${SPACE_HOME}/workspace" \
 -v /etc/localtime:/etc/localtime:ro                      \
 -v /home/jare/.ssh/id_rsa:${SPACE_HOME}/.ssh/id_rsa:ro   \
 -v /var/run/dbus:/var/run/dbus                           \
 -v /tmp/.X11-unix:/tmp/.X11-unix                         \
 -v /etc/machine-id:/etc/machine-id:ro                    \
 -e DISPLAY=$DISPLAY                                      \
 -e "GEMAIL=w3techplayground@gmail.com"                   \
 -e "GNAME=JAremko"                                       \
 -p 80:80 -p 8080:8080 -p 443:443 -p 3000:3000            \
 --name spacemacs jare/spacemacs:latest
```

 - **Add this line to .bashrc** `alias spacemacs='bash /usr/local/bin/spacemacs.bash'`
 
*If you see Emacs warnings, you can add `--privileged` but it's not necessary.*
