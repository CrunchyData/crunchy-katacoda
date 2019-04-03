In this exercise we will introduce containers (which you may know as Docker) and then spin up our PostgreSQL instance 
using containers. 

## A Little Background on Containers

Containers have quite a long history in computing before Docker. At a simplistic level, containers "package up" applications
and their dependencies to run with everything that is needed above the kernel OS. This allows for a cleaner separation 
of dependencies as the container has all the things it needs to run except the kernel. Here is 
[good introduction](https://medium.freecodecamp.org/a-beginner-friendly-introduction-to-containers-vms-and-docker-79a9e3e119b) 
to Docker containers. Be aware that there are [other](https://containerd.io/) container runtimes and specifications besides
Docker.

Containers are spun up from a container image. In this workshop we will use container to denote the running container 
and image to denote the binary used to spin up the container.

Another advantage of images is that not only do they container the binaries for the application but they also are configured 
and ready to run. With a container you can skip most of the configuration and just do some version of "container run"  

In this workshop we will be using a image that contains Postgresql, PostGIS, embedded R, and some other extensions. If 
you have ever tried to install all these pieces you know what a hassle it can be. Let's see how easy it can be with containers. 

## Running PostgreSQL in Containers



Now that we have PostgreSQL running let's move on to adding some tables and data.
