locking
releaseAllLocksFor: pathName fileHandle: fileHandle

	| newFileLocks fileLocks |
	self lockingMutex critical: [
	fileLocks := locks at: pathName ifAbsent: [^self].
	newFileLocks := OrderedCollection new.
	fileLocks do: [:each |
		each last == fileHandle
			ifFalse: [newFileLocks add: each]
			ifTrue: [
				[ fileHandle position: each first top; lock: false for: each first height ]
					on: Error
					do: [ :error | ]]].
	newFileLocks isEmpty
		ifTrue: [locks removeKey: pathName]
		ifFalse: [locks at: pathName put: newFileLocks].
	].