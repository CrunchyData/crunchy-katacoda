# Final Notes 

**NOTE**: All the programming langauges we used in these exercises are considered "trusted" by PostgreSQL. Trusted means the language does not give the developer access to the operating system file system and are much harder to do "bad things" with them. Because of this, functions written in trusted langauges can be written and used by non-superusers.

If we had done this class in, say Pl/Python, PostgreSQL would have prevented us from making functions since Python is an untrusted language.
While we are not going to cover how to developer with an untrusted in this course, you need to be aware of this restriction.  


I hope this scenario helped:
1. Give you an idea how easy it is to get started with functions in PostgreSQL
1. Get your hands dirty with some basic functions
1. You understand how functions can help you produce better applications

The best way to get better at functions is to keep writing them and playing.  
The container used in this class is available 
[in Dockerhub](https://cloud.docker.com/u/thesteve0/repository/docker/thesteve0/postgres-appdev). 
As long as you have Docker on your machine you can use the same version of PostgreSQL as the workshop. All the 
[data from the](https://github.com/CrunchyData/crunchy-demo-data/releases/tag/v0.1) workshop was intentionally chosen 
from public domain or permissive licenses so that you can use it for commercial and non-commercial purposes. Feel free 
to download it and play some more at your own pace on your own machine.
  
And with that, we are finished.