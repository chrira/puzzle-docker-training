## Understanding Docker images
In this lesson, I’ll explain:
* What is an image.
* What is a layer.
* The various image namespaces.
* How to search and download images

----

### What is an image?

* An image is a collection of files + some meta data.  
(Technically: those files form the root filesystem of a container.)
* Images are made of layers, conceptually stacked on top of each other.
* Each layer can add, change, and remove files.
* Images can share layers to optimize disk usage, transfer times, and memory use.

----

### Difference between container and image

* An image is a read-only filesystem.
* A container is an encapsulated set of processes running in a read-write copy of that filesystem.
* To optimize container boot time, copy-on-write is used instead of regular copy.
* docker run starts a container from a given image.

Images are like templates or stencils that you can create containers from.

----

### OOP

* Images are conceptually similar to classes.
* Layers are conceptually similar to inheritance.
* Containers are conceptually similar to instances.

----

### But…

If an image is read-only, how do we change it?
* We don't.
* We create a new container from that image.
* Then we make changes to that container.
* When we are satisfied with those changes, we transform them into a new layer.
* A new image is created by stacking the new layer on top of the old image.

----

Confusion (chicken-and-egg):
* The only way to create an image is by "freezing" a container.
* The only way to create a container is by instanciating an image.

----

### Creating the 1st images

There is a special empty image called scratch.
* It allows to build from scratch.
The `docker import` command loads a tarball into Docker.
* The imported tarball becomes a standalone image.
* That new image has a single layer.

Note: you will probably never have to do this yourself.

----

### Creating other images

`docker commit`
* Saves all the changes made to a container into a new layer.
* Creates a new image (effectively a copy of the container).
`docker build`
* Performs a repeatable build sequence.
* This is the preferred method!

----

### Image namespaces
There are three namespaces:
* Root-like
    * ubuntu
* User (and organizations)
    * jpetazzo/clock
* Self-Hosted
    * registry.example.com:5000/my-private-image

----

### Root namespaces
The root namespace is for official images. They are put there by Docker Inc., but they are generally authored and maintained by third parties.

Those images include:
* Small, "swiss-army-knife" images like busybox.
* Distro images to be used as bases for your builds, like ubuntu, fedora...
* Ready-to-use components and services, like redis, postgresql...

----

### User namespaces
The user namespace holds images for Docker Hub users and organizations.
For example:
* muellermich/nodejs-hello
The Docker Hub user is:
* muellermich
The image name is:
* nodejs-hello

----

### Self-hosted namespace

This namespace holds images which are not hosted on Docker Hub, but on third party registries.

They contain the hostname (or IP address), and optionally the port, of the registry server.
For example:
* localhost:5000/wordpress
The remote host and port is:
* localhost:5000
The image name is:
* wordpress

----

### List images on your host

```bash
docker images
REPOSITORY                                  TAG                                 IMAGE ID            CREATED             SIZE
muellermich/reveal-md                       latest                              92670cf55bca        3 days ago          689.3 MB
reveal-md                                   latest                              92670cf55bca        3 days ago          689.3 MB
muellermich/reveal-md                       <none>                              bffc6af76db3        3 days ago          711.8 MB
muellermich/reveal-md                       <none>                              f4767cdedb2b        3 days ago          689.5 MB
muellermich/reveal-md                       <none>                              9a4005187039        3 days ago          689.6 MB
muellermich/reveal-md                       <none>                              0f63ac533bf2        3 days ago          689.5 MB
muellermich/reveal-md                       <none>                              e6a7dfbfd82a        3 days ago          689.4 MB
<none>                                      <none>                              04ead644d638        3 days ago          689.5 MB
<none>                                      <none>                              50af7f43d702        3 days ago          689.5 MB
<none>                                      <none>                              622748c50d8f        3 days ago          673.8 MB
muellermich/reveal-md                       <none>                              57bec2477c00        3 days ago          689.5 MB
<none>                                      <none>                              303087ff0bab        3 days ago          689.5 MB
<none>                                      <none>                              10cecf3ef742        3 days ago          689.4 MB
```

----

### Searching for images
    
