### Spacemacs now has [`spacemacs-docker` distribution](https://github.com/syl20bnr/spacemacs/tree/develop/layers/%2Bdistributions/spacemacs-docker). Consider using it instead.

#### Dockerized Spacemacs(GUI)
[![screenshot](https://raw.githubusercontent.com/syl20bnr/spacemacs/master/doc/img/spacemacs-python.png)](https://raw.githubusercontent.com/syl20bnr/spacemacs/master/doc/img/spacemacs-python.png)


#### Usage:

```bash
docker run -ti --rm -v $('pwd'):/mnt/workspace \
 -v /etc/localtime:/etc/localtime:ro \
 -v /home/jare/.ssh/id_rsa:${UHOME}/.ssh/id_rsa:ro \
 -v /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket \
 -v /tmp/.X11-unix:/tmp/.X11-unix \
 -v /etc/machine-id:/etc/machine-id:ro \
 -e DISPLAY=$DISPLAY \
 -e TZ=UA \
 --name spacemacs jare/spacemacs
```

##### [Also You might want to look at my Vim+Tmux based thingy `jare/drop-in`](https://hub.docker.com/r/jare/drop-in)
[![](http://i.imgur.com/RVTlBBO.png)](http://i.imgur.com/RVTlBBO.png)
