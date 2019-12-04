In this exercise we will introduce containers (which you may know as Docker) and then spin up our PostgreSQL instance 
using containers. 

## A Little Background on Containers

Containers have quite a long history in computing before Docker. At a simplistic level, containers "package up" applications
and their dependencies to run with everything that is needed above the kernel OS. This allows for a cleaner separation 
of dependencies as the container has all the things it needs to run except the kernel. Here is 
[good introduction](https://medium.freecodecamp.org/a-beginner-friendly-introduction-to-containers-vms-and-docker-79a9e3e119b) 
to Docker containers. Be aware that there are [other](https://containerd.io/) container runtimes and specifications besides
Docker.

Containers are spun up from a container image. In this class we will use "container" to denote the running container 
and "image" to denote the binary used to spin up the container.

Another advantage of images is that not only do they container the binaries for the application but they also are configured 
and ready to run. With a container you can skip most of the configuration and just do some version of "container run"  

In this class we will be using a image that contains Postgresql, PostGIS, embedded R, and some other extensions. If 
you have ever tried to install all these pieces you know what a hassle it can be. Let's see how easy it can be with containers. 

## Running PostgreSQL in Containers

Crunchy Data has produced a full [suite of containers](https://github.com/CrunchyData/crunchy-containers) to make PostgreSQL
simpler and easier to run in containerized environments. Today we will be using a container that was purposefully built for 
developers. The container makes some tradeoffs
1. It has the most used extensions already included in the binaries
1. It only requires one environment variable - a password. Everything else is optional
1. It doesn't require any volume mappings but allows for optional ones
1. Its target user is a developer on their primary development machine
1. Its not supported or intended for production use 
1. It does not support replication or high availability scenarios

It's goal is to get you up and running quickly and easily for your development work.  

#### Simplest method

Let's start with the quickest and easiest way to start up PostgreSQL using a container.

`docker run -e PG_PASSWORD=password thesteve0/postgres-appdev`{{execute}}

If you click the little check mark in the box above it will execute the command in the terminal window. 
What you are doing is telling docker to run image 
[_thesteve0/postgres-appdev_](https://cloud.docker.com/u/thesteve0/repository/docker/thesteve0/postgres-appdev) and pass 
in the environment variable for what you want the password to be for both the standard user and the postgres (DBAdmin) user. 

1. The default name for the primary database will be: mydb
1. The default username is: rnduser2w3
1. The default port will be: 5432
1. And the postgres user password will be equal to the user password which you set in the command.

**CONGRATULATIONS you just spun up a fully working PostgreSQL database with a bunch of functionality!**  

But this is a pretty simplistic way to start PostgreSQL - great if you wanna just "get going quickly". 

Because we didn't run the container in "detached" mode we never got our prompt back. Detached mode allows the container 
to run in the background and give us back our prompt. To shut down the container click on tab  titled "Terminal 2" and 
find out information on our running container:

`docker ps`{{execute}}
    
![dockerps](runcontainers/assets/docker_ps.jpg)


Please note either the name or the ID of your running container (highlighted in red above). Now in the same terminal type 
in the following command:     

`docker kill <id or name of your container>`
    
Docker kill is the way to stop your running container - it send the shutdown signal to the running container which should 
kill the primary process in the container (in this case the PostgreSQL server process). 
If you go back to the first tab, "Terminal" you will see that you get your prompt back. Let's start PostgreSQL more 
appropriately for your daily work. 

#### Better way to start the container

Let's set a new username, give the container a fixed (rather than random) name, expose port 5432 from the container 
into the VM we are running, and have it detach so we can get our prompt back. 

`docker run -d -p 5432:5432 -e PG_USER=groot -e PG_PASSWORD=password -e PG_DATABASE=workshop --name=pgsql thesteve0/postgres-appdev`{{execute}}
    
And with that we have now spun up PostgreSQL with
1. The ability to connect from our VM to the instance running in the container
1. Username: groot
1. Password: password
1. A database named: workshop
1. A container named: pgsql

If you want to now log into that running instance of PostgreSQL you can do:

`psql -U groot -h localhost workshop`

We don't need the port mapping because the psql cli assumes PostgreSQL to be running on port 5432.

#### A little container management

The good part about naming the container is that we can do things like - stop the container 

`docker kill pgsql`{{execute}}

and the start it again with all the same setting as last time

`docker start pgsql`{{execute}}

or 

`docker restart pgsql`{{execute}}

Not only will this retain the setting but all the data you added before will be there when you restart the container. 

If you wanted to have PostgreSQL instances with different data or even different versions you could start up images into 
containers with different names. This way you could spin them up and down as needed.

If you want to see all the images on your machine just do the following command:

`docker images`{{execute}}




