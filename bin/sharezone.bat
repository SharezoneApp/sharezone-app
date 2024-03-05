@echo off

:: From: https://stackoverflow.com/a/3827582
SET directory_of_this_script=%~dp0
SET directory_of_this_script=%directory_of_this_script:~0,-1%

fvm dart run %directory_of_this_script%\..\tools\sz_repo_cli\bin\sz_repo_cli.dart %*