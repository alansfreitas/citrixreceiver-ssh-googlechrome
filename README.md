# dockerfiles-centos-ssh-googlechrome-citrix-receiver

Running Citrix Receiver with google chrome in any linux distribution running podman or docker(no tested)

# Building & Running

Copy the sources to your docker host and build the container:

	
	$ podman build --rm -t user/ssh:centos7 .

To run:

	$ podman run -d -p 22 user/ssh:centos7

Get the port that the container is listening on:

```
# podman ps
CONTAINER ID        IMAGE                 COMMAND             CREATED             STATUS              PORTS                   NAMES
8c82a9287b23        <username>/ssh:centos7   /usr/sbin/sshd -D   4 seconds ago       Up 2 seconds        0.0.0.0:49154->22/tcp   mad_mccarthy        
```

Use SSH with x11 forwarding:

	$ ssh -X -p 49154 user@localhost 

Use password "newpass" in startup.sh script

Use google chrome without sandbox to download ICA file:

	$ google-chrome --no-sandbox
	
After download ICA file use Citrix Receiver command to run Virtual Desktop:

	$ /opt/Citrix/ICAClient/wfica /home/user/Downloads/xxxx.ica
