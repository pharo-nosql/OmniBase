tests
testEquality

	| db coll |
	[
		db := OmniBase openOn: self dir.
		[ OmniBase root
			at: 'test'
			put: self collection ] evaluateAndCommitIn: db newTransaction.
		coll := db newTransaction root at: 'test'.
		#( 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 ) do: [:i |
			self assert: (coll at: i) equals: (self collection at: i)].
	] ensure: [db close]