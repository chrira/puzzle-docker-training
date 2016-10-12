## Local Development Workflow with Docker
At the end of this lesson, you will be able to:
* Share code between container and host.
* Use a simple local development workflow.

----

### Using a Docker container for local development

Never again:
* "Works on my machine"
* "Not the same version"
* "Missing dependency"
By using Docker containers, we will get a consistent development environment.

----

### Our nodejs application

The code is in the folder `./cicd/vagrant/nodejs_app/``

Let's build and run that application using the provided Dockerfile.nodejs

```
cd cicd/vagrant/nodejs_app/
docker build -t nodejs-app-example -f Dockerfile.nodejs .
docker run -d -p 8000:8000 nodejs-app-example
```

----

### Let's look at the code

```
ls -lsa .
total 40
0 drwxr-xr-x  7 michael.mueller  staff   238B 23 Sep 12:52 .
0 drwxr-xr-x  9 michael.mueller  staff   306B 23 Sep 16:15 ..
8 -rw-r--r--  1 michael.mueller  staff   263B 23 Sep 12:27 Dockerfile.jenkins
8 -rw-r--r--  1 michael.mueller  staff   142B 23 Sep 11:48 Dockerfile.nodejs
8 -rw-r--r--  1 michael.mueller  staff   417B 23 Sep 17:54 app.js
8 -rw-r--r--  1 michael.mueller  staff   433B 23 Sep 12:05 docker-compose.yaml
8 -rw-r--r--  1 michael.mueller  staff   186B 23 Sep 11:48 package.json
```

----

### Where's my code?

According to the Dockerfile, the code is copied into /app :
```
FROM google/nodejs

WORKDIR /app
ADD package.json /app/
RUN npm install
ADD . /app

EXPOSE 8000
CMD []
ENTRYPOINT ["/nodejs/bin/npm", "start"]
```
We want to make changes inside the container without rebuilding it each time.

For that, we will use a volume.

----

### Our first volume

We will tell Docker to map the current directory to /app in the container.
```
docker run -d -v $(pwd):/app -p 8001:8000 nodejs-app-example
```
* The -v flag provides volume mounting inside containers.
* nodejs-app-example is the name of the image we will run.
* We don't need to give a command to run because the Dockerfile already specifies it.

----

### Mounting volumes inside containers

The -v flag mounts a directory from your host into your Docker container. The flag
structure is:
```
[host-path]:[container-path]:[rw|ro]
```
* If [host-path] or [container-path] doesn't exist it is created.
* You can control the write status of the volume with the ro and rw options.
* If you don't specify rw or ro, it will be rw by default.
There will be a full chapter about volumes

----

### Testing the development container

Now let us see if our new container is running.
```
open http://0.0.0.0:8001
```

----

### Making a change to our application

Our customer really doesn't like the message. Let's change it.
```
vi app.js
```

And change
```
response.end("Hello World\n");
```

To:
```
response.end("Hello\n");
```

----

### Refreshing our application

Now let's refresh our browser:

We can't see the updated message of our application.

Some frameworks pick up changes automatically.
Others require you to restart after each modification.

----

### Workflow explained

We can see a simple workflow:
1. Build an image containing our development environment.
2. Start a container from that image.
Use the -v flag to mount source code inside the container.
3. Edit source code outside the containers, using regular tools.
4. Test application.
5. Repeat last two steps until satisfied.
6. When done, commit+push source code changes.

----

### Debugging inside the container

In 1.3, Docker introduced a feature called docker exec.

It allows users to run a new process in a container which is already running.

It is not meant to be used for production (except in emergencies, as a sort of pseudoSSH),but it is handy for development.

You can get a shell prompt inside an existing container this way

----

### docker exec example

```
docker exec -ti <id> bash
```

----

### Summary

We've learned how to:
* Share code between container and host.
* Set our working directory.
* Use a simple local development workflow