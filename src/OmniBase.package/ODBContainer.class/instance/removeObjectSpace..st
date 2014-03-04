private
removeObjectSpace: anInteger 

	(self convertToLocalObjectSpaceNumber: anInteger) = 0 
		ifTrue: 
			[dataFileA isNil 
				ifFalse: 
					[activeDataFile == dataFileA ifTrue: [activeDataFile := dataFileB].
					dataFileA
						unlockAdding;
						removeAll;
						remove.
					dataFileA := nil]]
		ifFalse: 
			[dataFileB isNil 
				ifFalse: 
					[activeDataFile == dataFileB ifTrue: [activeDataFile := dataFileA].
					dataFileB
						unlockAdding;
						removeAll;
						remove.
					dataFileB := nil]]