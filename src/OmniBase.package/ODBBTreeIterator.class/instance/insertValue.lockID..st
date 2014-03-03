private
insertValue: aValue lockID: lockID 
	"Private - Insert aValue and lockID at currentKey. 
        Precondition: search path to currentKey is loaded and 
        currentKey does not exists."

	| page pageSplit |
	page := searchPath at: searchPathHeight.
	pageSplit := page 
				insertKey: currentKey
				value: aValue
				lockID: lockID.
	pageSplit isNil 
		ifTrue: 
			[currentKeyExists := true.
			page storeLocked.
			^self].
	
	[(pageSplit at: 1)
		position: stream setToEnd;
		store.
	(pageSplit at: 3)
		position: stream position;
		store.
	searchPath at: searchPathHeight put: nil.
	searchPathHeight := searchPathHeight - 1.
	searchPathHeight == 0 
		ifFalse: [page := searchPath at: searchPathHeight]
		ifTrue: 
			[page := self pageClass 
						createOnFile: self
						position: rootPagePosition
						keyLength: keyLength
						valueLength: valueLength].
	pageSplit := page insertPageSplit: pageSplit.
	pageSplit isNil] 
			whileFalse: [].
	self clearSearchPath.
	page storeLocked