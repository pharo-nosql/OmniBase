public
do: aBlock 
	"Evaluate aBlock for each object in the dictionary.
	NOTE: All objects will be loaded in one transaction at once.
	Do not use this method if there are a lot of objects in the dictionary since this could take some time."

	| assoc |
	assoc := self getFirst.
	[assoc isNil] whileFalse: 
			[aBlock value: assoc value.
			assoc := self getNext]