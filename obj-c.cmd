@SETLOCAL
@set "sh=C:\Program Files\Git\git-bash.exe"

@if not exist "%sh%" (
	echo failed to find gitbash
	echo trying MSVC instead....
    GOTO MSVC
)
@cd /d "%cd%"

@set "compile_objc=clang `gnustep-config --objc-flags` -c %*"
@"%sh%" -c "%compile_objc%"
@if %ERRORLEVEL% NEQ 0 (
	echo failed to build %* file
	exit /b 1
)

@set "link_files=clang `gnustep-config --base-libs` -ldispatch -o %~n1.exe %~n1.o"
@"%sh%" -c "%link_files%"
@if %ERRORLEVEL% NEQ 0 (
	echo linker error 
	exit /b 1
)

@if exist "%cd%\%~n1.exe" (
	echo Success!
	echo The File is : %~n1.exe
    exit /b 0
) else (
	echo failure 
    exit /b 1
)

:MSVC
@"clang-cl -I C:\GNUstep\x64\Release\include -fobjc-runtime=gnustep-2.0 -Xclang -fexceptions -Xclang -fobjc-exceptions -fblocks -DGNUSTEP -DGNUSTEP_WITH_DLL -DGNUSTEP_RUNTIME=1 -D_NONFRAGILE_ABI=1 -D_NATIVE_OBJC_EXCEPTIONS /MDd /Z7 /c %*"
@if %ERRORLEVEL% NEQ 0 (
    echo failed to create object files
    exit /b 1
)
@"clang-cl %~n1.obj gnustep-base.lib objc.lib dispatch.lib /MD /Z7 -o %~n1.exe /link /LIBPATH:C:\GNUstep\x64\Release\lib"
@if %ERRORLEVEL% NEQ 0 (
    echo linker failure
    exit /b 1
)
@ENDLOCAL

