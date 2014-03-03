Win32 primitives
getFileSize: aHandle lpFileSizeHigh: aDWORD
	"Answers the low-order dword of the size, in bytes, of the specified file. 

		DWORD GetFileSize(
			HANDLE hFile, // handle of file to get size of
			LPDWORD lpFileSizeHigh, // address of high-order word for file size if required.
		);"

	<apicall: ulong 'GetFileSize' (long ulong) module:'kernel32.dll'>
	^self externalCallFailed
