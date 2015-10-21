#Maestro

* Easy web browser automation
* Website transaction monitor
* Monitor website functionality and uptime with a real web browser

##What is Maestro
Maestro = [Ragios](https://github.com/obi-a/ragios) + [Uptime_monitor plugin](https://github.com/obi-a/uptime_monitor) + [Firefox](https://en.wikipedia.org/wiki/Firefox) + [Xvfb](https://en.wikipedia.org/wiki/Xvfb)

Maestro is a docker image with Ragios + Uptime_monitor plugin + firefox + Xvfb, all setup and already configured to run out of the box, dockerized and shipped in a container.

##Usage:
Launch a CouchDB container
```
docker run -d --name couchdb -p 5984 klaemo/couchdb
```
Launch a Maestro container
```
docker run -t -i --name ragios --link couchdb:couchdb -p 5041:5041 obiora/maestro
```

Now with the Maestro container up and running, you are all set. You can now access Ragios Admin dashboard in a web browser from [http://localhost:5041](http://localhost:5041).

##Using the Uptime Monitor
Easiest way to start adding monitors is using the Ragios ruby client with pry or irb.
Install the ragios-client rubygem:
```
gem install ragios-client
```
Using ragios-client to add a monitor inside irb or pry.
```ruby
require "ragios-client"
ragios = Ragios::Client.new

monitor = {
  monitor: "Google.com home page",
  url: "https://google.com",
  every: "1h",
  contact: "foo.bar@gmail.com",
  via: "gmail_notifier",
  plugin: "uptime_monitor",
  exists?: 'title.with_text("Google")',
  browser: "firefox headless"
}
ragios.create(monitor)
#=> {:monitor=>"Google.com home page",
# :url=>"https://google.com",
# :every=>"1h",
# :contact=>"foo.bar@gmail.com",
# :via=>["gmail_notifier"],
# :plugin=>"uptime_monitor",
# :exists?=>"title.with_text(\"Google\")",
# :browser=>"firefox headless",
# :created_at_=>"2015-10-20T17:22:38Z",
# :status_=>"active",
# :_id=>"e774da1f-cc8c-481b-92ea-d1bd272bf1f8",
# :type=>"monitor"}
```
The monitor created above uses the uptime_monitor plugin to launch the firefox web browser every hour to visit Google.com and verify that the homepage title tag text is the string "Google". The validation is defined in the key/pair *exists?: 'title.with_text("Google")'*. The important thing to note is that firefox is running inside the docker container, so it has to run as a headless browser, this is defined in the key/value pair *browser: "firefox headless"*. When using Maestro, always specify firefox as headless.

For a complete guide on using ragios-client see here: [Using Ragios](http://www.whisperservers.com/ragios/ragios-saint-ruby/using-ragios/)

For a complete guide on using the uptime_monitor plugin see here: [Using Uptime_monitor plugin](https://github.com/obi-a/uptime_monitor/blob/master/README.md#usage)

##Building the image
To build the Maestro Docker image:

Git clone the Maestro Github repo:
```
git clone https://github.com/obi-a/maestro.git
```
From the Maestro root directory, build the Maestro docker image
```
docker build -t my-maestro .
```
Launch a couchDB container:
```
docker run -d --name couchdb -p 5984 klaemo/couchdb
```
Launch the Maestro image linked to the CouchDB container:
```
docker run -t -i --name my-maestro --link couchdb:couchdb -p 5041:5041 my-maestro
```

##Configure Ragios
Before building the docker image you can add environment variables to the Dockerfile to configure Ragios. The Dockerfile is at the root directory of the Maestro Repo. For example to use the gmail_notifier (so that Ragios will send you notifications via gmail), add the correct environment variables to the Dockerfile and build it. The dockerfile will look like this below, look at line 4 and 5:
```bash
FROM cloudgear/ruby:2.2-onbuild
ENV RAGIOS_COUCHDB_ADDRESS couchdb
ENV RAGIOS_BIND_ADDRESS tcp://0.0.0.0:5041
ENV GMAIL_USERNAME foo
ENV GMAIL_PASSWORD bar
RUN apt-get update
RUN apt-get install -y firefox xvfb
EXPOSE 5041
CMD ./ragios s start
```
Notice the lines:
```
ENV GMAIL_USERNAME foo
ENV GMAIL_PASSWORD bar
```
This configures the built-in gmail_notifier with the above environment variables providing the gmail username and password to Ragios. All ENV variables used to configure Ragios can be added to the image in this manner. Read more about the gmail_notifier & other notifiers and how to configure them here: [Ragios Notifications](http://www.whisperservers.com/ragios/ragios-saint-ruby/notifications/).
