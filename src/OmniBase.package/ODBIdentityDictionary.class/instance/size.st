public
size
	"Answer number of elements in dictionary."

	| count key |
	count := 0.
	1 to: keys size
		do: 
			[:i | 
			key := keys at: i.
			(key isNil or: [key == emptySlotMarker]) ifFalse: [count := count + 1]].
	^count