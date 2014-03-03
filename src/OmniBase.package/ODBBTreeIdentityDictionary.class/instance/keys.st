public
keys
	"Answer collection of all keys in the dictionary.
	NOTE: All objects will be loaded in one transaction at once.
	Do not use this method if there are a lot of objects in the dictionary since this could block your image for some time."

	| coll assoc |
	coll := OrderedCollection new: self size.
	coll addAll: newKeys keys.
	transaction isNil 
		ifFalse: 
			[assoc := self getFirst.
			[assoc isNil] whileFalse: 
					[coll add: (transaction referenceAt: (ODBObjectID new fromBytes: assoc key at: 1)).
					assoc := self getNext]].
	^coll