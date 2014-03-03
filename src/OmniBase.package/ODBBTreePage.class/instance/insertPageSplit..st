public
insertPageSplit: pageSplit 
	"Insert page split at current position on page. Answer array 
        with page split information if another page split is needed 
        or <nil> if current page is not full."

	| n itemOffset nextOffset pageSize item leftNext rightNext |
	leftNext := (pageSplit at: 1) position.
	item := pageSplit at: 2.
	rightNext := (pageSplit at: 3) position.
	pageSize := self pageSize.
	n := self numberOfItems.
	n == pageSize 
		ifTrue: 
			[^self 
				splitPageWith: item
				leftNext: leftNext
				rightNext: rightNext].
	itemOffset := itemLength * indexOnPage + 1.
	nextOffset := itemLength * pageSize + (indexOnPage * 4) + 1.
	n > indexOnPage 
		ifTrue: 
			[self bytesAtOffset: itemOffset + itemLength
				put: (self bytesAtOffset: itemOffset count: (n - indexOnPage) * itemLength).
			self bytesAtOffset: nextOffset + 8
				put: (self bytesAtOffset: nextOffset + 4 count: (n - indexOnPage) * 4)].
	self
		bytesAtOffset: itemOffset put: item;
		uLongAtOffset: nextOffset put: leftNext;
		uLongAtOffset: nextOffset + 4 put: rightNext;
		numberOfItems: n + 1.
	^nil