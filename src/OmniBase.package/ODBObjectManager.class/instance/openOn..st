public
openOn: anOmniBase 
	"Open receiver. Trigger an exception if failed."

	environment := anOmniBase.
	
	[idTable := ODBIDTable openOn: self idFileName.
	infoFile := ODBContainerInfoFile openOn: self infoFileName] 
			ifCurtailed: [self close]