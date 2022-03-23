Class {
	#name : #ODBWin32FileStream,
	#superclass : #ODBFileStream,
	#instVars : [
		'externalLong'
	],
	#category : #'OmniBase-Streams'
}

{ #category : #'instance creation' }
ODBWin32FileStream class >> createOn: pathName createMode: createMode accessMode: accessMode shareMode: shareMode cacheMode: cacheMode [
	"Private - Create new instance of file stream on pathName with given flags.
	This is Win32 API specific implementation."

	| crMode acMode shMode caMode |
	crMode := 0.
	createMode = #createModeCreateAlways ifTrue: [crMode := 2 "CREATE_ALWAYS"].
	createMode = #createModeCreateNew ifTrue: [crMode := 1 "CREATE_NEW"].
	createMode = #createModeOpenAlways ifTrue: [crMode := 4 "OPEN_ALWAYS"].
	createMode = #createModeOpenExisting ifTrue: [crMode := 3 "OPEN_EXISTING"].
	acMode := 0.
	accessMode = #accessModeReadOnly ifTrue: [acMode := 2147483648 "GENERIC_READ"].
	accessMode = #accessModeReadWrite ifTrue: [acMode := 3221225472 "GENERIC_READ | GENERIC_WRITE"].
	accessMode = #accessModeWriteOnly ifTrue: [acMode := 1073741824 "GENERIC_WRITE"].
	shMode := 0.
	shareMode = #shareModeShareAll ifTrue: [shMode := 3 "FILE_SHARE_READ | FILE_SHARE_WRITE"].
	shareMode = #shareModeShareNone ifTrue: [shMode := 0].
	shareMode = #shareModeShareRead ifTrue: [shMode := 1 "FILE_SHARE_READ"].
	caMode := 0.
	cacheMode = #cacheModeAtomicWrite ifTrue: [caMode := 512  "FILE_FLAG_ATOMIC_WRITE"].
	cacheMode = #cacheModeSequentialScan ifTrue: [caMode := 134217728 "FILE_FLAG_SEQUENTIAL_SCAN"].
	^self new createOn: pathName createMode: crMode accessMode: acMode shareMode: shMode cacheMode: caMode

]

{ #category : #public }
ODBWin32FileStream >> basicGetBytesFor: aByteCollection len: len [ 
	"Private - Read len bytes from stream to aByteCollection. 
	Answer number of bytes actualy read."

	| startTime currentTime errorCode |
	(self 
		readFile: stream
		lpBuffer: aByteCollection
		nNumberOfBytesToRead: len
		lpNumberOfBytesRead: externalLong
		lpOverlapped: nil) = 0
			ifTrue: 
				[currentTime := startTime := Time millisecondClockValue.
				
				[errorCode := self getLastError.
				errorCode = 33 or: [errorCode = 5	"access denied"]	"lock violation"] 
						whileTrue: 
							[currentTime - startTime < self maxMillisecondsOfTolerance 
								ifFalse: 
									[ODBStreamLockedNotification signal 
										ifTrue: [startTime := currentTime]
										ifFalse: [self fileIOError: errorCode]].
							(self 
								readFile: stream
								lpBuffer: aByteCollection
								nNumberOfBytesToRead: len
								lpNumberOfBytesRead: externalLong
								lpOverlapped: nil) = 0 ifFalse: [^externalLong odbLongAt: 1].
							currentTime := Time millisecondClockValue.
							currentTime < startTime ifTrue: [currentTime := currentTime + 86400000]].
				self fileIOError: errorCode].
	^externalLong odbLongAt: 1
]

{ #category : #private }
ODBWin32FileStream >> basicPosition: anInteger [ 
	"Private - Positiones stream to anInteger. Answer anInteger."

	| result |
	result := self 
				setFilePointer: stream
				lDistanceToMove: anInteger
				lpDistanceToMoveHigh: nil
				dwMoveMethod: 0. "FILE_BEGIN"
	^16rFFFFFFFF = result ifFalse: [result] ifTrue: [self fileIOError]
]

{ #category : #private }
ODBWin32FileStream >> basicPutBytesFrom: aByteCollection len: len [ 
	"Private - Write len bytes from aByteCollection to file."

	(self 
		writeFile: stream
		lpBuffer: aByteCollection asByteArray
		nNumberOfBytesToWrite: len
		lpNumberOfBytesWritten: externalLong
		lpOverlapped: nil) = 0 ifTrue: [self fileIOError]
]

{ #category : #public }
ODBWin32FileStream >> close [
	"Close file associatied with receiver."

	self closeHandle: stream.
	stream := nil.
]

{ #category : #'Win32 primitives' }
ODBWin32FileStream >> closeHandle: aHandle [
	"Close an open Win32 object handle, freeing any resources held by it.
	Once closed a handle is no longer valid. Answer whether the function
	succeeds.	 See Win32 SDK help for more information.

	BOOL CloseHandle(
		HANDLE  hObject 	// handle of object to close  
	);"

	"<apicall: ulong 'CloseHandle' (long) module:'kernel32.dll'>"
	^ self ffiCall: #(ulong CloseHandle(long aHandle))
]

{ #category : #'Win32 primitives' }
ODBWin32FileStream >> createFile: aStringFileName dwDesiredAccess: anIntegerAccessMode dwSharedMode: anIntegerShareMode 
		lpSecurityAttributes: aSECURITYATTRIBUTES dwCreationDistribution: anIntegerCreateMode 
		dwFlagsAndAttributes: anIntegerAttributeFlag hTemplateFile: aHandle [
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

	"<apicall: long 'CreateFileA' (char* ulong ulong void* ulong ulong long) module:'kernel32.dll'>"
	
	^ self ffiCall: #(long CreateFileA(
		char *aStringFileName, 
		ulong anIntegerAccessMode, 
		ulong anIntegerShareMode, 
		void* aSECURITYATTRIBUTES, 
		ulong anIntegerCreateMode, 
		ulong anIntegerAttributeFlag,
		long aHandle))
]

{ #category : #private }
ODBWin32FileStream >> createOn:  aPathname createMode: createMode accessMode: accessMode shareMode: shareMode cacheMode: cacheMode [ 
	| fd |
	2 timesRepeat: [(fd := self
				createFile: aPathname
				dwDesiredAccess: accessMode
				dwSharedMode: shareMode
				lpSecurityAttributes: nil
				dwCreationDistribution: createMode
				dwFlagsAndAttributes: (128 bitOr: cacheMode) "FILE_ATTRIBUTE_NORMAL | cacheMode"
				hTemplateFile: nil) = -1 "INVALID_HANDLE_VALUE "
		ifFalse: [^self openOn: aPathname fileHandle: fd].
	(Delay forMilliseconds: 500) wait.
	].
	self fileIOError
]

{ #category : #'library path' }
ODBWin32FileStream >> ffiLibraryName [
	^ 'kernel32.dll'
]

{ #category : #private }
ODBWin32FileStream >> fileIOError [
	self fileIOError: self getLastError
]

{ #category : #private }
ODBWin32FileStream >> fileIOError: errorCode [

	| description |
	description := '<no error description available>'.
	errorCode = 6 ifTrue: [description := 'Invalid handle'].
	errorCode = 183 ifTrue: [description := 'File already exists'].
	errorCode = 2 ifTrue: [description := 'File not found'].
	errorCode = 5 ifTrue: [description := 'Access denied'].
	errorCode = 80 ifTrue: [description := 'The file exists'].
	OmniBase signalError: 'File I/O error number ', errorCode printString, ' ', description
]

{ #category : #public }
ODBWin32FileStream >> flush [
	"Force all data written to the receiver to be recorded on disk."

	(self flushFileBuffers: stream) = 0 ifTrue: [self fileIOError]
]

{ #category : #'Win32 primitives' }
ODBWin32FileStream >> flushFileBuffers: aHandle [
	"The FlushFileBuffers function clears the buffers for the specified file
	and causes all buffered data to be written to the file. 
	Answer a boolean indicating if the operation was successful.

	BOOL FlushFileBuffers(
		HANDLE hFile // open handle to file whose buffers are to be flushed 
		);"

	"<apicall: ulong 'FlushFileBuffers' (long) module:'kernel32.dll'>"
	^ self ffiCall: #(ulong FlushFileBuffers(long aHandle))
]

{ #category : #'Win32 primitives' }
ODBWin32FileStream >> getFileSize: aHandle lpFileSizeHigh: aDWORD [
	"Answers the low-order dword of the size, in bytes, of the specified file. 

		DWORD GetFileSize(
			HANDLE hFile, // handle of file to get size of
			LPDWORD lpFileSizeHigh, // address of high-order word for file size if required.
		);"

	"<apicall: ulong 'GetFileSize' (long ulong) module:'kernel32.dll'>"
	^ self ffiCall: #(ulong GetFileSize (long aHandle, ulong aDWORD))
]

{ #category : #'Win32 primitives' }
ODBWin32FileStream >> getLastError [
	"Answer the last Win32 error code which occurred.
		DWORD GetLastError(VOID)"
  
	"<apicall: ulong 'GetLastError' () module:'kernel32.dll'>"
	^ self ffiCall: #(ulong GetLastError())
]

{ #category : #public }
ODBWin32FileStream >> lockAt: pos length: length [ 
	"Lock portion of file starting at position pos. 
	Answer <true> if successfull."

	| errorCode |
	(self 
		lockFile: stream
		offsetLow: pos
		offsetHigh: 0
		lengthLow: length
		lengthHigh: 0) = 0 ifFalse: [^true].
	"is lock violation ?"
	(errorCode := self getLastError) = 33 ifTrue: [^false].
	^self fileIOError: errorCode
]

{ #category : #'Win32 primitives' }
ODBWin32FileStream >> lockFile: aHandle
    offsetLow: loPos offsetHigh: hiPos
    lengthLow: loLength lengthHigh: hiLength [

	"<apicall: long 'LockFile' (long ulong ulong ulong ulong) module: 'kernel32.dll'>"
	^ self ffiCall: #(long LockFile(long aHandle, ulong loPos, ulong hiPos, ulong loLength, ulong hiLength))
]

{ #category : #public }
ODBWin32FileStream >> maxMillisecondsOfTolerance [ 
	
	^ 500  "let's see what happens with this"
	
	"^ 12  OmniBase default"
]

{ #category : #private }
ODBWin32FileStream >> openOn: aString fileHandle: win32Handle [
	"Private - Initialize receiver."

	pathName := aString.
	"To fix: on win stream is a handle"
	stream := win32Handle.
	mutex := Semaphore forMutualExclusion.
	externalLong := ByteArray new: 4.
]

{ #category : #public }
ODBWin32FileStream >> position [
	| pos |
	pos := self 
				setFilePointer: stream
				lDistanceToMove: 0
				lpDistanceToMoveHigh: nil
				dwMoveMethod: 1. "FILE_CURRENT"
	^16rFFFFFFFF = pos ifFalse: [pos] ifTrue: [self fileIOError]
]

{ #category : #'Win32 primitives' }
ODBWin32FileStream >> readFile: aHandle lpBuffer: anAddress nNumberOfBytesToRead: anIntegerBytesToRead
		lpNumberOfBytesRead: anAddressBytesRead lpOverlapped: anOVERLAPPED [
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

	"<apicall: long 'ReadFile' (long void* ulong void* void*) module:'kernel32.dll'>"
	^ self ffiCall: #(long ReadFile(
		long aHandle, 
		void *anAddress, 
		ulong anIntegerBytesToRead, 
		void *anAddressBytesRead, 
		void *anOVERLAPPED))
]

{ #category : #'Win32 primitives' }
ODBWin32FileStream >> setEndOfFile: aHandle [

	"<apicall: long 'SetEndOfFile' (long) module: 'kernel32.dll'>"
	^ self ffiCall: #(long SetEndOfFile (long aHandle))
]

{ #category : #'Win32 primitives' }
ODBWin32FileStream >> setFilePointer: aHandle lDistanceToMove: loInteger lpDistanceToMoveHigh: anAddress dwMoveMethod: senseOfMove [
	"Moves the file pointer of an open file. 

	DWORD SetFilePointer(
		HANDLE hFile, 				// handle of file 
		LONG lDistanceToMove, 		// number of bytes to move file pointer 
		PLONG lpDistanceToMoveHigh, // address of high-order word of distance to move  
		DWORD dwMoveMethod 			// how to move 
		);"

	"<apicall: ulong 'SetFilePointer' (long long void* ulong) module: 'kernel32.dll'>"
	^ self ffiCall: #(ulong SetFilePointer(long aHandle, long loInteger, void *anAddress, ulong senseOfMove))
]

{ #category : #public }
ODBWin32FileStream >> size [
	"Answer the size of the file in bytes or
	signal a FileException if the operation fails."

	| result |
	result := self getFileSize: stream lpFileSizeHigh: nil.
	^16rFFFFFFFF = result ifFalse: [result] ifTrue: [self fileIOError]
]

{ #category : #public }
ODBWin32FileStream >> truncate: anInteger [ 
	"Truncate stream so that its size will be anInteger. 
	Position to anInteger."

	mutex critical: 
			[self basicPosition: anInteger.
			(self setEndOfFile: stream) = 0 ifTrue: [self fileIOError]]
]

{ #category : #public }
ODBWin32FileStream >> unlockAt: pos length: length [ 
	"Unlock portion of file at position pos. 
	Answer <true> if successfull, <false> if failed."

	^(self
		unlockFile: stream
		offsetLow: pos
		offsetHigh: 0
		lengthLow: length
		lengthHigh: 0) ~= 0
]

{ #category : #'Win32 primitives' }
ODBWin32FileStream >> unlockFile: aHandle
    offsetLow: loPos offsetHigh: hiPos
    lengthLow: loLength lengthHigh: hiLength [

	"<apicall: long 'UnlockFile' (long ulong ulong ulong ulong) module: 'kernel32.dll'>"
	^ self ffiCall: #(long UnlockFile(long aHandle, ulong loPos, ulong hiPos, ulong loLength, ulong hiLength))
]

{ #category : #'Win32 primitives' }
ODBWin32FileStream >> writeFile: aHandle lpBuffer: anAddress nNumberOfBytesToWrite: anIntegerBytesToWrite 
		lpNumberOfBytesWritten: anAddressBytesWritten lpOverlapped: anOVERLAPPED [
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

	"<apicall: long 'WriteFile' (long void* ulong void* void*) module:'kernel32.dll'>"
	^ self ffiCall: #(long WriteFile(
		long aHandle, 
		void* anAddress, 
		ulong anIntegerBytesToWrite, 
		void *anAddressBytesWritten, 
		void *anOVERLAPPED))
]
