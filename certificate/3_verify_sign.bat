@echo off
echo "验证APK签名"

set APK_NAME=shiershichen

set JAVA_HOME="C:\Program Files\Java\jdk1.8.0_341"
set BASEDIR="C:\Users\onsite-235\WeChatProjects"
set KEYSTORE="%BASEDIR%\%APK_NAME%\certificate\android.keystore"
set WORKDIR="%BASEDIR%\%APK_NAME%\release"


REM 验证签名
%JAVA_HOME%\bin\jarsigner.exe -verify -verbose -certs %WORKDIR%\%APK_NAME%-signed.apk

pause