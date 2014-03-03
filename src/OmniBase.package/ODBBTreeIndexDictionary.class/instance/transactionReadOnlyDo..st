public
transactionReadOnlyDo: aBlock 
	"Evaluate a block for every object in dictionary.
	New transaction will be created for each key+value pair."

	| subTransaction versionDescriptor client |
	dataBaseObject isNil ifTrue: [OmniBase signalError: 'Object has not been stored yet'].
	versionDescriptor := transaction versionDescriptor.
	client := transaction client.
	dataBaseObject valuesDo: 
			[:valueHolder | 
			[versionDescriptor versionOK: valueHolder versionNumber] 
				whileFalse: [valueHolder loadPreviousVersionFrom: transaction oldHolders].
			valueHolder isRemoved 
				ifFalse: 
					[subTransaction := client newTransactionFrom: transaction.
					aBlock value: subTransaction value: (subTransaction objectAt: valueHolder objectID).
					subTransaction abort]]