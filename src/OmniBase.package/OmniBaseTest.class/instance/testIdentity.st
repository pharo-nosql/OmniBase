tests
testIdentity

	| db |
	[
		db := OmniBase openOn: self dir.
		[| coll1 coll2 str |
		coll1 := OrderedCollection new.
		coll2 := OrderedCollection new.
		str := 'This is a string'.
		coll1 add: str.
		coll2 add: str.
		OmniBase root at: 'one' put: coll1.
		OmniBase root at: 'two' put: coll2. ]
			evaluateAndCommitIn: db newTransaction.
		[| coll1 coll2 |
		coll1 := OmniBase root at: 'one'.
		coll2 := OmniBase root at: 'two'.
		self deny: (coll1 first isIdenticalTo: coll2 first).
		]
			evaluateIn: db newTransaction.
	] ensure: [db close]