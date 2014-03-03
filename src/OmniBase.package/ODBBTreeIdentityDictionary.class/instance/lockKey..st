public
lockKey: aKey 
	"Lock key aKey so that other transactions wont be able
	to change it. Answer <true> if successfull."

	| oid |
	^(transaction isNil or: [(oid := transaction getObjectIDOrNil: aKey) isNil]) 
		ifTrue: [true]
		ifFalse: [super lockKey: oid]