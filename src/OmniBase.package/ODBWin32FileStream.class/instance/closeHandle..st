Win32 primitives
closeHandle: aHandle
	"Close an open Win32 object handle, freeing any resources held by it.
	Once closed a handle is no longer valid. Answer whether the function
	succeeds.	 See Win32 SDK help for more information.

	BOOL CloseHandle(
		HANDLE  hObject 	// handle of object to close  
	);"

	<apicall: ulong 'CloseHandle' (long) module:'kernel32.dll'>
	^self externalCallFailed