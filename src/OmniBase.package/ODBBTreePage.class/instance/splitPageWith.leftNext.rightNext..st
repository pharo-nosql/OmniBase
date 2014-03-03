private
splitPageWith: item leftNext: leftNext rightNext: rightNext 
	"Private - Split current page into left and right page. 
	Answer array with leftPage, middle item and rightPage."

	| newPage halfPage newItem itemOffset |
	newPage := self class 
				createOnFile: iterator
				position: 0
				keyLength: keyLength
				valueLength: valueLength.
	halfPage := self pageSize // 2.
	(contents at: 1) < 127 
		ifTrue: [contents at: 1 put: halfPage]
		ifFalse: [contents at: 1 put: halfPage + 128].
	indexOnPage == halfPage 
		ifTrue: 
			[self nextAt: halfPage put: leftNext.
			newPage contents: contents shallowCopy.
			self
				shiftPageLeft: halfPage;
				nextAt: 0 put: rightNext.
			^Array 
				with: newPage
				with: item
				with: self].
	itemOffset := halfPage * itemLength + 2.
	indexOnPage < halfPage 
		ifTrue: 
			[newPage
				contents: contents shallowCopy;
				shiftPageLeft: halfPage.
			self 
				insertSplitItem: item
				leftNext: leftNext
				rightNext: rightNext.
			newItem := contents copyFrom: itemOffset to: itemOffset + itemLength - 1.
			^Array 
				with: self
				with: newItem
				with: newPage].
	newPage contents: contents shallowCopy.
	newItem := contents copyFrom: itemOffset to: itemOffset + itemLength - 1.
	self
		shiftPageLeft: halfPage + 1;
		insertSplitItem: item
			leftNext: leftNext
			rightNext: rightNext.
	^Array 
		with: newPage
		with: newItem
		with: self