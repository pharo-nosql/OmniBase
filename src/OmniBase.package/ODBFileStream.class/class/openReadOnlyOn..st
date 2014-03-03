create/open
openReadOnlyOn: pathName 
	"Open an existing file on pathName. Trigger an 
        exception if the file can not be opened."

	^self 
		createOn: pathName
		createMode: self createModeOpenExisting
		accessMode: self accessModeReadOnly
		shareMode: self shareModeShareAll