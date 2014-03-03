public
transactionDo: aBlock 
	"Evaluate a block for every object in dictionary.
        New transaction will be created for each key+value pair."

	| subTransaction client versionDescriptor |
	dataBaseObject isNil ifTrue: [OmniBase signalError: 'Object has not been stored yet'].
	versionDescriptor := transaction versionDescriptor.
	client := transaction client.
	dataBaseObject valuesDo: 
			[:valueHolder | 
			[versionDescriptor versionOK: valueHolder versionNumber] 
				whileFalse: [valueHolder loadPreviousVersionFrom: transaction oldHolders].
			valueHolder isRemoved 
				ifFalse: 
					[subTransaction := client newTransaction.
					"take new version descriptor"
					versionDescriptor := subTransaction versionDescriptor.
					aBlock value: subTransaction value: (subTransaction objectAt: valueHolder objectID).
					subTransaction abort]]