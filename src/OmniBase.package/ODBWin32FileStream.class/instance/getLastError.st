Win32 primitives
getLastError
	"Answer the last Win32 error code which occurred.
		DWORD GetLastError(VOID)"
  
	<apicall: ulong 'GetLastError' () module:'kernel32.dll'>
	^self externalCallFailed