App Dev Cloud with JBoss BPM Suite Install Demo 
===============================================
This demo is to install JBoss BPM Suite in the Cloud based on leveraging the Red Hat 
Container Development Kit (CDK) and the provided OpenShift Enterprise (OSE) image. 
It delivers a fully functioning JBoss BPM Suite containerized on OSE.


Install on Red Hat CDK OpenShift Enterprise image
-------------------------------------------------
1. First complete the installation and start the OpenShift image supplied in the [cdk-install-demo](https://github.com/eschabell/cdk-install-demo).

2. [Download and unzip this demo.](https://github.com/eschabell/rhcs-bpms-install-demo/archive/master.zip)

3. Add products to installs directory.

4. To access CDK OSE installation, make sure your ~/.kube/config provides access, see example in support/kube-config-example file.

5. Install [OpenShift Cient Tools](https://developers.openshift.com/managing-your-applications/client-tools.html) if you have not done so previously.

6. Login to your CDK OpenShift instance:

    ```
    $ oc login

    Authentication required for https://10.1.2.2:8443 (openshift)
    Username: admin
    Password: admin

    Login successful.

    You have access to the following projects and can switch between them with 'oc project <projectname>':

      * default
      * openshift
      * openshift-infra
    ```

7. Setup your new project (the last command takes some time):

    ```
    $ oc new-project bpms-install-demo

    $ oc new-build jbossdemocentral/developer:jdk8-uid --name=rhcs-bpms-install-demo --binary=true   [3]

    # run from root of rhcs-bpms-install-demo project.
    #
    $ oc start-build rhcs-bpms-install-demo --from-dir=.

    # watch the build by running the following repeatedly until builds completes.
    #
    $ oc logs rhcs-bpms-install-demo-1-build
    ```

8. Finish up the installation and expose a login:

    ```
    $ oc new-app bpms-install-demo

    $ oc expose service bpms-install-demo --hostname=bpms-install-demo.10.1.2.2.xip.io
    ```

9. Login to JBoss BPM Suite to start developing your BPM projects:

    ```
    http://bpms-install-demo.10.1.2.2.xip.io/business-central   ( u:erics / p:bpmsuite1! )
    ```
10. Enjoy installed and configured JBoss BPM Suite.


Supporting Articles
-------------------
coming soon...


Released versions
-----------------
See the tagged releases for the following versions of the product:

- v1.0 - JBoss BPM Suite 6.2.0-BZ-1299002, JBoss EAP 6.4.4, Red Hat CDK using OpenShift Enterprise image. 

![BPM Suite](https://raw.githubusercontent.com/eschabell/rhcs-bpms-install-demo/master/docs/demo-images/bpmsuite.png)
