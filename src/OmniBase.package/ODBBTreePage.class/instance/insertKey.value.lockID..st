public
insertKey: key value: value lockID: lockID 
	"Insert key, value and lockID at current position on page. Answer 
        array with page split information or <nil> if no page split occured."

	| n startOffset |
	startOffset := itemLength * indexOnPage + 1.
	n := self numberOfItems.
	n == self pageSize 
		ifTrue: 
			["split page"
			contents at: 1 put: ((contents at: 1) bitOr: 128).	"this page must be leaf"
			n := ByteArray new: itemLength.
			n
				replaceFrom: 1
					to: keyLength
					with: key
					startingAt: 1;
				replaceFrom: keyLength + 1
					to: keyLength + valueLength
					with: value
					startingAt: 1;
				odbShortAt: itemLength - 1 put: lockID.
			^self 
				splitPageWith: n
				leftNext: 0
				rightNext: 0].
	n > indexOnPage 
		ifTrue: 
			[self bytesAtOffset: startOffset + itemLength
				put: (self bytesAtOffset: startOffset count: (n - indexOnPage) * itemLength)].
	self
		bytesAtOffset: startOffset put: key;
		bytesAtOffset: startOffset + keyLength put: value;
		uShortAtOffset: startOffset + keyLength + valueLength put: lockID.
	self numberOfItems: n + 1.
	^nil