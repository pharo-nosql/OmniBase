tests
testNewPersistent

	| db |
	[
		db := OmniBase openOn: self dir.
		[ OrderedCollection newPersistent
			add: 'string object';
			add: 1;
			add: Date today ] evaluateAndCommitIn: db newTransaction.
	] ensure: [db close]