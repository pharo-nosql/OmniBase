public
lockAt: pos length: length 
	"Lock portion of file starting at position pos. 
	Answer <true> if successfull."

	| errorCode |
	(self 
		lockFile: fileHandle
		offsetLow: pos
		offsetHigh: 0
		lengthLow: length
		lengthHigh: 0) = 0 ifFalse: [^true].
	"is lock violation ?"
	(errorCode := self getLastError) = 33 ifTrue: [^false].
	^self fileIOError: errorCode