```bash
docker search nginx
NAME                                     DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
nginx                                    Official build of Nginx.                        3784      [OK]       
jwilder/nginx-proxy                      Automated Nginx reverse proxy for docker c...   757                  [OK]
richarvey/nginx-php-fpm                  Container running Nginx + PHP-FPM capable ...   245                  [OK]
jrcs/letsencrypt-nginx-proxy-companion   LetsEncrypt container to use with nginx as...   92                   [OK]
million12/nginx-php                      Nginx + PHP-FPM 5.5, 5.6, 7.0 (NG), CentOS...   76                   [OK]
maxexcloo/nginx-php                      Docker framework container with Nginx and ...   57                   [OK]
webdevops/php-nginx                      Nginx with PHP-FPM                              47                   [OK]
h3nrik/nginx-ldap                        NGINX web server with LDAP/AD, SSL and pro...   28                   [OK]
bitnami/nginx                            Bitnami nginx Docker Image                      18                   [OK]
maxexcloo/nginx                          Docker framework container with Nginx inst...   7                    [OK]
evild/alpine-nginx                       Minimalistic Docker image with Nginx            6                    [OK]
million12/nginx                          Nginx: extensible, nicely tuned for better...   6                    [OK]
webdevops/nginx                          Nginx container                                 5                    [OK]
ixbox/nginx                              Nginx on Alpine Linux.                          3                    [OK]
webdevops/hhvm-nginx                     Nginx with HHVM                                 3                    [OK]
dock0/nginx                              Arch container running nginx                    2                    [OK]
1science/nginx                           Nginx Docker images based on Alpine Linux       2                    [OK]
yfix/nginx                               Yfix own build of the nginx-extras package      2                    [OK]
xataz/nginx                              Light nginx image                               2                    [OK]
blacklabelops/nginx                      Dockerized Nginx Reverse Proxy Server.          1                    [OK]
servivum/nginx                           Nginx Docker Image with Useful Tools            1                    [OK]
radial/nginx                             Spoke container for Nginx, a high performa...   1                    [OK]
tozd/nginx                               Dockerized nginx.                               0                    [OK]
c4tech/nginx                             Several nginx images for web applications.      0                    [OK]
unblibraries/nginx                       Baseline non-PHP nginx container                0                    [OK]
```

----

### Downloading images

There are two ways to download images.
* Explicitly, with `docker pull`.
* Implicitly, when executing `docker run` and the image is not found locally.

----

### Pulling an image
```bash
docker pull alpine:latest
```
As seen previously, images are made up of layers.
* Docker has downloaded all the necessary layers.
* In this example, :latest indicates that we pulled the lastest Version of Alpine Linux.

----

### Image and Tags
Images can have tags.
* Tags define image versions or variants.
* `docker pull alpine` will refer to `alpine:latest`.
The `:latest` tag is generally updated often.

----

### When to use or not to use tags
Don't specify tags:
* When doing rapid testing and prototyping.
* When experimenting.
* When you want the latest version.
Do specify tags:
* When recording a procedure into a script.
* When going to production.
* To ensure that the same version will be used everywhere.
* To ensure repeatability later

----

### Do it yourself

* Search Dockerhub for e.g. mysql
* Pull the selected image

----

## Building images interactively
In this lesson, we will create our first container image.
It will be a basic distribution image, but we will pre-install the package figlet.
We will:
* Create a container from a base image.
* Install software manually in the container, and turn it into a new image.
* Learn about new commands: `docker commit`, `docker tag`, and `docker diff`.

----

### Building images interactively
As we have seen, the images on the Docker Hub are sometimes very basic.  
How do we want to construct our own images?  
As an example, we will build an image that has figlet.  
First, we will do it manually with docker commit.  
Then, in an upcoming chapter, we will use a Dockerfile and docker build.

----

### Create a new container and make some changes

#### Preparation/Do it yourself
Our base image will be the Ubuntu image  
Start the Ubuntu container and install figlet  
Detach from the container

----

### Create a new container and make some changes
* start Ubuntu container
```bash
docker run -ti ubuntu
```
Update apt and install figlet
```bash
apt-get update && apt-get install -y figlet
```
Detach from the Container
```bash
^P^Q
```

----

### Inspect the changes
Now let's run `docker diff` to see the difference between the base image and our container.

```bash
docker diff $(docker ps -lq)
C /.wh..wh.plnk
A /.wh..wh.plnk/98.3683338
C /etc
C /etc/alternatives
A /etc/alternatives/figlet
A /etc/alternatives/figlet.6.gz
C /tmp
C /usr
C /usr/bin
A /usr/bin/chkfont
A /usr/bin/figlet
A /usr/bin/figlet-figlet
A /usr/bin/figlist
A /usr/bin/showfigfonts
C /usr/share
```

----

### Docker tracks filesystem changes

