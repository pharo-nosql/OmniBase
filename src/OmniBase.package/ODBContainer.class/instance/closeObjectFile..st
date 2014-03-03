public
closeObjectFile: anInteger 
	"Remove database object file number anInteger from 
        dictionary of opened files and close it."

	| file |
	dbFilesMutex critical: 
			[file := dbFiles at: anInteger ifAbsent: [^self].
			dbFiles removeKey: anInteger.
			file
				close]