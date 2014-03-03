private
updateCurrentKey
	"Private - Check if iterator has been moved
        and update cache if it has been moved."

	| nextPagePosition |
	searchPathHeight = 0 
		ifTrue: 
			[currentKey := nextKey.
			currentKeyExists := false.
			^self searchCurrentKeyFrom: rootPagePosition].
	self isCurrentKeySet ifTrue: [^self].
	currentKey := nextKey.
	currentKeyExists := false.
	[searchPathHeight > 1] whileTrue: 
			[(nextPagePosition := (searchPath at: searchPathHeight) positionToCachedKey: currentKey) 
				== true 
					ifTrue: 
						[currentKeyExists := true.
						^self].
			nextPagePosition isNil 
				ifFalse: 
					[nextPagePosition = 0 ifTrue: [^self].
					^self searchCurrentKeyFrom: nextPagePosition].
			searchPath at: searchPathHeight put: nil.
			searchPathHeight := searchPathHeight - 1].
	(nextPagePosition := (searchPath at: 1) positionToKey: currentKey) == true 
		ifTrue: 
			[currentKeyExists := true.
			^self].
	nextPagePosition = 0 ifFalse: [self searchCurrentKeyFrom: nextPagePosition]