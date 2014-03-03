private
dbPeekPrevious
	| iterator assoc valueHolder |
	dataBaseObject isNil ifTrue: [^nil].
	iterator := dataBaseObject iterator.
	"critical section begin"
	iterator critical: 
			[iterator goTo: currentKey.
			
			[(assoc := iterator getPrevious) isNil ifTrue: [^nil].
			valueHolder := ODBValueHolder createOn: assoc value.
			[transaction versionDescriptor versionOK: valueHolder versionNumber] 
				whileFalse: [valueHolder loadPreviousVersionFrom: transaction oldHolders].
			valueHolder isRemoved] 
					whileTrue: []].
	"critical section end"
	^ODBBTreeDictionaryAssociation new 
		setTransaction: transaction
		key: (self keyFromBytes: assoc key)
		value: valueHolder