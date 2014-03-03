Win32 primitives
createFile: aStringFileName dwDesiredAccess: anIntegerAccessMode dwSharedMode: anIntegerShareMode 
		lpSecurityAttributes: aSECURITYATTRIBUTES dwCreationDistribution: anIntegerCreateMode 
		dwFlagsAndAttributes: anIntegerAttributeFlag hTemplateFile: aHandle
	"The CreateFile function creates, opens, or truncates a file, pipe, communications resource, disk device,
	or console. Answer a handle that can be used to access the object. It can also open and return a handle to a directory.

	HANDLE CreateFile(
		LPCTSTR lpFileName, // address of name of the file 
		DWORD dwDesiredAccess, // access (read-write) mode 
		DWORD dwShareMode, // share mode 
		LPSECURITY_ATTRIBUTES lpSecurityAttributes, // address of security descriptor 
		DWORD dwCreationDistribution, // how to create 
		DWORD dwFlagsAndAttributes, // file attributes 
		HANDLE hTemplateFile // handle of file with attributes to copy  
	);
	Please see Win32 SDK help for more information."

	<apicall: long 'CreateFileA' (char* ulong ulong void* ulong ulong long) module:'kernel32.dll'>
	^self externalCallFailed