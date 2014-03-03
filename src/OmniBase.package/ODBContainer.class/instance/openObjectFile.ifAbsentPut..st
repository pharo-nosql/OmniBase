public
openObjectFile: index ifAbsentPut: aBlock 
	| file |
	dbFilesMutex critical: 
			[((file := dbFiles at: index) isNil or: [file stream isNil]) 
				ifTrue: 
					[file := aBlock value: (self fileNameFromIndex: index).
					dbFiles at: index put: file]].
	^file