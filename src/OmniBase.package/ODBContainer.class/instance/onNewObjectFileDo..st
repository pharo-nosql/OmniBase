public
onNewObjectFileDo: aBlock 
	| file newIndex |
	dbFilesMutex critical: 
			[newIndex := indexFile newObjectFileID.
			file := aBlock value: newIndex value: (self fileNameFromIndex: newIndex).
			file notNil 
				ifTrue: 
					[dbFiles at: newIndex put: file]].
	^file