public
getSizeAt: versionDescriptor oldHolders: oldHolders 
	| sizeHolder |
	sizeHolder := (ODBSizeHolder new)
				loadFromStream: stream at: self headerLength;
				yourself.
	[versionDescriptor versionAtStartOK: sizeHolder versionNumber] 
		whileFalse: [sizeHolder loadPreviousVersionFrom: oldHolders].
	^sizeHolder dictionarySize