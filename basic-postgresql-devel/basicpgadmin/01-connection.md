# Connecting to our Database

If you look at the second tab in our learning interface it says PgAdmin4. Go ahead and click that tab which should spawn a new browser window or tab. You may have to wait a few seconds while the PGAdmin4 interface gets rendered.  You should now be able 
to login using username _admin_ and password _password_.

## First screen

You should be seeing a screen that looks like this:

![Home Screen](basicpgadmin/assets/01-home-screen.png)

This is the home page for PgAdmin4. Before we can do anything meaningful we need to connect to a PostgreSQL server. There are two ways to do this:

1. Click on the "Add New Server" butting in the middle of the screen. 
1. Right click on the Servers icon in the top left of the left navigation panel.

Let's start by doing the right click option because it will give us more flexibility.

### Right click options

![Create Server](basicpgadmin/assets/01-server-selection.png)

When you right click on the icon you should see a list of options. Go ahead and mouse over _create_. This will then show _server group_ and _server_. If you are going to manage and interact with a lot of PostgreSQL servers then you might want to create server groups such as testing vs production. Server groups is just a logical organization in the PgAdmin interface. 

In our case since we are only managing one server, go ahead and click server to bring up the new create server dialog.

## Create Server Dialog

While there are quite a few boxes and tabs in this dialog, only a few of them are actually required to create a new server in PgAdmin.

### First Tab

![First Tab](basicpgadmin/assets/01-create-server-tab1.png)

On the general tab, the only field required is _Name_. This name represents the name YOU want to use to identify this PostgreSQL server in the PgAdmin interface. You could call it monkey if you want - it doesn't **require** any relation to a name in the real world. 

For today's exercise let's name it **"Workshop"**

In the comment field you can put in some information about this server connection. The information can be brought up in the interface later and can help you remember facts about this server.

Once you are done filling in those fields go ahead and click on the second tab titled _Connection_.

### Second Tab

This _Connection_ tab contains most of the important information about your server. 

![Second Tab](basicpgadmin/assets/01-create-server-tab2.png)

In the Host name/address field you put the IP address, DNS name, or network name PgAdmin should use to reach your PostgreSQL Server. 
For today's exercise we are running PgAdmin and PostgreSQL in containers with a host network so we are going to use the 
container name for our server, which is _pgsql_.  

> Put **pgsql** in the address box.



Note: you can also run PgAdmin4 on your local machine, which means you would use the address that you use to connect from 
your local machine to the DB server. 

Port 5432 is the default port for PostgreSQL so we will leave that alone. By default, the name of the maintenance database
is _postgres_ so we leave that alone as well. 

The next crucial piece of information is Username and Password. This is the username and password you use to connect to your 
PostgreSQL server. We are going to connect as a normal, unprivileged user: 
>* username: groot 
>* password: password

For convenience you can save the password on the PgAdmin server - check it if you want.

And now we are finished with all the information required to connect. Go ahead and click the **Save** button on the bottom 
of the dialog.

The other tabs are for more advanced use cases not covered today.

### What you should see now   

After clicking the **Save** button, your left nav should now have a connection named _Workshop_.

![New Connection](basicpgadmin/assets/01-new-connection.png)
    
  
## Wrap Up
You now have successfully connected PgAdmin4 to your PostgreSQL server - this is probably one of the more confusing aspects
 of PgAdmin usage - congrats! The rest of our steps will help you navigate and get work done in PgAdmin4.
