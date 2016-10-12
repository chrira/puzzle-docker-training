## Installation of Docker
* MAC
* Windows
* Linux

----

### MAC
* Download Docker for Mac [link](https://docs.docker.com/engine/installation/mac/)
* Installing Docker for Mac does not affect machines you created with Docker Machine. You’ll get the option to copy containers and images from your local default machine (if one exists) to the new Docker for Mac HyperKit VM.
* The install includes: Docker Engine, Docker CLI client, Docker Compose, and Docker Machine.

----

### Windows
* Download Docker for Windows [link](https://docs.docker.com/engine/installation/windows/)
* Docker for Windows requires Microsoft Hyper-V to run. After Hyper-V is enabled, VirtualBox will no longer work, but any VirtualBox VM images will remain. 
* You can import a default VirtualBox VM after installing Docker for Windows by using the Settings menu in the System Tray.
* The current version of Docker for Windows runs on 64bit Windows 10 Pro, Enterprise and Education (1511 November update, Build 10586 or later). In the future we will support more versions of Windows 10.
* The Hyper-V package must be enabled for Docker for Windows to work. The Docker for Windows installer will enable it for you, if needed. (This requires a reboot).

----

### Linux
* No virtualization Layer needed [link](https://docs.docker.com/engine/installation/)
* Follow the instruction provided by Docker on their website, specific to your distribution

----

It can be installed via:
* Distribution-supplied packages on virtually all distros.
(Includes at least: Arch Linux, CentOS, Debian, Fedora, Gentoo,
openSUSE, RHEL, Ubuntu.)
* Packages supplied by Docker.
* Installation script from Docker.
* Binary download from Docker (it's a single file).

----

You can use the curl command to install on several platforms:
```
curl -s https://get.docker.com/ | sudo sh
```
This currently works on:
* Ubuntu
* Debian
* Fedora
* Gentoo

----

### Check that Docker is working

```
$docker version
Client:
 Version:      1.12.1
 API version:  1.24
 Go version:   go1.6.3
 Git commit:   23cf638
 Built:        Thu Aug 18 17:32:24 2016
 OS/Arch:      darwin/amd64
 Experimental: true

Server:
 Version:      1.12.1
 API version:  1.24
 Go version:   go1.6.3
 Git commit:   23cf638
 Built:        Thu Aug 18 17:32:24 2016
 OS/Arch:      linux/amd64
 Experimental: true
````

----

### Important PSA about security

The docker user is root equivalent.

It provides root-level access to the host.

You should restrict access to it like you would protect root.

If you give somebody the ability to access the Docker API, you are giving them full
access on the machine.

Therefore, the Docker control socket is (by default) owned by the docker group, to
avoid unauthorized access on multi-user machines.

----

### The docker group
Add the Docker group:
```
sudo groupadd docker
```
Add ourselves to the group:
```
sudo gpasswd -a $USER docker
```
Restart the Docker daemon:
```
sudo service docker restart
```
Log out:
```
exit
```

----

