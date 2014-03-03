tests
testMakePersistent

	| db txn |
	[
		db := OmniBase openOn: self dir.
		txn := db newTransaction.
		txn makePersistent: self collection.
		txn commit.
	] ensure: [db close]