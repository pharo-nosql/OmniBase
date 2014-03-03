public
store: anObject in: anODBContainerOrString ifLocked: aBlock 
	"Store anObject into given container anODBContainerOrString which can be either a String (container name) or an ODBContainer.
	Evaluate aBlock if anObject can not be locked."

	| objectToStore transactionObject container |
	(objectToStore := anObject) odbObjectID isNil 
		ifFalse: 
			[anObject isODBReference ifFalse: [^self].
			anObject odbNotLoaded ifTrue: [^self].
			anObject odbTransaction == self ifFalse: [objectToStore := anObject odbResolve]].
	transactionObject := self getTransactionObject: objectToStore
				ifAbsent: 
					[anODBContainerOrString class == String 
						ifTrue: 
							[container := dbConnection objectManager containerNamed: anODBContainerOrString
										ifAbsent: [OmniBase signalError: 'Invalid container name']]
						ifFalse: [container := anODBContainerOrString].
					^self storeNewObject: objectToStore inContainer: container].
	"* namesto: (self lock: anObject) ifFalse: [ ^aBlock value ]."
	transactionObject objectID index == 0 ifTrue: [^true].	"*"
	transactionObject lock ifFalse: [^aBlock value].	"*"
	transactionObject objectChanged