Win32 primitives
readFile: aHandle lpBuffer: anAddress nNumberOfBytesToRead: anIntegerBytesToRead
		lpNumberOfBytesRead: anAddressBytesRead lpOverlapped: anOVERLAPPED
	"The ReadFile function reads data from a file, starting at the position indicated by the file pointer.
	After the read operation has been completed, the file pointer is adjusted by the number of bytes actually read,
	unless the file handle is created with the overlapped attribute. If the file handle is created for overlapped
	input and output (I/O), the application must adjust the position of the file pointer after the read operation. 

	BOOL ReadFile(
		HANDLE hFile, // handle of file to read 
		LPVOID lpBuffer, // address of buffer that receives data  
		DWORD nNumberOfBytesToRead, // number of bytes to read 
		LPDWORD lpNumberOfBytesRead, // address of number of bytes read 
		LPOVERLAPPED lpOverlapped // address of structure for data 
		);

	Answer a boolean indicating whether the function succeeds. If successful and bytesRead is left set to zero,
	the file pointer was beyond the current end of the file at the time of the read operation."

	<apicall: long 'ReadFile' (long void* ulong void* void*) module:'kernel32.dll'>
	^self externalCallFailed