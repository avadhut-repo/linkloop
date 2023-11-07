:: APEX Export to Git
::-----------------------------
:: %1 = APEX App Id
:: %2 = Git workarea directory
:: %3 = DB connection string
::-----------------------------
:: Recreate the temporary stage directory and change directory to it
::@echo off
::if exist %TEMP%\stage_f%1 rmdir /s /q %TEMP%\stage_f%1
::mkdir %TEMP%\stage_f%1
::cd %TEMP%\stage_f%1
cd C:\cicd_linkloop 
::SET %PATH%=C:\sqlcl\sqlcl\bin;%path%
echo %PATH%
:: Export APEX application and schema to stage directory
(
echo connect %3
echo apex export -applicationid %1 -split -skipExportDate -expOriginalIds -expSupportingObjects Y -expType APPLICATION_SOURCE,READABLE_YAML
echo set ddl storage off
echo set ddl partitioning off
echo set ddl segment_attributes off
echo set ddl tablespace off
echo set ddl emit_schema off
echo lb generate-schema -split
) | sql /nolog
:: Copy APEX application export files in the ./fNNN subdirectory to Git Working Area directory
robocopy "C:\cicd_linkloop" "%2" /mir
:: Remove APEX export files, leaving only Liquibase DB export artifacts
::rm -rf $C:\cicd_linkloop
:: Copy the Liquibase DB export artifacts to ./database subdir of Git Working Area
::robocopy "C:\cicd_linkloop" "%2" /MIR
:: Change directory to the Git Workarea 
cd %2
:: make this directory as Git Repository
git init
:: Add all changed files to the Git worklist from any subdirectory
git add .
