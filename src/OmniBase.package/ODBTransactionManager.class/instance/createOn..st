public
createOn: aDatabase 
	self initializeOn: aDatabase.
	
	[versionControl := ODBVersionControlFile createOn: self vcFileName.
	oldHolders := ODBOldHoldersFile createOn: self oldHoldersFileName.
	self initializeReferences] 
			ifCurtailed: [self close]