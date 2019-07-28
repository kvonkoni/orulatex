@ECHO OFF

if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit)

initexmf --admin --verbose --set-config-value [MPM]AutoInstall=1

PAUSE