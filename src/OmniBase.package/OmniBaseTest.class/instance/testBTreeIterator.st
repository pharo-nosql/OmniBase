tests
testBTreeIterator
		"Test b-tree iterator by inserting large number of associations into b-tree dictionary."

	| db dict |
	db := OmniBase openOn: self dir.
	[
		[dict := OmniBase newBTreeDictionary: 5.
		OmniBase root at: 'big-dict' put: dict.
		0 to: 300 by: 2 do: [:i | dict at: i put: i printString].
		299 to: 1 by: -2 do: [:i | dict at: i put: i printString]]
			evaluateAndCommitIn: db newTransaction.

		[dict := OmniBase root at: 'big-dict'.
		299 to: 1 by: -2 do: [:i | 
			self assert: (dict at: i) = i printString].
		0 to: 300 by: 2 do: [:i | 
			self assert: (dict at: i) = i printString]]
			evaluateIn: db newTransaction.

	] ensure: [db close]