public/unclassified
at: aKey put: value 
	| index |
	(index := self findKey: aKey) > 0
		ifTrue: [^ values at: index put: value].
	index := 0 - index.
	elementCount = keys size
		ifTrue: [
			keys := (Array new: elementCount * 2)
						replaceFrom: 1
						to: elementCount
						with: keys
						startingAt: 1.
			values := (Array new: elementCount * 2)
						replaceFrom: 1
						to: elementCount
						with: values
						startingAt: 1].
	elementCount := elementCount + 1.
	"avoid primitive here, it seems Squeak's #replaceFrom:... doesn't handle  
	overlaps."
	elementCount to: index + 1 by: -1 do: [:i | 
		keys at: i put: (keys at: i - 1).
		values at: i put: (values at: i - 1)].
	"keys replaceFrom: index + 1 to: elementCount with: keys startingAt:  
	index. values replaceFrom: index + 1 to: elementCount with: values  
	startingAt: index."
	keys at: index put: aKey.
	^ values at: index put: value