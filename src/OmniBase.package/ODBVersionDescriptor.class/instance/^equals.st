public
= anObject 
	anObject class == self class ifFalse: [^false].
	^topVersionNumber == anObject topVersionNumber 
		and: [committingTransactions size == anObject committingTransactions size]