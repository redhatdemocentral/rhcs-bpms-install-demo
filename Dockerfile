# Use jbossdemocentral/developer as the base
FROM jbossdemocentral/developer

# Maintainer details
MAINTAINER Andrew Block, Eric D. Schabell, Duncan Doyle, Donato Marrazzo

# Environment Variables 
ENV BPMS_HOME /opt/jboss/bpms/jboss-eap-7.0
ENV BPMS_VERSION_MAJOR 6
ENV BPMS_VERSION_MINOR 4
ENV BPMS_VERSION_MICRO 0
ENV BPMS_VERSION_PATCH GA

ENV EAP_VERSION_MAJOR 7
ENV EAP_VERSION_MINOR 0
ENV EAP_VERSION_MICRO 0

ENV EAP_INSTALLER=jboss-eap-$EAP_VERSION_MAJOR.$EAP_VERSION_MINOR.$EAP_VERSION_MICRO-installer.jar
ENV BPMS_DEPLOYABLE=jboss-bpmsuite-$BPMS_VERSION_MAJOR.$BPMS_VERSION_MINOR.$BPMS_VERSION_MICRO.$BPMS_VERSION_PATCH-deployable-eap7.x.zip

# ADD Installation and Management Files
COPY support/installation-eap support/installation-eap.variables installs/$BPMS_DEPLOYABLE installs/$EAP_INSTALLER support/fix-permissions /opt/jboss/

# Update Permissions on Installers
USER root
RUN usermod -g root jboss && \
    chown 1000:root /opt/jboss/$EAP_INSTALLER /opt/jboss/$BPMS_DEPLOYABLE

# Prepare and run installer and cleanup installation components
RUN sed -i "s:<installpath>.*</installpath>:<installpath>$BPMS_HOME</installpath>:" /opt/jboss/installation-eap \
    && java -jar /opt/jboss/$EAP_INSTALLER  /opt/jboss/installation-eap -variablefile /opt/jboss/installation-eap.variables \
    && unzip -qo /opt/jboss/$BPMS_DEPLOYABLE  -d $BPMS_HOME/.. \
    && chown -R 1000:root $BPMS_HOME \
    && /opt/jboss/fix-permissions $BPMS_HOME \
    && rm -rf /opt/jboss/$BPMS_DEPLOYABLE /opt/jboss/$EAP_INSTALLER /opt/jboss/installation-eap /opt/jboss/installation-eap.variables $BPMS_HOME/standalone/configuration/standalone_xml_history/ \
    && $BPMS_HOME/bin/add-user.sh -a -r ApplicationRealm -u erics -p bpmsuite1! -ro analyst,admin,manager,user,kie-server,kiemgmt,rest-all --silent

# Add support files
COPY support/standalone.xml $BPMS_HOME/standalone/configuration/
COPY support/userinfo.properties $BPMS_HOME/standalone/deployments/business-central.war/WEB-INF/classes/

# Fix permissions on support files
RUN /opt/jboss/fix-permissions $BPMS_HOME/standalone/configuration/standalone.xml && \
    /opt/jboss/fix-permissions $BPMS_HOME/standalone/deployments/business-central.war/WEB-INF/classes/userinfo.properties

# Run as JBoss 
USER 1000

# Expose Ports
EXPOSE 9990 9999 8080 9418 8001

# Run BPMS
CMD ["/opt/jboss/bpms/jboss-eap-7.0/bin/standalone.sh","-c","standalone.xml"]
