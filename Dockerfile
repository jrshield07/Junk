FROM tomcat

RUN echo "openam.swo.com" > /etc/hostname
RUN echo "PS1='\033[01;32m${debian_chroot:+($debian_chroot)}\u@\h\033[00m\]:\w\$'" >> /root/.bashrc

RUN apt-get update
RUN apt-get -y install vim
RUN apt-get -y install net-tools

COPY AM*.war /usr/local/tomcat/webapps/openam.war
COPY Amster* /data/
COPY setup.amster /data/
COPY entrypoint.sh /data/
COPY setup.sh /data/
RUN unzip /data/Amster-7.0.1.zip -d /data/amster
WORKDIR /forgerock

RUN chmod 755 /data/*.sh

EXPOSE 8080
ENTRYPOINT ["/data/entrypoint.sh"]
