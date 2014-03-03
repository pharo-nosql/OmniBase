public
openOn: anOmniBase 
	self initializeOn: anOmniBase.
	
	[versionControl := ODBVersionControlFile openOn: self vcFileName.
	[oldHolders := ODBOldHoldersFile openOn: self oldHoldersFileName] on: Error
		do: [:er | oldHolders := ODBOldHoldersFile createOn: self oldHoldersFileName].
	self initializeReferences] 
			ifCurtailed: [self close]