public
getLast
	nextKey := (ByteArray new: keyLength) atAllPut: 255.
	self updateCurrentKey.
	currentKeyExists ifTrue: [^self lastPage association].
	^self searchPreviousAssociation