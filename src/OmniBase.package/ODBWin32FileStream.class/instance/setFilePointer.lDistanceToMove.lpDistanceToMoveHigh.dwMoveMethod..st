Win32 primitives
setFilePointer: aHandle lDistanceToMove: loInteger lpDistanceToMoveHigh: anAddress dwMoveMethod: senseOfMove
	"Moves the file pointer of an open file. 

	DWORD SetFilePointer(
		HANDLE hFile, 				// handle of file 
		LONG lDistanceToMove, 		// number of bytes to move file pointer 
		PLONG lpDistanceToMoveHigh, // address of high-order word of distance to move  
		DWORD dwMoveMethod 			// how to move 
		);"

	<apicall: ulong 'SetFilePointer' (long long void* ulong) module: 'kernel32.dll'>
	^self externalCallFailed