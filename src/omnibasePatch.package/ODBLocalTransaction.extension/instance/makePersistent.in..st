*omnibasePatch
makePersistent: anObject in: aContainerOrContainerName 
	"Store anObject into specified container if it is not stored yet, else do nothing.
	Answer anObject."

	| container |
	anObject odbObjectID isNil ifFalse: [^anObject].
	self getTransactionObject: anObject
		ifAbsent: 
			[(aContainerOrContainerName isKindOf: String)
				ifTrue: 
					[container := dbConnection objectManager containerNamed: aContainerOrContainerName
								ifAbsent: [OmniBase signalError: 'Container does not exist']]
				ifFalse: [container := aContainerOrContainerName].
			self storeNewObject: anObject inContainer: container].
	^anObject