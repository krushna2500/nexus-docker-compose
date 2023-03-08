FROM ubuntu:20.04

RUN apt update -y 
RUN apt install nano 
RUN apt install curl -y && apt install ssh -y && apt install wget -y 

RUN apt install openjdk-8-jdk -y

RUN useradd -M -d /opt/nexus -s /bin/bash -r nexus

#CMD ["tail", "-f", "/dev/null"]

RUN mkdir /etc/sudoers.d

RUN touch /etc/sudoers.d/nexus

RUN echo "nexus ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/nexus

RUN mkdir /opt/nexus

RUN wget https://sonatype-download.global.ssl.fastly.net/repository/downloads-prod-group/3/nexus-3.44.0-01-unix.tar.gz

RUN tar xzf nexus-3.44.0-01-unix.tar.gz -C /opt/nexus --strip-components=1

RUN chown -R nexus:nexus /opt/nexus

RUN rm /opt/nexus/bin/nexus.vmoptions

#RUN touch /opt/nexus/bin/nexus.vmoptions

COPY nexus.vmoptions /opt/nexus/bin/nexus.vmoptions

RUN rm /opt/nexus/bin/nexus.rc

COPY nexus.rc /opt/nexus/bin/nexus.rc

#RUN touch /etc/systemd/system/nexus.service

#COPY nexus.service /etc/systemd/system/nexus.service
EXPOSE 8081

CMD ["/opt/nexus/bin/nexus", "run"]
