@echo off
setlocal enabledelayedexpansion

:: ===== 安全配置 =====
set "APK_NAME=shiershichen"
set "BASEDIR=C:\Users\onsite-235\WeChatProjects"
set "WORKDIR=%BASEDIR%\%APK_NAME%\release"
set "README_FILE=%BASEDIR%\%APK_NAME%\certificate\README.md"
set "PRE_APK=%WORKDIR%\com.tencent.weauth-0.0.2.apk.aligned"

:: ===== 初始化检查 =====
echo [INIT] 验证工作目录...
if not exist "%PRE_APK%" (
   echo [ERROR] 未找到APK文件: %PRE_APK%
   pause
   exit /b 1
)

if not exist "%README_FILE%" (
   echo [ERROR] 缺少README.md: %README_FILE%
   echo [SOLUTION] 正在自动创建...
   mkdir "%BASEDIR%\%APK_NAME%\certificate" 2>nul
   echo "# 签名证书说明文件" > "%README_FILE%"
)

:: ===== 主流程 =====
echo [PROCESS] 开始处理APK...

:: 1. 解压APK
set "TMP_DIR=%WORKDIR%\temp_%random%"
7z x "%PRE_APK%" -o"%TMP_DIR%" -y || (
   echo [ERROR] APK解压失败
   goto cleanup
)

:: 2. 嵌入README.md
mkdir "%TMP_DIR%\assets\SaaA_embed" 2>nul
copy /y "%README_FILE%" "%TMP_DIR%\assets\SaaA_embed\" || (
   echo [ERROR] 文件复制失败
   goto cleanup
)

:: 3. 重新压缩（修复版）
set "REPACK_APK=%WORKDIR%\repacked_%random%.apk"
cd /d "%TMP_DIR%"
7z a -tzip "%REPACK_APK%" "*" -r || (
   echo [ERROR] 重新压缩失败
   cd /d %~dp0
   goto cleanup
)
cd /d %~dp0

:: 4. 签名验证
jarsigner -verify "%REPACK_APK%"
if errorlevel 1 (
   echo [ACTION] 需要重新签名...
   jarsigner -verbose -sigalg SHA1withRSA -keystore "%BASEDIR%\%APK_NAME%\certificate\debug.keystore" -storepass android -keypass android "%REPACK_APK%" androiddebugkey
)

:: 5. 替换原文件
move /y "%REPACK_APK%" "%PRE_APK%" || (
   echo [ERROR] 文件替换失败
   goto cleanup
)

echo [SUCCESS] 处理完成!
pause
exit /b 0

:cleanup
if exist "%TMP_DIR%" rmdir /s /q "%TMP_DIR%"
if exist "%REPACK_APK%" del "%REPACK_APK%"
pause