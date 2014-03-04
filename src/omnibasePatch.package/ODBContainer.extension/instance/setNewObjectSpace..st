*omnibasePatch
setNewObjectSpace: newSpace 
	| currentSpace newLocalSpace |

	newLocalSpace := self convertToLocalObjectSpaceNumber: newSpace.
	currentSpace := activeDataFile == dataFileA ifTrue: [0] ifFalse: [1].
	currentSpace = newLocalSpace ifTrue: [^self].
	newLocalSpace = 0 
		ifTrue: 
			[dataFileA isNil ifTrue: [dataFileA := ODBObjectStorage openOn: self dataFileNameA].
			activeDataFile := dataFileA]
		ifFalse: 
			[dataFileB isNil ifTrue: [dataFileB := ODBObjectStorage openOn: self dataFileNameB].
			activeDataFile := dataFileB]