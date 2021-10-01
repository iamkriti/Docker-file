FROM ubuntu:16.04

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y build-essential binutils libtool make gcc g++ openjdk-8-jdk git dos2unix vim wget 

# jre link
WORKDIR /usr/java
RUN /bin/ln -s /usr/lib/jvm/java-8-openjdk-amd64 /usr/java/latest

# install path ; /usr/local/tomcat
WORKDIR /usr/local
RUN wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.71/bin/apache-tomcat-8.5.71.tar.gz && \
	tar xvfz apache-tomcat-8.5.71.tar.gz && \
	rm apache-tomcat-8.5.71.tar.gz && \
	mv apache-tomcat-8.5.71 tomcat


# env
WORKDIR /root
ENV CATALINA_HOME=/usr/local/tomcat
ENV JAVA_HOME=/usr/java/latest
ENV JRE_HOME=/usr/java/latest/jre
ENV LD_LIBRARY_PATH=.:/usr/local/lib:$JAVA_HOME/bin:$CATALINA_HOME/bin
ENV PATH=$PATH:/usr/java/latest/bin:/usr/local/tomcat/bin
ENV HOME /root
RUN export JAVA_HOME


# eclipse ide
RUN apt-get -y install wget 
RUN wget http://eclipse.c3sl.ufpr.br/technology/epp/downloads/release/2018-09/R/eclipse-java-2018-09-linux-gtk-x86_64.tar.gz -O /tmp/eclipse.tar.gz -q \
&& echo 'Installing eclipse' && tar -xf /tmp/eclipse.tar.gz -C /opt \
  &&  rm /tmp/eclipse.tar.gz && ln -s /opt/eclipse/eclipse /usr/local/bin/eclipse 

RUN apt-get install gedit -y
RUN export DISPLAY=:0

VOLUME ["/usr/local/tomcat/webapps","/usr/local/lib"]
EXPOSE 8080

CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]
