tests
testObjectLocking
	"Test if local object locking works with transactions running within one database connection."

	| db t1 t2 coll collCopy |
	
	[db := OmniBase openOn: self dir.
	"prepare"
	
	[coll := OrderedCollection with: 'This collection will be locked'.
	OmniBase root at: 'lockTest' put: coll] 
			evaluateAndCommitIn: db newTransaction.
	"test"
	t1 := db newTransaction.
	t2 := db newTransaction.
	coll := t1 root at: 'lockTest'.
	
	"Object locking. Should answer true"
	self assert: (t1 lock: coll).
	collCopy := t2 root at: 'lockTest'.
	
	"It shouldn't be able to get a lock on this object"
	self deny: (t2 lock: collCopy).
	t1 abort.
	
	self assert: (t2 lock: collCopy).
	t1 := db newTransaction.
	coll := t1 root at: 'lockTest'.
	coll first.
	self deny: (t1 lock: coll).
	t2 unlock: collCopy.
	t2 := db newTransaction.
	self assert: (t1 lock: coll).
	coll at: 1 put: 'Changed collection'.
	t1
		markDirty: coll;
		commit.
	collCopy := t2 root at: 'lockTest'.
	
	self assert: collCopy first = 'This collection will be locked'.
	"Lock should fail as it is already changed in t1"
	self deny: (t2 lock: collCopy).
	t2 := db newTransaction.
	coll := t2 root at: 'lockTest'.
	
	"Object should be changed"
	self assert: coll first = 'Changed collection'] 
			ensure: [db close]