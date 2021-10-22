@echo off
echo.
echo BUILDING LIBRARY "Green Sock Library"...

REM 0. Do a preflight check and see if the project needs to be built
SETLOCAL
FOR /F "tokens=* USEBACKQ" %%g IN (`d:\_DEV_\_BUILD_\NODE\win\node.exe d:\_DEV_\_GIT_\claudius-iacob-eu\SIRIUS\sirius.js d:\_DEV_\_GIT_\github\green-sock-library --dirty-check-only`) do (SET "PROJECT_STATE=%%g")
IF "%PROJECT_STATE%" == "clean" goto noactionexit
ENDLOCAL

REM 1. Update own configuration in order to include any last-minute class/dependency change:
if "%~1"=="--skip-own-update" goto deps
echo Updating library configuration...
d:\_DEV_\_BUILD_\NODE\win\node.exe d:\_DEV_\_GIT_\claudius-iacob-eu\SIRIUS\sirius.js d:\_DEV_\_GIT_\github\green-sock-library --cfg-only --silent

:deps
REM 2. Recursively update and build dependencies if any:
echo Updating and building dependencies of "Green Sock Library"...
echo No dependencies found.

REM 3. Build the current library:
echo Building...
SET javaDir=d:\_DEV_\_BUILD_\JAVA\win\openjdk-11.0.10\bin
SET sdkJarsDir=d:\_DEV_\_BUILD_\AIR_SDK\win\Flex_4.16.1_AIR_28.0\lib
SET frameworksDir=d:\_DEV_\_BUILD_\AIR_SDK\win\Flex_4.16.1_AIR_28.0\frameworks
%javaDir%\java -jar %sdkJarsDir%\compc.jar +flexlib %frameworksDir% -load-config d:\_DEV_\_GIT_\github\green-sock-library\.build-scripts\lib-config.xml
if errorlevel 1 goto buildfailed
if not errorlevel 1 goto cleanexit

:buildfailed
echo BUILDING LIBRARY "Green Sock Library" FAILED, EXITING.
exit /b %ERRORLEVEL%

:cleanexit
echo BUILDING LIBRARY "Green Sock Library" COMPLETE, EXITING.
exit /b %ERRORLEVEL%

:noactionexit
echo "Green Sock Library" ALREADY BUILT, EXITING.
exit /b %ERRORLEVEL%