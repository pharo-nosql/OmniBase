public
add: anAssociation 
	| t |
	t := transaction.
	anAssociation key isODBReference ifTrue: [self error: 'Invalid key!'].
	super add: anAssociation.
	transaction := t.
	transaction isNil ifTrue: [^anAssociation].
	anAssociation value isImmediate 
		ifFalse: [transaction makePersistent: anAssociation value].
	transaction markDirty: self.
	^anAssociation