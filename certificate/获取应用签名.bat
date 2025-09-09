@echo off
chcp 65001 > nul  :: 强制切换为UTF-8编码
set JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8  :: 确保Java工具使用UTF-8
echo 正在获取Android应用签名...

set ALIAS=android
set APK_NAME=shiershichen
set STORE_PASS=123456
set KEY_PASS=123456

set "JAVA_HOME=C:\Program Files\Java\jdk1.8.0_341"
set "BASEDIR=C:\Users\onsite-235\WeChatProjects"
set "KEYSTORE=%BASEDIR%\%APK_NAME%\certificate\android.keystore"

:: 生成签名文件（如果不存在）
if not exist "%KEYSTORE%" (
    echo 正在生成新的签名文件...
    "%JAVA_HOME%\bin\keytool.exe" -genkey -v ^
        -alias %ALIAS% ^
        -keyalg RSA -keysize 2048 ^
        -validity 36500 ^
        -keystore "%KEYSTORE%" ^
        -storepass %STORE_PASS% ^
        -keypass %KEY_PASS% ^
        -dname "CN=Unknown, OU=Unknown, O=Unknown, L=Unknown, ST=Unknown, C=CN"
)

"C:\Program Files (x86)\360\360Safe\mobilemgr\tool\aapt.exe" dump badging "C:\Users\onsite-235\WeChatProjects\shiershichen\release\shiershichen-signed.apk" | findstr "package: name"
"C:\Program Files\Java\jdk1.8.0_341\bin\keytool.exe" -printcert -jarfile "C:\Users\onsite-235\WeChatProjects\shiershichen\release\shiershichen-signed.apk" -J-Duser.language=en
::"%JAVA_HOME%\bin\keytool.exe" -printcert -jarfile C:\Users\onsite-235\WeChatProjects\shiershichen\release\shiershichen-signed.apk

:: 获取签名信息
echo 正在提取签名信息...
"%JAVA_HOME%\bin\keytool.exe" -list -v -J-Duser.language=en ^
    -keystore "%KEYSTORE%" -alias %ALIAS% ^
    -storepass %STORE_PASS% -keypass %KEY_PASS%

pause