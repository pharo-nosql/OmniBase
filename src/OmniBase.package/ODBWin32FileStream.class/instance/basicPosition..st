private
basicPosition: anInteger 
	"Private - Positiones stream to anInteger. Answer anInteger."

	| result |
	result := self 
				setFilePointer: fileHandle
				lDistanceToMove: anInteger
				lpDistanceToMoveHigh: nil
				dwMoveMethod: 0. "FILE_BEGIN"
	^16rFFFFFFFF = result ifFalse: [result] ifTrue: [self fileIOError]