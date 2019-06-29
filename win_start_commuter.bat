:: Auxiliary script to start commuter server 
:: To install the server, check the following repositoy: https://github.com/nteract/commuter 
:: (You may need yarn to install commuter: conda install -c conda-forge yarn )

@set COMMUTER_HOME=C:\Users\jfdol\AppData\Local\Yarn\bin
@set COMMUTER_STORAGE_BACKEND=local 
@set COMMUTER_DISCOVERY_BACKEND="none"
@set COMMUTER_PORT=8000
@set COMMUTER_LOCAL_STORAGE_BASEDIRECTORY=G:\Google Drive\PersonalRep\ProjetoFinal\Workspace
@set COMMUTER_ES_HOST=""
C:
cd %COMMUTER_HOME%
start /B commuter server 