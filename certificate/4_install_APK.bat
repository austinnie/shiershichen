@echo off
echo "安装apk"

set APK_NAME=shiershichen

set JAVA_HOME="C:\Program Files\Java\jdk1.8.0_341"
set BASEDIR="C:\Users\onsite-235\WeChatProjects"
set KEYSTORE="%BASEDIR%\%APK_NAME%\certificate\android.keystore"
set WORKDIR="%BASEDIR%\%APK_NAME%\release"

adb uninstall com.tencent.weauth
adb install -r -t %WORKDIR%\%APK_NAME%-signed.apk

pause