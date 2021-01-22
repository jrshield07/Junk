FROM tomcat:8.5.61-jdk11-openjdk

ENV CATALINA_OPTS "$CATALINA_OPTS -Djavax.net.ssl.trustStore=/forgerock/certificates/truststore \
-Djavax.net.ssl.trustStorePassword=changeit \
-Djavax.net.ssl.trustStoreType=jks"

RUN echo "openam.swo.com" > /etc/hostname
RUN echo "PS1='\033[01;32m${debian_chroot:+($debian_chroot)}\u@\h\033[00m\]:\w\$'" >> /root/.bashrc

RUN apt-get update
RUN apt-get -y install vim
RUN apt-get -y install net-tools
RUN apt-get -y install sudo

RUN useradd -ms /bin/bash forgerock
RUN echo "forgerock     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
#RUN usermod -aG sudo forgerock

#USER forgerock

COPY AM*.war /usr/local/tomcat/webapps/openam.war
COPY Amster* /data/
COPY setup.amster /data/
COPY entrypoint.sh /data/
COPY setup.sh /data/
RUN unzip /data/Amster-7.0.1.zip -d /data/amster
WORKDIR /forgerock

RUN mkdir -p certificates
COPY keystore* /forgerock/certificates/
COPY truststore /forgerock/certificates/
RUN chmod 750 /forgerock/certificates/*

RUN chown -R forgerock:forgerock /forgerock
RUN mkdir -p /usr/local/tomcat/webapps/openam
RUN mkdir -p /usr/local/tomcat/conf/Catalina/localhost
RUN chown -R forgerock:forgerock /usr/local/tomcat/webapps
RUN chown -R forgerock:forgerock /usr/local/tomcat/
RUN chmod 755 /data/*.sh

USER forgerock
RUN unzip -q /usr/local/tomcat/webapps/openam.war -d /usr/local/tomcat/webapps/openam

EXPOSE 8080
ENTRYPOINT ["/data/entrypoint.sh"]
