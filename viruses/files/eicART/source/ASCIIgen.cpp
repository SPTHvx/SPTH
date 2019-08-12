#include <cstdlib>
#include <iostream>
#include <fstream>
#include <string>


using namespace std;

class information
{
  public:
         int typ;
         // typ=0: IsPartOf(c)==TRUE
         // typ=1: c=n-p
         // typ=2: c=n-p-p
         
         unsigned char n;
         unsigned char q;

  information()
  {
    typ=3; n=0; q=0;
  }
};

bool IsPartOf(unsigned char x)
{
  bool res=false;
  if (x>=33 && x<=126) { res=true; }
  return(res);
}

information MakeSpecialKey(unsigned char c)
{
// Returns n=0 || n>=33 && n<=126
// If n=0: The given integer c is already n>=33 && n<=126
// Else: c=n-q, with n and q part of printable ASCIIs
  information data;
  unsigned char n=0;
  unsigned char q, dif, m, p;
  if (IsPartOf(c))
  {
    data.typ=0;
  }
  else
  {
    n=33;
    q=33;
    m=33;
    p=33;    
    dif=n-q;
    while(dif!=c)
    {
      if (n==126 && q==126)
      {
        // Double Subtraction

        if (m==126 && p==126) { cout << "Strange number: " <<(int)c << endl; system("PAUSE"); }
        if (m==126 && p<126) { m=32; p++; dif=m-p-p; }
        if (m<126) { m++; dif=m-p-p; }
      }
      if (n==126 && q<126) { n=32; q++; dif=n-q;}
      if (n<126) { n++; dif=n-q;}
//      if (q==92) { cout << (int)n << "-" << (int)q << "=" << (unsigned char)n-q << "!=" << (int)c << endl; system("PAUSE"); }

    }
  
    if (n==126 && q==126)
    {
      data.typ=2;
      data.n=m;
      data.q=p;
    }
    else
    { 
      data.typ=1;
      data.n=n;
      data.q=q;
    }
  }
  return(data);
}

int main(int argc, char *argv[])
{
  
    unsigned char c;
    string EncData;
    information msk;
    int OutSize;
    ofstream OutFile, EncD;
    EncD.open("EncData.inc");
    OutFile.open("eicART.asm");
    ifstream FileSize("c.bin",ios::binary);
    if (!FileSize.is_open())
    {
      cout << "File open error!" << endl;
      system("PAUSE");      
      return(-1);
    }

    OutSize=10;               // Start of Decryptor

    c=FileSize.get();    
    while(!FileSize.eof())
    {
      msk=MakeSpecialKey(c);
      if (msk.typ==0) { OutSize++; }
      if (msk.typ==1) { OutSize+=10; }   
      if (msk.typ==2) { OutSize+=12; }
      c=FileSize.get();      
    }
        
    FileSize.close();
    
    ifstream InFile("c.bin",ios::binary);
    OutFile << "org 0x100" << endl << hex; 
    OutFile << "start:" << endl << endl;
    OutFile << "pop       ax                ; AX=0x0000" << endl;
    OutFile << "push      ax                ; Stack: 0x0000" << endl;
    OutFile << "; You have to change AX to eicART+0x100 within exactly (!) 4 byte" << endl;
    OutFile << "; Use XOR, AND, SUB, INC, DEC for example" << endl;
    OutFile << "push      ax                ; Stack: 0x0000 0x0200" << endl;
    OutFile << "pop       bx                ; BX=0x0200; Stack: 0x0000;" << endl << endl;

    c=InFile.get();    
    while(!InFile.eof())
    {
      msk=MakeSpecialKey(c);
      if (msk.typ==0)
      {
        OutFile << "inc       bx" << endl;
        
        EncD << "db " << (int)c << "d" << endl;
      }
      if (msk.typ==1)
      {
      // c=n-q
        int rnd=rand() % 94 + 33;
        OutFile << "pop       ax                ; AX=0000; Stack: [EMPTY]" << endl;
        OutFile << "push      ax                ; Stack: 0x0000" << endl;
        OutFile << "xor       ax, 0x" << (int)msk.q << rnd << "        ; AX=0x" << (int)msk.q << rnd << endl;
        OutFile << "push      ax                ; Stack: 0x0000 0x" << (int)msk.q << rnd << endl;
        OutFile << "pop       cx                ; CX=0x" << (int)msk.q << rnd <<"; Stack: 0x0000" << endl;
        OutFile << "sub       byte [bx], ch     ; 0x" << (int)msk.n << "-0x" << (int)msk.q << "=" << (int)c << endl;
        OutFile << "inc       bx" << endl << endl;
        
        EncD << "db " << (int)msk.n << "d" << endl;
      }
      if (msk.typ==2)
      {
      // c=n-q-q
        int rnd=rand() % 94 + 33;      
        OutFile << "pop       ax                ; AX=0000; Stack: [EMPTY]" << endl;
        OutFile << "push      ax                ; Stack: 0x0000" << endl;
        OutFile << "xor       ax, 0x" << (int)msk.q << rnd << "        ; AX=0x" << (int)msk.q << rnd << endl;
        OutFile << "push      ax                ; Stack: 0x0000 0x" << (int)msk.q <<  rnd << endl;
        OutFile << "pop       cx                ; CX=0x" << (int)msk.q <<  rnd << "; Stack: 0x0000" << endl;
        OutFile << "sub       byte [bx], ch"  << endl;
        OutFile << "sub       byte [bx], ch     ; [BX]=" << (int)c << endl;
        OutFile << "inc       bx" << endl << endl;
        
        EncD << "db " << (int)msk.n << "d" << endl;        
      }
      c=InFile.get();
    }
    
    cout << OutSize << endl;
    OutFile << endl << "; " << dec << OutSize << " Byte" << endl;
    OutFile << endl << "eicART:" << endl;
    OutFile << endl << "include 'EncData.inc'" << endl;

    OutFile.close();
    EncD.close();
    InFile.close();
    
    system("PAUSE");
    return EXIT_SUCCESS;

}

