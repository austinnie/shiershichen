@echo off
set APK_NAME=shiershichen

set JAVA_HOME="C:\Program Files\Java\jdk1.8.0_341"
set BASEDIR="C:\Users\onsite-235\WeChatProjects"
set KEYSTORE="%BASEDIR%\%APK_NAME%\certificate\android.keystore"
set WORKDIR="%BASEDIR%\%APK_NAME%\release"

mv %WORKDIR%\com.tencent.weauth-0.0.1.apk.aligned %WORKDIR%%APK_NAME%-unsigned.apk

:: 1. 签名
%JAVA_HOME%\bin\jarsigner -verbose -keystore %KEYSTORE% -storepass 123456 -keypass 123456 -signedjar %WORKDIR%\%APK_NAME%-signed.apk %WORKDIR%\%APK_NAME%-unsigned.apk android

:: 2. 验证
%JAVA_HOME%\bin\jarsigner -verify -verbose %WORKDIR%\%APK_NAME%-signed.apk

:: 3. 安装
adb install %WORKDIR%\%APK_NAME%-signed.apk