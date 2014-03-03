public
close
	versionControl notNil 
		ifTrue: 
			[versionControl close.
			versionControl := nil].
	oldHolders notNil 
		ifTrue: 
			[oldHolders close.
			oldHolders := nil].
	dbConnection := nil