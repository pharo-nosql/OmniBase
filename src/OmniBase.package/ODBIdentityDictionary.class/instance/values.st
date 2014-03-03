public
values
	| coll key |
	coll := OrderedCollection new: elementCount.
	1 to: values size
		do: 
			[:i | 
			key := keys at: i.
			(key isNil or: [key == emptySlotMarker]) ifFalse: [coll add: (values at: i)]].
	^coll