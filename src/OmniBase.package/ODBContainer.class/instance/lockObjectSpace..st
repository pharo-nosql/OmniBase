public
lockObjectSpace: anInteger 
	anInteger = 0 ifTrue: [dataFileA waitForAddingLock] ifFalse: [dataFileB waitForAddingLock]