* An image is read-only.
* When we make changes, they happen in a copy of the image.
* Docker can show the difference between the image, and its copy.
* For performance, Docker uses copy-on-write systems.  
(i.e. starting a container based on a big image doesn't incur a huge copy.)

----

### Commit and run your image

The `docker commit` command will create a new layer with those changes, and a new image using this new layer.
```bash
docker commit $(docker ps -lq)
sha256:e5909bae970902c0d52b8825ac96e45ab644728068679d0806de57bc5c5c1512
```
The output of the docker commit command is the ID for your newly created image.

We can run this image:
```bash
docker images
docker run -ti <IMAGE-ID>
```

----

### Tagging images

Referring to an image by its ID is not intuitive. Let's tag it instead.
We can use the tag command:
```bash
docker tag <newImageId> figlet
```

But we can also specify the tag as an extra argument to commit:
```bash
docker commit <containerId> figlet
```
And then run it using its tag:
```bash
docker run -it figlet
```

----

## Building images with a Dockerfile

We will build a container image automatically, with a Dockerfile.
At the end of this lesson, you will be able to:
* Write a Dockerfile.
* Build an image from a Dockerfile.

----

### Dockerfile overview

A Dockerfile is a build recipe for a Docker image.
* It contains a series of instructions telling Docker how an image is constructed.
* The docker build command builds an image from a Dockerfile.

----

### Writing our first Dockerfile

Our Dockerfile must be in a new, empty directory.
* Create a directory to hold our Dockerfile.
```bash
mkdir myimage
```
* Create a Dockerfile inside this directory.
```bash
cd myimage
vim Dockerfile
```
Of course, you can use any other editor of your choice. Or using a container with the editor of your choice :-)

----

### Type this in your Dockerfile…

```bash
FROM ubuntu
RUN apt-get update
RUN apt-get install -y figlet
```
* `FROM` indicates the base image for our build.
* Each `RUN` line will be executed by Docker during the build.
* Our RUN commands must be non-interactive.  
(No input can be provided to Docker during the build that’s why we will add the -y flag to apt-get.)

----

### Build that… image
Save our file, then execute:
```
docker build -t figlet .
```
* `-t` indicates the tag to apply to the image.
* `.` indicates the location of the build context.  
(We will talk more about the build context later; but to keep things simple: this is the directory where our Dockerfile is located.)

----

### What happens when we build the image?

The output of docker build looks like this:
```
docker build -t filget .
Sending build context to Docker daemon 84.48 kB
Step 1 : FROM ubuntu
 ---> 42118e3df429
Step 2 : RUN apt-get update
 ---> Using cache
 ---> 48fb734e0326
Step 3 : RUN apt-get install -y figlet
 ---> Using cache
 ---> ccd7cf351f38
Successfully built ccd7cf351f38
```
The output of the run commands has been omitted

----

### Sending the build context to Docker

```
Sending build context to Docker daemon 84.48 kB
```
* The build context is the . directory given to docker build.
* It is sent (as an archive) by the Docker client to the Docker daemon.
* This allows to use a remote machine to build using local files.
* Be careful (or patient) if that directory is big and your link is slow

----

### Executing each step
```
docker build -t filget .
Sending build context to Docker daemon 84.48 kB
Step 1 : FROM ubuntu
 ---> 42118e3df429
Step 2 : RUN apt-get update
 ---> Using cache
 ---> 48fb734e0326
Step 3 : RUN apt-get install -y figlet
 ---> Using cache
 ---> ccd7cf351f38
Successfully built ccd7cf351f38
```
* A container (42118e3df429) is created from the base image.
* The RUN command is executed in this container.
* The container is committed into an image (48fb734e0326).
* The build container (42118e3df429) is removed.
* The output of this step will be the base image for the next one.
* …

----

### The caching system

If you run the same build again, it will be instantaneous.  
Why?
* After each build step, Docker takes a snapshot.
* Before executing a step, Docker checks if it has already built the same sequence.
* Docker uses the exact strings defined in your Dockerfile:
    * `RUN apt-get install figlet cowsay` is different from
    * `RUN apt-get install cowsay figlet`
    * `RUN apt-get update` is not re-executed when the mirrors are updated

You can force a rebuild with docker build --no-cache ....

----

### Run it

```bash
docker run -ti figlet
```
```
root@00f0766080ed:/# figlet hello
 _          _ _       
| |__   ___| | | ___  
| '_ \ / _ \ | |/ _ \ 
| | | |  __/ | | (_) |
|_| |_|\___|_|_|\___/ 
                      
root@00f0766080ed:/# 
```

----

### Using image and showing history

The history command lists all the layers composing an image. 
For each layer, it shows its creation time, size, and creation command. 
When an image was built with a Dockerfile, each layer corresponds to a line of the Dockerfile.

