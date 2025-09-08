@echo off
echo "生成APK发布用的签名key"

set ALIAS=android

set APK_NAME=shiershichen

set JAVA_HOME="C:\Program Files\Java\jdk1.8.0_341"
set BASEDIR="C:\Users\onsite-235\WeChatProjects"
set KEYSTORE="%BASEDIR%\%APK_NAME%\certificate\android.keystore"
::set WORKDIR="%BASEDIR%\%APK_NAME%\release"


%JAVA_HOME%\bin\keytool.exe -genkey -alias %ALIAS% -keyalg RSA -keysize 2048 -validity 36500 -keystore %KEYSTORE%
pause




