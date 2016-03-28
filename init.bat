@ECHO OFF
setlocal

set PROJECT_HOME=%~dp0
set DEMO=Cloud JBoss BPM Suite Install Demo
set AUTHORS=Andrew Block, Eric D. Schabell
set PROJECT=git@github.com:eschabell/rhcs-bpms-install-demo.git

REM wipe screen.
cls

echo.
echo #################################################################
echo ##                                                             ##   
echo ##  Setting up the %DEMO%          ##
echo ##                                                             ##   
echo ##                                                             ##   
echo ##     ####  ####   #   #      ### #   # ##### ##### #####     ##
echo ##     #   # #   # # # # #    #    #   #   #     #   #         ##
echo ##     ####  ####  #  #  #     ##  #   #   #     #   ###       ##
echo ##     #   # #     #     #       # #   #   #     #   #         ##
echo ##     ####  #     #     #    ###  ##### #####   #   #####     ##
echo ##                                                             ## 
echo ##                       ###   #### #####                      ##
echo ##                  #   #   # #     #                          ##
echo ##                 ###  #   #  ###  ###                        ##
echo ##                  #   #   #     # #                          ##
echo ##                       ###  ####  #####                      ##
echo ##                                                             ##   
echo ##  brought to you by,                                         ##   
echo ##             %AUTHORS%                  ##
echo ##                                                             ##   
echo ##  %PROJECT%        ##
echo ##                                                             ##
echo #################################################################
echo.


REM make some checks first before proceeding.	
call where oc >nul 2>&1
if  %ERRORLEVEL% NEQ 0 (
	echo OpenShift command line tooling is required but not installed yet... download here:
	echo https://developers.openshift.com/managing-your-applications/client-tools.html
	GOTO :EOF
)

echo OpenShift commandline tooling is installed...
echo.
echo Loging into OSE...
echo.
call oc login 10.1.2.2:8443 --password=admin --username=admin

if not "%ERRORLEVEL%" == "0" (
  echo.
	echo Error occurred during 'oc login' command!
	echo.
	GOTO :EOF
)

echo.
echo Creating a new project...
echo.
call oc new-project rhcs-bpms-install-demo

echo.
echo Setting up a new build...
echo.
call oc new-build "jbossdemocentral/developer" --name=rhcs-bpms-install-demo --binary=true

if not "%ERRORLEVEL%" == "0" (
  echo.
	echo Error occurred during 'oc new-build' command!
	echo.
	GOTO :EOF
)

echo.
echo Importing developer image...
echo.
call oc import-image developer

if not "%ERRORLEVEL%" == "0" (
  echo.
	echo Error occurred during 'oc import-image' command!
	echo.
	GOTO :EOF
)

echo.
echo Starting a build, this takes some time to upload all of the product sources for build...
echo.
call oc start-build rhcs-bpms-install-demo --from-dir=. --follow=true

if not "%ERRORLEVEL%" == "0" (
  echo.
	echo Error occurred during 'oc start-build' command!
	echo.
	GOTO :EOF
)

echo.
echo Creating a new application...
echo.
call oc new-app rhcs-bpms-install-demo

if not "%ERRORLEVEL%" == "0" (
  echo.
	echo Error occurred during 'oc new-app' command!
	echo.
	GOTO :EOF
)

echo.
echo Creating an externally facing route by exposing a service...
echo.
call oc expose service rhcs-bpms-install-demo --hostname=rhcs-bpms-install-demo.10.1.2.2.xip.io

if not "%ERRORLEVEL%" == "0" (
  echo.
	echo Error occurred during 'oc expose service' command!
	echo.
	GOTO :EOF
)

echo.
echo ====================================================================
echo =                                                                  =
echo =  Login to JBoss BPM Suite to start developing process projects:  =
echo =                                                                  =
echo =  http://rhcs-bpms-install-demo.10.1.2.2.xip.io/business-central  =
echo =                                                                  =
echo =  [ u:erics / p:jbossbpms1! ]                                     =
echo =                                                                  =
echo ====================================================================
echo.