```
docker history figlet
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
889cce7caa31        2 weeks ago         /bin/bash                                       39.65 MB            
42118e3df429        3 weeks ago         /bin/sh -c #(nop) CMD ["/bin/bash"]             0 B                 
<missing>           3 weeks ago         /bin/sh -c sed -i 's/^#\s*\(deb.*universe\)$/   1.895 kB            
<missing>           3 weeks ago         /bin/sh -c rm -rf /var/lib/apt/lists/*          0 B                 
<missing>           3 weeks ago         /bin/sh -c set -xe   && echo '#!/bin/sh' > /u   745 B               
<missing>           3 weeks ago         /bin/sh -c #(nop) ADD file:fdbd881d78f9d7d924   124.8 MB        
```

----

### Do it youself

* Create a Dockerfile
    * Install cowsay
    * make the symbolic link `ln -s /usr/games/cowsay /usr/bin/cowsay` static in the Dockerfile
* Build the image
* Run the container from that image
* Run cowsay

----

### Possible Solution

```
FROM ubuntu
RUN apt-get update
RUN apt-get install -y cowsay
RUN ln -s /usr/games/cowsay /usr/bin/cowsay
```
```
docker run -ti cowsay
cowsay hello
```

----

### CMD and Entrypoint
In this lesson, we will learn about two important Dockerfile commands: 
* CMD and ENTRYPOINT.

Those commands allow us to set the default command to run in a container.

----

### Defining a default command
When people run our container, we want to welcome them with a nice hello message, and using a custom font.
For that, we will execute:
```bash
figlet -f script hello
```

* `-f script` tells figlet to use a fancy font.
* hello is the message that we want it to display.

----

### Adding CMD to our Dockerfile
Our new Dockerfile will look like this:
```bash
FROM ubuntu
RUN apt-get update
RUN apt-get install -y figlet
CMD figlet -f script hello
```
* `CMD` defines a default command to run when none is given.
* It can appear at any point in the file.
* Each CMD will replace and override the previous one.
* As a result, while you can have multiple CMD lines, it is useless.

----

### Build and test…

Build the image
```bash
docker build -t figlet .
Sending build context to Docker daemon 91.65 kB
Step 1 : FROM ubuntu
 ---> 42118e3df429
Step 2 : RUN apt-get update
 ---> Using cache
 ---> 48fb734e0326
Step 3 : RUN apt-get install -y figlet
 ---> Using cache
 ---> ccd7cf351f38
Step 4 : CMD figlet -f script hello
 ---> Running in 8b91b84a7c86
 ---> acd649aa600f
Removing intermediate container 8b91b84a7c86
Successfully built acd649aa600f
```

----

Run it
```bash
docker run -ti figlet
 _          _   _       
| |        | | | |      
| |     _  | | | |  __  
|/ \   |/  |/  |/  /  \_
|   |_/|__/|__/|__/\__/ 
```

----

### Overriding CMD

If we want to get a shell into our container (instead of running figlet), we just have to specify a different program to run:
```bash
docker run -ti figlet /bin/bash
root@ca2a5d0b77c5:/# 
```

* We specified `bash`.
* It replaced the value of `CMD`.

----

### Using ENTRYPOINT
We want to be able to specify a different message on the command line, while retaining figlet and some default parameters.
In other words, we would like to be able to do this:
```bash
docker run -ti figlet salut
           _            
          | |           
 ,   __,  | |       _|_ 
/ \_/  |  |/  |   |  |  
 \/ \_/|_/|__/ \_/|_/|_/
```

----

Our new Dockerfile will look like this:
```bash
FROM ubuntu
RUN apt-get update
RUN apt-get install figlet
ENTRYPOINT ["figlet", "-f", "script"]
```

### Using ENTRYPOINT
* `ENTRYPOINT` defines a base command (and its parameters) for the container.
* The command line arguments are appended to those parameters.
* Like `CMD`, `ENTRYPOINT` can appear anywhere, and replaces the previous value.

----

### Build and testing

Build it
```bash
docker build -t figlet .
Sending build context to Docker daemon 92.67 kB
Step 1 : FROM ubuntu
 ---> 42118e3df429
Step 2 : RUN apt-get update
 ---> Using cache
 ---> 48fb734e0326
Step 3 : RUN apt-get install -y figlet
 ---> Using cache
 ---> ccd7cf351f38
Step 4 : CMD figlet -f script hello
 ---> Using cache
 ---> acd649aa600f
Step 5 : ENTRYPOINT figlet -f script
 ---> Running in e82df54f8b7e
 ---> e1003780fba8
Removing intermediate container e82df54f8b7e
Successfully built e1003780fba8
```

----

