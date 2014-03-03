tests
testBTree
	"Test basic B-Tree dictionary functionality."
	| db t dict |
	db := OmniBase openOn: self dir.
	[
		t := db newTransaction.
		dict := db newBTreeDictionary: 20.
		dict
			at: 1 put: self collection;
			at: 2 put: 'Dva';
			at: 3 put: nil;
			at: Date today put: 'danes';
			at: 'Test' put: 'test';
			at: 'temp' put: 'temp';
			removeKey: 'temp'.

		self assert: (dict at: 2) equals: 'Dva'.
		self assert: (dict at: 3) equals: nil.
		self assert: (dict at: Date today) equals: 'danes'.
		self assert: (dict at: 'Test') equals: 'test'.
		self assert: (dict includesKey: 'Test').
		self deny: (dict includesKey: 'none').
		self assert: (dict includesKey: 3).
		self deny: (dict includesKey: 'temp').
		self assert: dict size = 5.

		t makePersistent: dict.

		self assert: (dict at: 2) equals: 'Dva'.
		self assert: (dict at: 3) equals: nil.
		self assert: (dict at: Date today) equals: 'danes'.
		self assert: (dict at: 'Test') equals: 'test'.
		self assert: (dict includesKey: 'Test').
		self deny: (dict includesKey: 'none').
		self assert: (dict includesKey: 3).
		self assert: dict size equals: 5.

		t checkpoint.

		self assert: (dict at: 2) equals: 'Dva'.
		self assert: (dict at: 3) equals: nil.
		self assert: (dict at: Date today) equals: 'danes'.
		self assert: (dict at: 'Test') equals: 'test'.
		self assert: (dict includesKey: 'Test').
		self deny: (dict includesKey: 'none').
		self assert: (dict includesKey: 3).
		dict size = 5 ifFalse: [self halt].

		t root at: 'b-tree' put: dict.
		t commit.

		t := db newTransaction.
		dict := t root at: 'b-tree'.

		self assert: (dict at: 2) equals: 'Dva'.
		self assert: (dict at: 3) equals: nil.
		self assert: (dict at: Date today) equals: 'danes'.
		self assert: (dict at: 'Test') equals: 'test'.
		self assert: (dict includesKey: 'Test').
		self deny: (dict includesKey: 'none').
		self assert: (dict includesKey: 3).
		self assert: dict size = 5.

		dict removeKey: 2.
		self deny: (dict includesKey: 2).
		self assert: dict size equals: 4.
		self assert: (dict at: 2) isNil.

		t checkpoint.

		dict at: 2 put: 'blabla'.
		self assert: dict size = 5.

		t commit.

		t := db newTransaction.
		dict := t root at: 'b-tree'.
		(dict at: 2) = 'blabla' ifFalse: [self halt].

	] ensure: [db close]