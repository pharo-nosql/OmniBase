public
createOn: anOmniBase 
	mutex := Semaphore forMutualExclusion.
	
	[infoFile := ODBClassInfoFile createOn: anOmniBase dirName , self infoFileName.
	idTable := ODBIDTable createOn: anOmniBase dirName , self idFileName] 
			ifCurtailed: [self close]