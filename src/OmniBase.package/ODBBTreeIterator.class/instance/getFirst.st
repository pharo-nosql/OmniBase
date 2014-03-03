public
getFirst
	nextKey := ByteArray new: keyLength.
	self updateCurrentKey.
	currentKeyExists ifTrue: [^self lastPage association].
	^self searchNextAssociation