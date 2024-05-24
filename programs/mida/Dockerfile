FROM tomcat:9

#COPY ./mida.war /usr/local/tomcat/webapps
#COPY ./mida.war /usr/local/tomcat/webapps.dist

RUN mv /usr/local/tomcat/webapps /usr/local/tomcat/webapps2
RUN mv /usr/local/tomcat/webapps.dist /usr/local/tomcat/webapps
ADD mida.war /usr/local/tomcat/webapps/

EXPOSE 8080

CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]

 