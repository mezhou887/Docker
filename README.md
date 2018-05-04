# Docker
Proyectos en Docker
![ScrennShot](https://raw.githubusercontent.com/lordbasex/Docker/master/docker-logo.png)

* Install Docker
```bash
curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh
systemctl enable docker
```
* Install Portainer
```bash
mkdir -p /root/portainer/data
docker run -d -p 9000:9000 -v /root/portainer/data:/data -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer
```

* Run Boot
```bash
cat > /etc/systemd/system/docker_portainer.service <<ENDLINE
#systemctl start docker_portainer
#systemctl enable docker_portainer

[Unit]
Wants=docker.service
After=docker.service

[Service]
RemainAfterExit=yes
ExecStart=/usr/bin/docker start Portainer
ExecStop=/usr/bin/docker stop Portainer

[Install]
WantedBy=multi-user.target
ENDLINE
```

```bash
systemctl start docker_portainer
systemctl enable docker_portainer
