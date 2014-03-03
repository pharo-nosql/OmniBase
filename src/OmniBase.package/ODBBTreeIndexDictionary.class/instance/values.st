public
values
	"Answer collection of all objects in the dictionary.
	NOTE: All objects will be loaded in one transaction at once.
	Do not use this method if there are a lot of objects in the dictionary since this could block your image for some time."

	| coll assoc |
	coll := OrderedCollection new.
	assoc := self getFirst.
	[assoc isNil] whileFalse: 
			[coll add: assoc value.
			assoc := self getNext].
	^coll