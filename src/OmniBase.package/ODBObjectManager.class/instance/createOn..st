public
createOn: anOmniBase 
	"Create new object manager."

	environment := anOmniBase.
	
	[(ODBFileStream directoryExists: self dirName) 
		ifFalse: [ODBFileStream directoryCreate: self dirName].
	idTable := ODBIDTable createOn: self idFileName.
	infoFile := ODBContainerInfoFile createOn: self infoFileName.
	self containerNew: 'Default'] 
			ifCurtailed: [self close]