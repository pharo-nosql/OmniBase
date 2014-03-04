*omnibasePatch
createOn: pathName createMode: createMode accessMode: accessMode shareMode: shareMode cacheMode: cacheMode
		"Create new instance of file stream on pathName with given flags."

	| fileStreamClass |
	fileStreamClass := Smalltalk os platformName
			caseOf: 
				{
				['unix'] -> [ODBUnixFileStream].
				['Mac OS'] -> [ODBMacFileStream].
				['Win32'] -> [ODBWin32FileStream].
				}
			otherwise: 
				[self notify: 'File sharing & locking not implemented for this platform'.
				^ self 
					createWithoutSharingAndLockingOn: pathName 
					accessMode: accessMode].
			
	^ fileStreamClass
		createOn: pathName 
		createMode: createMode 
		accessMode: accessMode 
		shareMode: shareMode 
		cacheMode: cacheMode