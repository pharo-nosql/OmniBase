public
position
	| pos |
	pos := self 
				setFilePointer: fileHandle
				lDistanceToMove: 0
				lpDistanceToMoveHigh: nil
				dwMoveMethod: 1. "FILE_CURRENT"
	^16rFFFFFFFF = pos ifFalse: [pos] ifTrue: [self fileIOError]