
![ScreenShot](https://raw.githubusercontent.com/lordbasex/docker_fop2/master/fop2.png)

Lord BaseX (c) 2014-2018
 Federico Pereira <fpereira@cnsoluciones.com>

This code is distributed under the GNU LGPL v3.0 license.

# Doc 
https://www.fop2.com/docs/installation.php

# Docker FOP2
This container was created to speed up the implementation of PBX and provide a quick solution to the implementation of FOP2.
Which allows us to move quickly without worrying about S.O and its dependencies.

# Features
- Runs as a Docker Container
- CentOS 7
- Apache 2.4 (w/ SSL)
- MariaDB 10.1
- PHP 5.6
- Git
- Fop2

# Docker build manual env

## ENV

| Arguments  | Description  |
| :------------ |:------------------------------------------------: 
| AMI_HOST  | Asterisk Manager Interface (AMI) Host |
| AMI_PORT  | Asterisk Manager Interface (AMI) Port |
| AMI_USER  | Asterisk Manager Interface (AMI) User |
| AMI_USER  | Asterisk Manager Interface (AMI) Secret|

# Docker build manual env

```bash
docker build -t fop2:build -f Dockerfile \
--build-arg AMI_HOST=$FOP2_HOST \
--build-arg AMI_PORT=$FOP2_PORT \
--build-arg AMI_USER=$FOP2_USER \
--build-arg AMI_SECRET=$FOP2_SECRET .
```

# Docker build automatic env (Run on an Asterisk, Issabel, FreePBX)
```bash
rm -fr /usr/src/docker_fop2
cd /usr/src
git clone https://github.com/lordbasex/docker_fop2.git
cd docker_fop2

FOP2_HOST=`hostname -I | awk '{print $1}'`
FOP2_PORT=5038
FOP2_USER=fop2
FOP2_SECRET=`head -c 200 /dev/urandom | tr -cd 'A-Za-z0-9' | head -c 20`
FOP2_PERMIT=`docker network inspect bridge | grep 'Subnet' | cut -d':' -f2 | cut -d'/' -f1 | cut -d'"' -f2`

cat >> /etc/asterisk/manager.conf <<ENDLINE 
[fop2]
secret=$FOP2_SECRET
deny=0.0.0.0/0.0.0.0
permit=$FOP2_PERMIT/255.255.0.0
read = all
write = all
writetimeout = 1000
eventfilter=!Event: RTCP*
eventfilter=!Event: VarSet
eventfilter=!Event: Cdr
eventfilter=!Event: DTMF
eventfilter=!Event: AGIExec
eventfilter=!Event: ExtensionStatus
eventfilter=!Event: ChannelUpdate
eventfilter=!Event: ChallengeSent
eventfilter=!Event: SuccessfulAuth
eventfilter=!Event: DeviceStateChange
eventfilter=!Event: RequestBadFormat
eventfilter=!Event: MusicOnHoldStart
eventfilter=!Event: MusicOnHoldStop
eventfilter=!Event: NewAccountCode
eventfilter=!Event: DeviceStateChange
ENDLINE

asterisk -rx "manager reload"

docker build -t fop2:build -f Dockerfile \
--build-arg AMI_HOST=$FOP2_HOST \
--build-arg AMI_PORT=$FOP2_PORT \
--build-arg AMI_USER=$FOP2_USER \
--build-arg AMI_SECRET=$FOP2_SECRET .

```

# Example Usage with Data Inside Docker

 Download and run this container with: 
```bash
docker run --name fop2 -itd -p 0.0.0.0:4443:443 -p 0.0.0.0:4445:4445 -v /etc/asterisk:/etc/asterisk fop2:build
```

To access the Web Front-end [https://localhost:4443](https://localhost:4443) and back-end 
[https://localhost:4443/admin](https://localhost:4443/admin) 
* User: superadmin 
* Pass: admin

# Access to linux console:
```bash
bash -c "clear && docker exec -it fop2 bash"
```

# Command to register fop2:
```bash
bash -c "clear && docker exec -it fop2 /usr/local/fop2/fop2_server --register"
```

# Command to revoke fop2:
```bash
bash -c "clear && docker exec -it fop2 /usr/local/fop2/fop2_server --revoke"
```

# Command to log httpd:
```bash
bash -c "clear && docker exec -it fop2 tail -f /var/log/httpd/ssl_error_log"
```

# Command to log httpd clean:
```bash
bash -c "clear && docker exec -it fop2 touch /var/log/httpd/ssl_error_lo && tail -f /var/log/httpd/ssl_error_log"
```

# Command to fop2 stop
```bash
bash -c "clear && docker exec -it fop2 killall fop2_server"
```
# Command to fop2 start
```bash
bash -c "clear && docker exec -it fop2 /usr/local/fop2/fop2_server -d"
```

# Command for fop2 to put debug mode: 
Doc (http://members.asternic.biz/knowledge_base/how-to-debug-fop2)
```bash
bash -c "clear && docker exec -it fop2 /usr/local/fop2/fop2_server -X 511"
```
