private
insertSplitItem: item leftNext: leftNext rightNext: rightNext 
	"Private - Insert aByteArray at indexOnPage. Answer item 
	at pageSize // 2 that is going to be moved up the tree."

	| itemOffset nextOffset n |
	n := self pageSize // 2.
	itemOffset := itemLength * indexOnPage + 1.
	nextOffset := itemLength * self pageSize + (indexOnPage * 4) + 1.
	self bytesAtOffset: itemOffset + itemLength
		put: (self bytesAtOffset: itemOffset count: (n - indexOnPage) * itemLength).
	self bytesAtOffset: nextOffset + 8
		put: (self bytesAtOffset: nextOffset + 4 count: (n - indexOnPage) * 4).
	self
		bytesAtOffset: itemOffset put: item;
		uLongAtOffset: nextOffset put: leftNext;
		uLongAtOffset: nextOffset + 4 put: rightNext