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

      * default (current)
      * openshift
      * openshift-infra

    Using project "default".
    ```

7. Setup your new project:

    ```
    # create a new project.
    $ oc new-project rhcs-bpms-install-demo

    Now using project "rhcs-bpms-install-demo" on server "https://10.1.2.2:8443".


    # setup our new build.
    $ oc new-build jbossdemocentral/developer:jdk8-uid --name=rhcs-bpms-install-demo --binary=true

    --> Found Docker image 9a8b562 (13 days old) from Docker Hub for "jbossdemocentral/developer:jdk8-uid"
    * An image stream will be created as "developer:jdk8-uid" that will track the source image
    * A Docker build using binary input will be created
      * The resulting image will be pushed to image stream "rhcs-bpms-install-demo:latest"
    --> Creating resources with label build=rhcs-bpms-install-demo ...
    ImageStream "developer" created
    ImageStream "rhcs-bpms-install-demo" created
    BuildConfig "rhcs-bpms-install-demo" created
    --> Success


    # start a build, run from root of rhcs-bpms-install-demo project, this takes some time to upload all of the product sources for build.
    $ oc start-build rhcs-bpms-install-demo --from-dir=.

    Uploading "." at commit "HEAD" as binary input for the build ...
    Uploading directory "." as binary input for the build ...
    rhcs-bpms-install-demo-1


    # watch the build by running the following repeatedly until builds completes.
    $ oc logs rhcs-bpms-install-demo-1-build

    .
    .
    .
    Successfully built 643a74048163
    I0322 21:33:47.956205       1 docker.go:86] Pushing image 172.30.211.34:5000/rhcs-bpms-install-demo/rhcs-bpms-install-demo:latest
    ...
    I0322 21:34:55.625610       1 docker.go:90] Push successful
    ```

8. Finish up the installation and expose a login:

    ```
    $ oc new-app rhcs-bpms-install-demo

    --> Found image 643a740 (6 minutes old) in image stream "rhcs-bpms-install-demo" under tag :latest for "rhcs-bpms-install-demo"
    * This image will be deployed in deployment config "rhcs-bpms-install-demo"
    * Ports 8080/tcp, 9990/tcp, 9999/tcp will be load balanced by service "rhcs-bpms-install-demo"
    --> Creating resources with label app=rhcs-bpms-install-demo ...
    DeploymentConfig "rhcs-bpms-install-demo" created
    Service "rhcs-bpms-install-demo" created
    --> Success
    Run 'oc status' to view your app.


    $ oc expose service rhcs-bpms-install-demo --hostname=rhcs-bpms-install-demo.io

    route "rhcs-bpms-install-demo" exposed
    ```

9. Login to JBoss BPM Suite to start developing your BPM projects:

    [http://rhcs-bpms-install-demo.io/business-central](http://rhcs-bpms-install-demo.io/business-central)   ( u:erics / p:bpmsuite1! )

10. Enjoy application development with JBoss BPM Suite in the Cloud.


Handy OSE Command
-----------------
This is a good way to look at what is being created during all the 'oc' commands above:

    ```
    $ oc get all

    NAME                        TYPE                                           FROM       LATEST
    rhcs-bpms-install-demo      Docker                                         Binary     1

    NAME                        TYPE                                           FROM             STATUS     STARTED         DURATION
    rhcs-bpms-install-demo-1    Docker                                         Binary@56ed14a   Running    2 minutes ago   2m11s
    
    NAME                        DOCKER REPO                                    TAGS                  UPDATED
    developer                   jbossdemocentral/developer                     1.0,jdk8-uid,latest   10 minutes ago
    rhcs-bpms-install-demo      172.30.211.34:5000/rhcs-bpms-install-demo/rhcs-bpms-install-demo                         

    NAME                             READY                                     STATUS     RESTARTS   AGE
    rhcs-bpms-install-demo-1-build   1/1                                       Running    0          2m


Supporting Articles
-------------------
coming soon...


Released versions
-----------------
See the tagged releases for the following versions of the product:

- v1.0 - JBoss BPM Suite 6.2.0-BZ-1299002, JBoss EAP 6.4.4, Red Hat CDK using OpenShift Enterprise image. 

![BPM Suite](https://raw.githubusercontent.com/eschabell/rhcs-bpms-install-demo/master/docs/demo-images/bpmsuite.png)
