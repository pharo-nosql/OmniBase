enumerating
getCurrent
	| a |
	changed isNil 
		ifFalse: 
			[(a := changed getCurrent) isNil 
				ifFalse: 
					[a valueHolder isRemoved ifTrue: [^nil].
					^a]].
	(dataBaseObject isNil 
		or: [(a := dataBaseObject iterator goToAndGetCurrentAt: currentKey) isNil]) ifTrue: [^nil].
	a := ODBValueHolder createOn: a value.
	[transaction versionDescriptor versionOK: a versionNumber] 
		whileFalse: [a loadPreviousVersionFrom: transaction oldHolders].
	a isRemoved ifTrue: [^nil].
	^ODBBTreeDictionaryAssociation new 
		setTransaction: transaction
		key: (self keyFromBytes: currentKey)
		value: a