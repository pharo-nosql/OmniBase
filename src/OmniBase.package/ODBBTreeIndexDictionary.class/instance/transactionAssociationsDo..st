public
transactionAssociationsDo: aBlock 
	"Evaluate a block for each association in dictionary.
        New transaction will be created for each key."

	| subTransaction valueHolder versionDescriptor client |
	dataBaseObject isNil ifTrue: [OmniBase signalError: 'Object has not been stored yet'].
	versionDescriptor := transaction versionDescriptor.
	client := transaction client.
	dataBaseObject associationsDo: 
			[:assoc | 
			valueHolder := assoc value.
			[versionDescriptor versionOK: valueHolder versionNumber] 
				whileFalse: [valueHolder loadPreviousVersionFrom: transaction oldHolders].
			valueHolder isRemoved 
				ifFalse: 
					[subTransaction := client newTransactionFrom: transaction.
					aBlock value: subTransaction
						value: (Association key: assoc key
								value: (subTransaction referenceAt: valueHolder objectID)).
					subTransaction abort]]