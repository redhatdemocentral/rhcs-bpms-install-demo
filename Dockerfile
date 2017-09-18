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
ENV EAP_PATCH=jboss-eap-7.0.5-patch.zip
ENV BPMS_PATCH_WILDCARD=jboss-bpmsuite-6.4.?-*

# ADD Installation and Management Files
COPY support/installation-eap support/installation-eap.variables support/standalone.xml support/userinfo.properties installs/*.zip installs/*.jar /opt/jboss/

#Update Permissions on Installers
# Run as JBoss 
USER 1000

# Prepare and run installer and cleanup installation components
RUN sed -i "s:<installpath>.*</installpath>:<installpath>$BPMS_HOME</installpath>:" /opt/jboss/installation-eap && \
    java -jar /opt/jboss/$EAP_INSTALLER  /opt/jboss/installation-eap -variablefile /opt/jboss/installation-eap.variables && \ 
    if [ -e /opt/jboss/$EAP_PATCH ]; then $BPMS_HOME/bin/jboss-cli.sh --commands=patch\ apply\ /opt/jboss/$EAP_PATCH\ --override-all; fi && \
    unzip -qo /opt/jboss/$BPMS_DEPLOYABLE  -d $BPMS_HOME/.. && \
    for f in /opt/jboss/$BPMS_PATCH_WILDCARD; do \
      unzip -qo $f -d /opt/jboss/ && \
      (cd ${f::-4} && exec ./apply-updates.sh $BPMS_HOME eap7.x); \
    done && \
    mv /opt/jboss/standalone.xml $BPMS_HOME/standalone/configuration/ && \
    mv /opt/jboss/userinfo.properties $BPMS_HOME/standalone/deployments/business-central.war/WEB-INF/classes/ && \
    rm -rf /opt/jboss/$BPMS_DEPLOYABLE /opt/jboss/$EAP_INSTALLER /opt/jboss/installation-eap /opt/jboss/installation-eap.variables $BPMS_HOME/standalone/configuration/standalone_xml_history/ && \
    rm -rf /opt/jboss/$EAP_PATCH /opt/jboss/$BPMS_PATCH_WILDCARD && \
    $BPMS_HOME/bin/add-user.sh -a -u bpmsAdmin -p BPMs3cr3t --role admin,developer,analyst,user,manager,kie-server,rest-all,Administrators

# Extra users
# RUN $BPMS_HOME/bin/add-user.sh -a -u user,casehandler1 -p BPMs3cr3t --role casehandler

# Expose Ports
EXPOSE 9990 9999 8080 9418 8001

# Run BPMS
CMD ["/opt/jboss/bpms/jboss-eap-7.0/bin/standalone.sh","-c","standalone.xml"]
