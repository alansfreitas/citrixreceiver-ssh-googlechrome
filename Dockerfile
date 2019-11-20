# "ported" by Adam Miller <maxamillion@fedoraproject.org> from
#   https://github.com/fedora-cloud/Fedora-Dockerfiles
#
# Originally written for Fedora-Dockerfiles by
#   scollier <scollier@redhat.com>

FROM centos:centos7
MAINTAINER The CentOS Project <cloud-ops@centos.org>

#installing ssh and inserting password to user "user" and passwword "newpass"

RUN yum -y update; yum clean all
RUN yum -y install openssh-server passwd; yum clean all
ADD ./start.sh /start.sh
RUN mkdir /var/run/sshd

RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' 

RUN chmod 755 /start.shi
# workaround to conection issue
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# script with user and password
RUN ./start.sh

# add rpm from google chrome
ADD ./google-chrome-stable_current_x86_64.rpm /google-chrome-stable_current_x86_64.rpm
# installing google chrome and enabling X11 forward by ssh
RUN yum -y install /google-chrome-stable_current_x86_64.rpm && yum -y install xorg-x11-xauth; yum clean all
# add package from citrix receiver
ADD ./ICAClientWeb-rhel-13.8.0.10299729-0.x86_64.rpm /ICAClientWeb-rhel-13.8.0.10299729-0.x86_64.rpm
# installing citrix receiver
RUN yum -y install ICAClientWeb-rhel-13.8.0.10299729-0.x86_64.rpm; yum clean all
# add certificate from virtual desktop portal
ADD ./Digicert.pem /opt/Citrix/ICAClient/keystore/cacerts
# instaling certificate
RUN /opt/Citrix/ICAClient/util/ctx_rehash 
# expose ssh daemon
ENTRYPOINT ["/usr/sbin/sshd", "-D"]
