public
do: aBlock
		"Evaluate aBlock for each value in dictionary."

	| value key |
	1 to: keys size do: [:i |
		key := keys at: i.
		(key == nil or: [(value := values at: i) == 0])
			ifFalse: [ aBlock value: value ]]