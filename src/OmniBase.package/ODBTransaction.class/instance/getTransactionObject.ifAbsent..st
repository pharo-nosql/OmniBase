private
getTransactionObject: anObject ifAbsent: aBlock 
	"Private - Answer transaction object corresponding to anObject.
	Evaluate aBlock if none."

	| transactionObject |
	anObject isODBReference 
		ifTrue: 
			[anObject odbTransaction == self 
				ifFalse: [OmniBase signalError: 'Reference from another transaction'].
			^anObject odbTransactionObject].
	cacheMutex critical: [transactionObject := objectIndex at: anObject].
	^transactionObject isNil ifTrue: [aBlock value] ifFalse: [transactionObject]