# Load Dev Environment

## Start up / Refreshing

To start locally this project or to refresh the changes please run the following commands:

`cd katacoda/`

`./build-dev.sh`

## HTTPS tunnel
As katacoda loads over HTTPS, when is trying to load the `externalcss` there is an error `Failed to load resource: net::ERR_SSL_PROTOCOL_ERROR`.
An HTTPS site can't load an HTTP element over HTTPS, so to workaround this in the development environment we need to create an HTTPS tunnel for the static resources.
In order to do that we can use ngrok.

- [Install and configure ngrok](https://dashboard.ngrok.com/get-started)
- Assuming your environment is already up, and you can access to http://localhost:8080/, expose your local server to the public internet over a secure tunnel using this command:

`./ngrok http 8080`

You should see something similar to:

```
ngrok by @inconshreveable                                                                                                                                    
Session Status                online                                                                                                                                                                                                                                      
Account                       soria.gaby@gmail.com (Plan: Free)                                                                                                                                                                                                           
Version                       2.3.35                                                                                                                                                                                                                                      
Region                        United States (us)                                                                                                                                                                                                                          
Web Interface                 http://127.0.0.1:4040                                                                                                                                                                                                                       
Forwarding                    http://28b06e54.ngrok.io -> http://localhost:8080                                                                                                                                                                                           
Forwarding                    https://28b06e54.ngrok.io -> http://localhost:8080                                                                                                                                                                                          

Connections                   ttl     opn     rt1     rt5     p50     p90                                                                                                                                                                                                 
                              0       0       0.00    0.00    0.00    0.00   

```

- Use the HTTP URL provided for ngrok to reference to the static resources as `externalcss`, for example:

```
<div id="katacoda-terminal"
  data-katacoda-id="{{.Site.KatacodaUser}}/courses/{{ .Training.Name }}/{{ .Name }}"
  data-katacoda-ctatext="Continue Learning" data-katacoda-ctaurl="http://{{.Site.VirtualHost}}/{{ .Training.Name }}/"
  data-katacoda-color="#226aa6"
  data-katacoda-secondary="#c00"
  data-katacoda-background="#fff"
  data-katacoda-font="Open Sans"
  style="height: calc(100vh - 114px);"
  data-katacoda-externalcss="https://28b06e54.ngrok.io/static/katacoda.css">
</div>
```
