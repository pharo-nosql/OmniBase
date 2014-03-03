public
at: key put: value 
	| oldValue |
	key isODBReference ifTrue: [self error: 'Invalid key!'].
	oldValue := super at: key ifAbsent: [].
	value == oldValue ifTrue: [^value].
	oldValue := transaction.
	super at: key put: value.
	transaction := oldValue.
	transaction isNil ifTrue: [^value].
	transaction markDirty: self.
	(value isImmediate or: [value == key]) ifFalse: [transaction makePersistent: value].
	^value