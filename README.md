App Dev Cloud with JBoss BPM Suite Install Demo 
===============================================
This demo is to install JBoss BPM Suite in the Cloud based on leveraging any Red Hat OpenShift container based platform such as:

 - [Red Hat Container Platform (OCP)](https://github.com/redhatdemocentral/ocp-install-demo)
  
 - [Red Hat Container Development Kit (CDK)](https://github.com/redhatdemocentral/cdk-install-demo)

It delivers a fully functioning JBoss BPM Suite containerized on OSE.


Install JBoss BPM Suite OpenShift
---------------------------------
1. First ensure you have an OpenShift container based installation, such as one of the followling installed first:

  - [OCP Install Demo](https://github.com/redhatdemocentral/ocp-install-demo)

  - [CDK Install Demo](https://github.com/redhatdemocentral/cdk-install-demo)

  - or your own OpenShift installation.

2. [Download and unzip this demo.](https://github.com/redhatdemocentral/rhcs-bpms-install-demo/archive/master.zip)

3. Add products to installs directory.

4. Run 'init.sh' or 'init.bat' file. 'init.bat' must be run with Administrative privileges:
```
   $ ./init.sh 192.168.99.100  # example for OCP.

   $ ./init.sh 10.1.2.2        # example for CDK.
```

5. Login to JBoss BPM Suite to start developing your BPM projects (the address will be generated by the init script):

  - OCP example: [http://rhcs-bpms-install-demo.192.168.99.100.xip.io/business-central](http://rhcs-bpms-install-demo.198.168.99.100.xip.io/business-central)  ( u:erics / p:bpmsuite1! )

  - CDK example: [http://rhcs-bpms-install-demo.10.1.2.2.xip.io/business-central](http://rhcs-bpms-install-demo.10.1.2.2.xip.io/business-central)  ( u:erics / p:bpmsuite1! )


Notes
-----
This project can be installed on any OpenShift platform, such as the Red Hat Container Development Kit (CDK) or OpenShift Container
Platform (OCP). Itis possible to install it on any available installation, just point this installer at your installation by passing
an IP of your OpenShift installation:
```
  $ ./init.sh IP"
```

Should your local network DNS not handle the resolution of the above address, giving you page not found errors, you can apply the
following to your local hosts file:

```
$ sudo vi /etc/hosts

# add host for OCP demo resulution
192.168.99.100   rhcs-bpms-install-demo.192.168.99.100.xip.io

# add host for CDK demo resolution.
10.1.2.2   rhcs-bpms-install-demo.10.1.2.2.xip.io
```


Supporting Articles
-------------------
- [Rocking App Dev in the Cloud with JBoss BPM Suite Install Demo](http://www.schabell.org/2016/03/rocking-appdev-in-cloud-jboss-bpmsuite-install-demo.html)


Released versions
-----------------
See the tagged releases for the following versions of the product:

- v1.3 - JBoss BPM Suite 6.3.0 and JBoss EAP 6.4.7 running on any given OpenShift installation.

- v1.2 - JBoss BPM Suite 6.3.0 and JBoss EAP 6.4.7 running on Red Hat CDK.

- v1.1 - JBoss BPM Suite 6.2.0.GA-redhat-1-bz-1334704 and JBoss EAP 6.4.4 running on Red Hat CDK.

- v1.0 - JBoss BPM Suite 6.2.0-BZ-1299002, JBoss EAP 6.4.4 and running on Red Hat CDK using OpenShift Enterprise image. 

![OSE](https://raw.githubusercontent.com/redhatdemocentral/rhcs-bpms-install-demo/master/docs/demo-images/rhcs-bpms-pod.png)

![BPM Suite](https://raw.githubusercontent.com/redhatdemocentral/rhcs-bpms-install-demo/master/docs/demo-images/bpmsuite.png)
