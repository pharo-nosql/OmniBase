locking
lockAt: pos length: length pathName: pathName fileHandle: fileHandle seekingMutex: seekingMutex position: position
		"Lock portion of file starting at position pos.
		Answer <true> if successfull, <false> otherwise."

	| result lockInterval fileLocks |
	lockInterval := 0 @ pos extent: 1 @ length.
	seekingMutex critical: [
	self lockingMutex critical: [
	(fileLocks := locks at: pathName ifAbsent: []) isNil
		ifFalse: [fileLocks do: [:each | (each first intersects: lockInterval) ifTrue: [^false]]].
	result := true.
	[ fileHandle position: pos; lock: true for: length ]
		on: Error
		do: [ :error | result := false ].
	result
		ifTrue: [
			fileLocks isNil ifTrue: [locks at: pathName put: (fileLocks := OrderedCollection new)].
			fileLocks add: (Array with: lockInterval with: fileHandle) ].
	fileHandle position: position.
	]].
	^result