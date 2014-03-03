public
transactionValueBlocksDo: aBlock 
	"Evaluate a block for every 100 objects in dictionary.
        New transaction is created each time aBlock is evaluated."

	| subTransaction objects count client versionDescriptor |
	dataBaseObject isNil ifTrue: [OmniBase signalError: 'Object has not been stored yet'].
	client := transaction client.
	count := 0.
	objects := OrderedCollection new: 40.
	subTransaction := client newTransaction.
	"take new version descriptor"
	versionDescriptor := subTransaction versionDescriptor.
	
	[dataBaseObject valuesDo: 
			[:valueHolder | 
			[versionDescriptor versionOK: valueHolder versionNumber] 
				whileFalse: [valueHolder loadPreviousVersionFrom: transaction oldHolders].
			valueHolder isRemoved 
				ifFalse: 
					[objects add: (subTransaction objectAt: valueHolder objectID).
					(count := count + 1) == 40 
						ifTrue: 
							[aBlock value: subTransaction value: objects.
							subTransaction abort.
							count := 0.
							objects := OrderedCollection new: 40.
							subTransaction := client newTransaction.
							"take new version descriptor"
							versionDescriptor := subTransaction versionDescriptor]]].
	count > 0 ifTrue: [aBlock value: subTransaction value: objects]] 
			ensure: [subTransaction abort]