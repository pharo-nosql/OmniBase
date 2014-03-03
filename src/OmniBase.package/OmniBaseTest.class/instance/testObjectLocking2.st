tests
testObjectLocking2
	"Test if object locking works with transactions running in two database connections."

	| db1 db2 t1 t2 coll collCopy |
	
	[db1 := OmniBase openOn: self dir.
	db2 := OmniBase openOn: self dir.
	"prepare"
	
	[coll := OrderedCollection with: 'This collection will be locked'.
	OmniBase root at: 'lockTest' put: coll] 
			evaluateAndCommitIn: db1 newTransaction.
	"test"
	t1 := db1 newTransaction.
	t2 := db2 newTransaction.
	coll := t1 root at: 'lockTest'.
	self assert: (t1 lock: coll).
	collCopy := t2 root at: 'lockTest'.
	self deny: (t2 lock: collCopy).
	t1 abort.
	self assert: (t2 lock: collCopy).
	t1 := db1 newTransaction.
	coll := t1 root at: 'lockTest'.
	coll first.
	self deny: (t1 lock: coll).
	t2 unlock: collCopy.
	t2 := db2 newTransaction.
	self assert: (t1 lock: coll).
	coll at: 1 put: 'Changed collection'.
	t1
		markDirty: coll;
		commit.
	collCopy := t2 root at: 'lockTest'.
	self assert: collCopy first = 'This collection will be locked' .
	self deny: (t2 lock: collCopy).
	"wait here a little since changes are updated every half a second (500 ms)"
	(Delay forMilliseconds: 501) wait.
	t2 := db2 newTransaction.
	coll := t2 root at: 'lockTest'.
	self assert: coll first = 'Changed collection'] 
			ensure: 
				[db1 close.
				db2 close]