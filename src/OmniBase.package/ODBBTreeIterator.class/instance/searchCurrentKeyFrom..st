public
searchCurrentKeyFrom: pagePosition 
	"Private - Search current key and remember all pages following."

	| currentPage nextPagePosition |
	currentPage := self loadPageAt: pagePosition.
	
	[(nextPagePosition := currentPage positionToKey: currentKey) == true 
		ifTrue: 
			[currentKeyExists := true.
			^self].
	nextPagePosition = 0] 
			whileFalse: [currentPage := self loadPageAt: nextPagePosition]