public
lockWith: lockID 
	| indexFile |
	oldVersion ifTrue: [^false].
	indexFile := container indexFile.
	
	[(indexFile
		lock: objectID index;
		at: objectID index) = contents 
		ifTrue: [^indexFile stream lockAt: self lockStartPosition + objectID index length: 1].
	oldVersion := true] 
			ensure: [container indexFile unlock: objectID index].
	^false