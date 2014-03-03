create/open
createOn: pathName createMode: createMode accessMode: accessMode shareMode: shareMode
		"Create new instance of file stream on pathName with given flags."

	^self createOn: pathName
		createMode: createMode
		accessMode: accessMode
		shareMode: shareMode
		cacheMode: nil