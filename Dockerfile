# "ported" by Adam Miller <maxamillion@fedoraproject.org> from
#   https://github.com/fedora-cloud/Fedora-Dockerfiles
#
# Originally written for Fedora-Dockerfiles by
#   scollier <scollier@redhat.com>

FROM centos:centos7
MAINTAINER The CentOS Project <cloud-ops@centos.org>

RUN yum -y update; yum clean all
RUN yum -y install openssh-server passwd; yum clean all
ADD ./start.sh /start.sh
RUN mkdir /var/run/sshd

RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' 

RUN chmod 755 /start.sh

RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# EXPOSE 22
RUN ./start.sh

ADD ./google-chrome-stable_current_x86_64.rpm /google-chrome-stable_current_x86_64.rpm

RUN yum -y install /google-chrome-stable_current_x86_64.rpm && yum -y install xorg-x11-xauth; yum clean all

ADD ./ICAClientWeb-rhel-13.8.0.10299729-0.x86_64.rpm /ICAClientWeb-rhel-13.8.0.10299729-0.x86_64.rpm

RUN yum -y install ICAClientWeb-rhel-13.8.0.10299729-0.x86_64.rpm; yum clean all

ADD ./Digicert.pem /opt/Citrix/ICAClient/keystore/cacerts

RUN /opt/Citrix/ICAClient/util/ctx_rehash 

ENTRYPOINT ["/usr/sbin/sshd", "-D"]
