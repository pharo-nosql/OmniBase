public
openOn: anOmniBase 
	"Open receiver. Signal an error if failed."

	mutex := Semaphore forMutualExclusion.
	
	[idTable := ODBIDTable openOn: anOmniBase dirName , self idFileName.
	infoFile := ODBClassInfoFile openOn: anOmniBase dirName , self infoFileName] 
			ifCurtailed: [self close]