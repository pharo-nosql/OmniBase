directory operations
directoryCreate: aPath

	aPath asFileReference ensureCreateDirectory.
	
	^true