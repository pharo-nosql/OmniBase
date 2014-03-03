public
removeKey: aKey ifAbsent: aBlock 
	| t |
	t := transaction.
	super removeKey: aKey ifAbsent: [^aBlock value].
	transaction := t.
	transaction isNil ifFalse: [transaction markDirty: self]