*omnibasePatch
removeObjectFile: anInteger 
	| file |
	dbFilesMutex critical: 
			[file := dbFiles at: anInteger ifAbsent: [^self].
			dbFiles removeKey: anInteger.
			file ifNotNil:[
				file close].
			ODBFileStream remove: (self fileNameFromIndex: anInteger)]