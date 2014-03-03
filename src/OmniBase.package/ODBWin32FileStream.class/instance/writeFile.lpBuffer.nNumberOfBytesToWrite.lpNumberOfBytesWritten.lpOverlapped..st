Win32 primitives
writeFile: aHandle lpBuffer: anAddress nNumberOfBytesToWrite: anIntegerBytesToWrite 
		lpNumberOfBytesWritten: anAddressBytesWritten lpOverlapped: anOVERLAPPED
	"The WriteFile function writes data to a file and is designed for both synchronous and asynchronous operation.
	The function starts writing data to the file at the position indicated by the file pointer. After the write
	operation has been completed, the file pointer is adjusted by the number of bytes actually written, except when
	the file is opened with FILE_FLAG_OVERLAPPED. If the file handle was created for overlapped input and output
	(I/O), the application must adjust the position of the file pointer after the write operation is finished. 

	BOOL WriteFile(
		HANDLE hFile, // handle of file to write to 
		LPCVOID lpBuffer, // address of data to write to file 
		DWORD nNumberOfBytesToWrite, // number of bytes to write 
		LPDWORD lpNumberOfBytesWritten, // address of number of bytes written 
		LPOVERLAPPED lpOverlapped // addr. of structure needed for overlapped I/O  
		);

	Answer a boolean indicating whether the function succeeds."

	<apicall: long 'WriteFile' (long void* ulong void* void*) module:'kernel32.dll'>
	^self externalCallFailed