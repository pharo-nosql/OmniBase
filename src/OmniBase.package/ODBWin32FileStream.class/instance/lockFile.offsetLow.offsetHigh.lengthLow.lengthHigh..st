Win32 primitives
lockFile: aHandle
    offsetLow: loPos offsetHigh: hiPos
    lengthLow: loLength lengthHigh: hiLength

	<apicall: long 'LockFile' (long ulong ulong ulong ulong) module: 'kernel32.dll'>
	^self externalCallFailed