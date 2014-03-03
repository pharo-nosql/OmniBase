Win32 primitives
unlockFile: aHandle
    offsetLow: loPos offsetHigh: hiPos
    lengthLow: loLength lengthHigh: hiLength

	<apicall: long 'UnlockFile' (long ulong ulong ulong ulong) module: 'kernel32.dll'>
	^self externalCallFailed