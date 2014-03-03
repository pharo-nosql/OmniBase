locking
unlockAt: pos length: length pathName: pathName fileHandle: fileHandle seekingMutex: seekingMutex position: position
		"Unlock portion of file at position pos. 
		Answer <true> if successfull, <false> if failed."

	| result lockInterval newFileLocks fileLocks |
	seekingMutex critical: [
	self lockingMutex critical: [
	(fileLocks := locks at: pathName ifAbsent: []) isNil ifTrue: [^false].
	lockInterval := 0 @ pos extent: 1 @ length.
	newFileLocks := OrderedCollection new.
	fileLocks do: [:each |
		((each first intersects: lockInterval) and: [each last == fileHandle])
			ifFalse: [newFileLocks add: each]
			ifTrue: [each first = lockInterval ifFalse: [self error: 'Partial unlock is not allowed']]].
	newFileLocks isEmpty
		ifTrue: [locks removeKey: pathName]
		ifFalse: [locks at: pathName put: newFileLocks].
	result := true.
	[ fileHandle position: pos; lock: false for: length ]
		on: Error
		do: [ :error | result := false ].
	fileHandle position: position.
	]].
	^result