public
isKeyLocked: aKey 
	"Answer <true> if aKey is locked."

	| oid |
	^(transaction isNil or: [(oid := transaction getObjectIDOrNil: aKey) isNil]) 
		ifTrue: [false]
		ifFalse: [super isKeyLocked: oid]