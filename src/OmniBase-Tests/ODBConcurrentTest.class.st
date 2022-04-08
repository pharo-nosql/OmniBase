Class {
	#name : #ODBConcurrentTest,
	#superclass : #ODBDiskBasedTest,
	#category : #'OmniBase-Tests'
}

{ #category : #tests }
ODBConcurrentTest >> testBTreeKeyLocking [

	"Test local B-Tree key locking"

	| db2 t1 t2 dict dict2 |
	db2 := OmniBase openOn: self dir.

	[ 
	t1 := db newTransaction.
	dict := db newBTreeDictionary: 5.
	t1 root at: 'concurrent-btree' put: dict.
	t1 checkpoint.
	t2 := db2 newTransaction.

	"inserting keys in one transaction"
	1 to: 100 do: [ :i | dict at: i put: 'test' ].
	t1 checkpoint.
	dict2 := t2 root at: 'concurrent-btree'.
	"inserting keys in another transaction"
	101 to: 200 do: [ :i | dict2 at: i put: 'test' ].
	t2 checkpoint.

	"every transaction sees only its own associations since t1 and t2 overlap
	(t2 was started before the t1 checkpointed its state)"
	self assert: dict size equals: 100.
	self assert: dict2 size equals: 100.

	t1 commit.
	t2 commit.

	t1 := db newTransaction.
	t2 := db2 newTransaction.
	dict := t1 root at: 'concurrent-btree'.
	dict2 := t2 root at: 'concurrent-btree'.

	self assert: (dict lockKey: 10).
	self deny: (dict2 lockKey: 10).

	dict unlockKey: 10.
	self assert: (dict2 lockKey: 10).

	dict2 at: 10 put: 'changed'.
	t2 commit.
	self deny: (dict lockKey: 10).

	"wait for half a second to ensure that version descriptor will be reloaded"
	(Delay forMilliseconds: 505) wait.
	t1 := db newTransaction.
	t2 := db2 newTransaction.
	dict := t1 root at: 'concurrent-btree'.
	dict at: 10 put: 'changed-again'.
	t1 commit.
	dict2 := t2 root at: 'concurrent-btree'.

	"in t2 the value should stay as it was since the t2 was started before t1 committed"
	self assert: (dict2 at: 10) equals: 'changed'.
	self deny: (dict2 lockKey: 10) ] ensure: [ db2 close ]
]

{ #category : #tests }
ODBConcurrentTest >> testObjectLockingDifferentDatabases [

	"Test if object locking works with transactions running in two database connections."

	"This test fails on unix based systems as locking does not rely solely on file locking but
	on the database connection. If there are two connections it does not work"

	| db2 t1 t2 coll collCopy |
	[ 
	db2 := OmniBase openOn: self dir.
	"prepare"

	[ 
	coll := OrderedCollection with: 'This collection will be locked'.
	OmniBase root at: 'lockTest' put: coll ] evaluateAndCommitIn:
		db newTransaction.
	"test"
	t1 := db newTransaction.
	t2 := db2 newTransaction.
	coll := t1 root at: 'lockTest'.
	self assert: (t1 lock: coll).
	collCopy := t2 root at: 'lockTest'.
	self deny: (t2 lock: collCopy).
	t1 abort.
	self assert: (t2 lock: collCopy).
	t1 := db newTransaction.
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
	self assert: collCopy first equals: 'This collection will be locked'.
	self deny: (t2 lock: collCopy).
	"wait here a little since changes are updated every half a second (500 ms)"
	(Delay forMilliseconds: 505) wait.
	t2 := db2 newTransaction.
	coll := t2 root at: 'lockTest'.
	self assert: coll first equals: 'Changed collection' ] ensure: [ 
		db2 close ]
]

{ #category : #tests }
ODBConcurrentTest >> testObjectLockingSameDatabase [

	"Test if object locking works with transactions running in two database connections."

	"This test fails on unix based systems as locking does not rely solely on file locking but
	on the database connection. If there are two connections it does not work"

	| t1 t2 coll collCopy |
	[ 
	[ 
	coll := OrderedCollection with: 'This collection will be locked'.
	OmniBase root at: 'lockTest' put: coll ] evaluateAndCommitIn:
		db newTransaction.
	"test"
	t1 := db newTransaction.
	t2 := db newTransaction.
	coll := t1 root at: 'lockTest'.
	self assert: (t1 lock: coll).
	collCopy := t2 root at: 'lockTest'.
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
	self assert: collCopy first equals: 'This collection will be locked'.
	self deny: (t2 lock: collCopy).
	"wait here a little since changes are updated every half a second (500 ms)"
	(Delay forMilliseconds: 505) wait.
	t2 := db newTransaction.
	coll := t2 root at: 'lockTest'.
	self assert: coll first equals: 'Changed collection' ] ensure: [ 
		db close ]
]
