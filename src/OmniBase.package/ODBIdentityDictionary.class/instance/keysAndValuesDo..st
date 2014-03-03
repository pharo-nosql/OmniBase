public
keysAndValuesDo: aBlock 
	"Evaluate aBlock for each value in dictionary."

	| key |
	1 to: keys size
		do: 
			[:i | 
			key := keys at: i.
			(key isNil or: [key == emptySlotMarker]) 
				ifFalse: [aBlock value: key value: (values at: i)]]