Win32 primitives
setEndOfFile: aHandle

	<apicall: long 'SetEndOfFile' (long) module: 'kernel32.dll'>
	^self externalCallFailed