Run it
```bash
docker run -ti figlet salut
           _            
          | |           
 ,   __,  | |       _|_ 
/ \_/  |  |/  |   |  |  
 \/ \_/|_/|__/ \_/|_/|_/
```

----

### What if we want to use CMD and Entrypoint together?
Then we will use `ENTRYPOINT` and `CMD` together.
* `ENTRYPOINT` will define the base command for our container.
* `CMD` will define the default parameter(s) for this command.

----

### The DOCKERFILE
Our new `DOCKERFILE` will look like this:
```bash
FROM ubuntu
RUN apt-get update
RUN apt-get install -y figlet
ENTRYPOINT ["figlet", "-f", "script"]
CMD ["hello"]
```
* `ENTRYPOINT` defines a base command (and its parameters) for the container.
* If we don't specify extra command-line arguments when starting the container, the value of CMD is appended.
* Otherwise, our extra command-line arguments are used instead of CMD.

----

### Build and test
Build it
```bash
docker build -t figlet .
```
Run it
```
docker run -ti figlet
 _          _   _       
| |        | | | |      
| |     _  | | | |  __  
|/ \   |/  |/  |/  /  \_
|   |_/|__/|__/|__/\__/ 
```
```bash
docker run -ti figlet salut
           _            
          | |           
 ,   __,  | |       _|_ 
/ \_/  |  |/  |   |  |  
 \/ \_/|_/|__/ \_/|_/|_/
```

----

### Overriding ENTRYPOINT
What if we want to run a shell in our container? 
We cannot just do `docker run -ti figlet /bin/bash` because that would just tell figlet to display the word "/bin/bash." 

We use the `--entrypoint` parameter:

```bash
docker run -ti --entrypoint /bin/bash figlet
root@c138bf9ec9ad:/# 
```

----

### Do it yourself
* Create a Dockerfile
    * Base image is ubuntu
    * install cowsay
    * Create the symbolic link
    * Create an ENTRYPOINT to define the base command
    * And with CMD define the default parameter(hello) for this command.
* Build the image
* run the image

----

### Possible Solution
```bash
FROM ubuntu
RUN apt-get update
RUN apt-get install -y cowsay
RUN ln -s /usr/games/cowsay /usr/bin/cowsay
ENTRYPOINT ["cowsay"]
CMD ["hello"]
```

----

### Copying files during the build
So far, we have installed things in our container images by downloading packages. 
We can also copy files from the build context to the container that we are building. 

Remember: the build context is the directory containing the Dockerfile. 

In this chapter, we will learn a new Dockerfile keyword: `COPY`.

----

Build some C code

We want to build a container that compiles a basic "Hello world" program in C.
Here is the program, hello.c:
```c
int main () {
puts("Hello, world!");
return 0;
}
```

Let's create a new directory, and put this file in there.

Then we will write the Dockerfile.

----

### The DOCKERFILE
On Debian and Ubuntu, the package build-essential will get us a compiler.
When installing it, don't forget to specify the `-y` flag, otherwise the build will fail (since the build cannot be interactive).
Then we will use COPY to place the source file into the container.

```bash
FROM ubuntu
RUN apt-get update
RUN apt-get install -y build-essential
COPY hello.c /
RUN make hello
CMD /hello
```

----

### Build and test…

Build it
```bash
docker build -t ubuntu_c .
```
Run it
```bash
docker run ubuntu_c
Hello, world!
````

----

### Copy and the build cache
* Run the build again.
* Now, modify hello.c and run the build again.
* Docker can cache steps involving COPY.
* Those steps will not be executed again if the files haven't been changed.

----

### Details
* You can COPY whole directories recursively.
* Older Dockerfiles also have the ADD instruction.  
It is similar but can automatically extract archives.
    * If we really wanted to compile C code in a compiler, we would:
    * Place it in a different directory, with the WORKDIR instruction.
    * Even better, use the gcc official image. (but it’s huge 1,1 GB, whyever)

----

### Uploading our images to the Docker Hub
We have built our first images.
If we were so inclined, we could share those images through the Docker Hub.
We won't do it since we don't want to force everyone to create a Docker Hub account (although it's free, yay!) but the steps would be:
* have an account on the Docker Hub
* tag our image accordingly (i.e. username/imagename)
* docker push username/imagename

Anybody can now docker run username/imagename from any Docker host.

Images can be set to be private as well

----

### Summary

We've learned how to:
* What an image is
* How to build an image interactively
* How to create a Dockerfile
* How to create an image from a Dockerfile
* The usage of `CMD`and `ENTRYPOINT``
* The usage of `COPY`

----

## Setting up a private registry

In this lesson, I’ll explain:
* How to setup a private registry.
* Ways to secure it.

----

