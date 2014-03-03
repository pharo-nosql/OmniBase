create/open
openExclusivelyOn: pathName
		"Open an existing file on pathName exclusively so that no-one else can open it.
		Trigger an exception if the file can not be opened."

	^self createOn: pathName
		createMode: self createModeOpenExisting
		accessMode: self accessModeReadWrite
		shareMode: self shareModeShareNone