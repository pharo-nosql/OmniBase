Win32 primitives
flushFileBuffers: aHandle
	"The FlushFileBuffers function clears the buffers for the specified file
	and causes all buffered data to be written to the file. 
	Answer a boolean indicating if the operation was successful.

	BOOL FlushFileBuffers(
		HANDLE hFile // open handle to file whose buffers are to be flushed 
		);"

	<apicall: ulong 'FlushFileBuffers' (long) module:'kernel32.dll'>
	^self externalCallFailed