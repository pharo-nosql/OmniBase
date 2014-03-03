public
onlineBackup: anOmniBase to: newPath silent: silentBool 
	newDb := OmniBase createOn: newPath.
	
	[newDb objectManager reopenExclusively.
	db := anOmniBase.
	oldHolders := db transactionManager oldHolders.
	versionDescriptor := db transactionManager versionControl versionDescriptor copy.
	newVersionNumber := newDb transactionManager versionControl 
				getNewVersionNumberFor: newDb localClient clientID.
	newDb transactionManager versionControl removeCommittingFor: newDb localClient clientID.
	self copyDatabase: silentBool] 
			ensure: [newDb close]