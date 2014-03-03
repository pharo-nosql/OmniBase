public
close
		"Close file associatied with receiver."

	fileHandle notNil ifTrue: [
		self class releaseAllLocksFor: pathName fileHandle: fileHandle.
		fileHandle closed ifFalse: [fileHandle close]].
	fileHandle := nil.