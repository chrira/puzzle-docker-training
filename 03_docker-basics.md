## Working with containers
After successful installation of Docker, please run:
```bash
git clone https://github.com/ContainerSolutions/docker-workshop-1d
cd docker-workshop-1d
docker run -d -p 8000:1948 -v $(PWD):/usr/src/app/ muellermich/reveal-md:latest
open http://0.0.0.0:8000/hands-on.md#/5
```

We'll come later on to what we just did

----

### Our first containers

At the end of this session, you'll have:
* Seen Docker in action
* Started your "first container"

----

### Docker architecture / recap
* Docker is a client-server application.
    * The **Docker daemon** (or "Engine")  
    Receives and processes incoming Docker API requests
    * The **Docker client**
    Talks to the Docker daemon via the Docker API  
    We'll use mostly the CLI embedded within the docker binary
    * **Docker Hub** Registry  
    Collection of public images  
	The Docker daemon talks to it via the registry API

----

### Hello World
```bash
docker run busybox echo hello world
```

it will echo "hello world" to the default stdout

```bash
docker run busybox echo hello world
hello world  
```

----

### Thanks for you attention
![Dr. Evil](Drevil_million_dollars.jpg)

For more informations, please consult Container Solution or insert another coin

----

## Our first container!

* We used one of the smallest, simplest images available: busybox.
* We ran a single process and echo'ed hello world.

Though, it's not a very useful container 

----

### More useful container
Please type:
```bash
docker run -ti ubuntu /bin/bash
```
This is a brand new container
It runs a bare-bones, no-frills ubuntu system.  
`-it` is shorthand for `-i` `-t`.  
`-i` tells Docker to connect us to the container's stdin.  
`-t` tells Docker that we want a pseudo-terminal.  

Please run:
```bash
figlet hello
```

----

### Install a package
filget is missing in the container, so let's install it using Ubuntu's package manager **apt**
```bash
apt-get update && apt-get install -y figlet
```
`apt-get update` is updating the "catalogue"  
`apt-get install -y figlet` is installing figlet `-y` is without prompting for permissions to install the package

----

### Test
```bash
figlet hello
```

Example output:
```
root@d2fbce5ecbc8:/# figlet hello
 _          _ _       
| |__   ___| | | ___  
| '_ \ / _ \ | |/ _ \ 
| | | |  __/ | | (_) |
|_| |_|\___|_|_|\___/ 
                      
root@d2fbce5ecbc8:/# 
```

----

### Exiting the container

Just exit the shell, like you would usually do (`exit` or `^D`)  
* Our container is now in a stopped state
* It still exists on disk, but all compute resources have been freed up

----

### Do it yourself

Start a new ubuntu container
* Check if figlet is there?
* Install cowsay on a new container using Ubuntus package manager  

Then run:
```
ln -s /usr/games/cowsay /usr/bin/cowsay
cowsay hello
```

----

### Staring new Ubuntu containers
* We started a brand new container
* The basic Ubuntu image was used, and figlet is not here
    * Same will happen to cowsay


We will see in the next chapters how to bake a custom image with figlet

----

## Background containers
Our first containers were interactive.  
We will now see how to:
* Run a non-interactive container.
* Run a container in the background.
* List running containers.
* Check the logs of a container.
* Stop a container.
* List stopped containers.

----

### A non-interactive container
```bash
docker run jpetazzo/clock
Mon Aug 15 13:14:47 UTC 2016
Mon Aug 15 13:14:48 UTC 2016
Mon Aug 15 13:14:49 UTC 2016
```
This container will run forever.
* To stop it, press ^C.
* Docker has automatically downloaded the image jpetazzo/clock.
* This image is a user image, created by jpetazzo.
* I’ll tell more about user images (and other types of images) later

----

### Run a container in the background (deamon)

Containers can be started in the background, with the `-d` flag (daemon mode):
```bash
docker run -d jpetazzo/clock
```
We don't see the output of the container.  
Don't worry: Docker collects that output and logs it!  
Docker gives us the ID of the container.

----

### List running containers

`docker ps` lists running container, just like the UNIX `ps` command, lists running processes

run:
```bash
docker ps
```
Output shows:
* The (truncated) ID of our container.
* The image used to start the container.
* The status.
* Other information (COMMAND, PORTS, NAMES) that I’ll explain later.

----

### Useful flags of docker ps

To see only the last container that was started:
```
docker ps -l
```
To see only the ID of containers:
```
docker ps -q
```
To see only the ID of the last started container:
```
docker ps -ql
```

This is helpful for scripting or doing a lot of experimentation where you start and delete quite a lot of times a container. As an example `docker rm -f $(docker ps -ql)`, which will delete the last started container.

----

### Viewing logs of a containers
View the logs of the jpetazzo/clock container  
`docker ps` to see the CONTAINER ID
```bash
docker logs <CONTAINER ID>
```
We specified a prefix of the full container ID.
* You can, of course, specify the full ID.
* The logs command will output the entire logs of the container.
(Sometimes, that will be too much. Let's see how to address that.)

```bash
docker logs --tail 3 <CONTAINER ID>
```

----

### Follow logs
Just like with the standard UNIX command `tail -f`, we can follow the logs of our container:
```bash
docker logs --tail 1 --follow <CONTAINER ID>
```
It will display the last line in the log file.
* Then, it will continue to display the logs in real time.
* Use ^C to exit.

----

### Stop our container

There are two ways we can terminate our detached container.
* Killing it using the `docker kill` command.
    * kill stops the container immediately, by using the KILL signal.
* Stopping it using the `docker stop` command.
    * stop sends a TERM signal, and after 10 seconds, if the container has not stopped, it sends KILL.

Reminder: the KILL signal cannot be intercepted, and will forcibly terminate the container.

----

### Killing it

```bash
docker kill <CONTAINER ID>
```

All containers should be stopped now:

Verify using `docker ps`

To list also the stopped containers
```
docker ps -a
```

----

## Restarting and attaching to containers
We have started containers in the foreground, and in the background.
Now we will see how to:
* Put a container in the background.
* Attach to a background container to bring it to the foreground.
* Restart a stopped container

----

### Background and foreground
From Docker's point of view, all containers are the same. All containers run the same way, whether there is a client attached to them or not.

It is always possible to detach from a container, and to re-attach to a container.

----

### Detaching from a container

If you have started an interactive container (with option -it), you can detach from it.

* The "detach" sequence is `^P^Q`.
* Or you can detach by killing the Docker client.

Don’t hit `^C`, as this would deliver SIGINT to the container

What does -it stand for?
* `-t` means "allocate a terminal."
* `-i` means "connect stdin to the terminal."

----

### Attaching to a container

You can attach to a container:
```
$ docker attach <containerID>
```
* The container must be running.
* There can be multiple clients attached to the same container.
* Warning: if the container was started without -it…
    * You won't be able to detach with ^P^Q.
    * If you hit ^C, the signal will be proxied to the container.

Remember: you can always detach by killing the Docker client (e.g. close the bash window).

----

### Checking container output

Use docker attach if you intend to send input to the container.  
If you just want to see the output of a container, use docker logs

----

### Restarting a container

When a container has exited, it is in stopped state.
* It can then be restarted with the start command.
```bash
docker start <yourContainerID>
```
The container will be restarted using the same options you launched it with.
You can re-attach to it if you want to interact with it

----

### Do it yourself

* Start a Ubuntu container with the command line flags `-ti`
* Detach from that container
* View logs of that container
* Re-attach to that container
* Restart that container