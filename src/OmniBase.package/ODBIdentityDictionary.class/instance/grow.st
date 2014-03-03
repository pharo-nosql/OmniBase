private
grow
	"Private - Grow the receiver to double size to accomodate more key/value pairs."

	| oldSize oldValues oldKeys key value |
	oldKeys := keys.
	oldSize := keys size.
	oldValues := values.
	self initialize: oldSize * 2.
	1 to: oldSize
		do: 
			[:index | 
			key := oldKeys at: index.
			(key isNil 
				or: [key == emptySlotMarker or: [(value := oldValues at: index) == emptySlotMarker]]) 
					ifFalse: [self at: key put: value]]