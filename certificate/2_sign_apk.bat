@echo off
echo "用生成的key对APK签名"

set APK_NAME=shiershichen

set JAVA_HOME="C:\Program Files\Java\jdk1.8.0_341"
set BASEDIR="C:\Users\onsite-235\WeChatProjects"
set KEYSTORE="%BASEDIR%\%APK_NAME%\certificate\android.keystore"
set WORKDIR="%BASEDIR%\%APK_NAME%\release"


%JAVA_HOME%\bin\jarsigner.exe -verbose -keystore %KEYSTORE% -storepass 123456 -keypass 123456 -signedjar %WORKDIR%\%APK_NAME%-signed.apk %WORKDIR%\com.tencent.weauth-0.0.2.apk.aligned android

echo "Finish sign APK: %WORKDIR%\%APK_NAME%-signed.apk"

pause