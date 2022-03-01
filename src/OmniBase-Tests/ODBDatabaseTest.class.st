Class {
	#name : #ODBDatabaseTest,
	#superclass : #ODBDiskBasedTest,
	#category : #'OmniBase-Tests'
}

{ #category : #benchmarks }
ODBDatabaseTest >> benchmarkCommitNewObjects [
	| db trn dict time timeArray maxIndex maxTime stream |
	stream := WriteStream on: String new.
	db := OmniBase openOn: self testDir.
	timeArray := Array new: 6.
	maxTime := 0.
	1 to: timeArray size
		do: 
			[:count | 
			trn := db newTransaction.
			dict := OmniBase newPersistentDictionary.
			trn store: dict.
			1 to: 100
				do: 
					[:i | 
					dict at: i
						put: (Array 
								with: 'Test array'
								with: i
								with: i printString
								with: (Association key: 'Bla' value: 'Blala'))].
			time := Time millisecondsToRun: [trn commit].
			trn abort.
			stream
				nextPutAll: ' Commit time: ' , (time / 1000) asFloat printString , ' sec';
				cr.
			timeArray at: count put: time.
			time > maxTime 
				ifTrue: 
					[maxTime := time.
					maxIndex := count]].
	time := 0.
	1 to: timeArray size do: [:i | i = maxIndex ifFalse: [time := time + (timeArray at: i)]].
	time := time / (timeArray size - 1).
	stream
		nextPutAll: '------------------------';
		cr.
	stream
		nextPutAll: 'Average time: ' , (time / 1000) asFloat printString , ' sec';
		cr.
	db close.
	Transcript show: stream contents
]

{ #category : #testing }
ODBDatabaseTest >> expectedFailures [ 
	^ #( testBackup )
]

{ #category : #tests }
ODBDatabaseTest >> testBackup [

	"Test database backup."

	| t obj |
	t := db newTransaction.
	obj := Array with: 'to je test'.
	t makePersistent: obj.
	t root at: 'backup1' put: obj.
	obj := OmniBase newBTreeDictionary: 20.
	t makePersistent: obj.
	obj at: 'test' put: 'test'.
	t root at: 'backup2' put: obj.
	t commit.
	db createBackupOn: self dir , 'BackupTest'.
	db close.
	db := OmniBase openOn: self dir , 'BackupTest'.
	t := db newTransaction.
	self
		assert: (t root at: 'backup1')
		equals: (Array with: 'to je test').
	self assert: ((t root at: 'backup2') at: 'test') equals: 'test'.

	(self dir , 'BackupTest') asFileReference ensureDeleteAll
]

{ #category : #tests }
ODBDatabaseTest >> testEquality [

	| coll |
	
	[ OmniBase root
		at: 'test'
		put: self collection ] evaluateAndCommitIn: db newTransaction.
	coll := db newTransaction root at: 'test'.
	#( 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 ) do: [:i |
		self assert: (coll at: i) equals: (self collection at: i)]
]

{ #category : #tests }
ODBDatabaseTest >> testGC [
	"Test garbage collection"

	self timeLimit: 1 minute. 
	self shouldnt: [db garbageCollect] raise: Error.

]

{ #category : #tests }
ODBDatabaseTest >> testIdentity [

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
]

{ #category : #tests }
ODBDatabaseTest >> testIsChanged [
	| txn obj |
	txn := db newTransaction.
	obj := ODBTestClass1 new .
	txn makePersistent: obj.
	self assert: txn isChanged
]

{ #category : #tests }
ODBDatabaseTest >> testIsPersistent [ 
	| txn obj |
	txn := db newTransaction.
	obj := ODBTestClass1 new .
	txn makePersistent: obj.
	self assert: (txn isPersistent: obj)
]

{ #category : #tests }
ODBDatabaseTest >> testMakePersistent [

	| txn |
	txn := db newTransaction.
	txn makePersistent: self collection.
	txn commit.
	
]

{ #category : #tests }
ODBDatabaseTest >> testNewPersistent [
	| collection |
	[ collection := OrderedCollection newPersistent
		add: 'string object';
		add: 1;
		add: Date today;
		yourself ] evaluateAndCommitIn: db newTransaction.
	
	self assert: collection first equals: 'string object'.
	self assert: collection second equals: 1.
	self assert: collection third equals: Date today.
]

{ #category : #tests }
ODBDatabaseTest >> testNoClientsAfterCreation [

	self assert: db numberOfClients equals: 0.
	
]

{ #category : #tests }
ODBDatabaseTest >> testObjectLocking [

	"Test if local object locking works with transactions running within one database connection."

	| t1 t2 t3 coll collCopy |
	"prepare"
	[ 
	coll := OrderedCollection with: 'This collection will be locked'.
	OmniBase root at: 'lockTest' put: coll ] evaluateAndCommitIn:
		db newTransaction.
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
	t3 := db newTransaction.
	coll := t3 root at: 'lockTest'.
	coll first.
	self deny: (t3 lock: coll).
	t2 unlock: collCopy.
	t2 := db newTransaction.
	self assert: (t3 lock: coll).
	coll at: 1 put: 'Changed collection'.
	t3
		markDirty: coll;
		commit.
	collCopy := t2 root at: 'lockTest'.
	self assert: collCopy first equals: 'This collection will be locked'.
	"Lock should fail as it is already changed in t1"
	self deny: (t2 lock: collCopy).
	t2 := db newTransaction.
	coll := t2 root at: 'lockTest'.

	"Object should be changed"
	self assert: coll first equals: 'Changed collection'
]

{ #category : #tests }
ODBDatabaseTest >> testOneClientAfterOpening [

	| client |
	client := db localClient.
	self assert: db numberOfClients equals: 1.
	
]

{ #category : #tests }
ODBDatabaseTest >> testPersistTwoObjectsInCluster [
	| txn obj1 obj2 |
	obj1 := ODBTestClass1 new.
	obj2 := ODBTestClass1 new.
	obj1 one: obj2.
	txn := db newTransaction.

	"making only obj1 persistent stores both objects with in one byte cluster"
	txn makePersistent: obj1.
	txn prepare.
	
	self assert: txn changesPackage changes size equals: 1.
	txn abort.
	
]

{ #category : #tests }
ODBDatabaseTest >> testPersistTwoObjectsSeparate [
	| txn obj1 obj2 |
	obj1 := ODBTestClass1 new.
	obj2 := ODBTestClass1 new.
	obj1 one: obj2.
	txn := db newTransaction.

	"manually making both objects persistent will lead to two separate stored objects"
	txn makePersistent: obj2.
	txn makePersistent: obj1.
	txn prepare.
	
	self assert: txn changesPackage changes size equals: 2.
	txn abort.
	
]

{ #category : #tests }
ODBDatabaseTest >> testPersistTwoObjectsWithCollectionInCluster [
	| txn obj1 obj2 |
	obj1 := ODBTestClass1 new.
	obj2 := ODBTestClass1 new.
	obj1 one: (OrderedCollection with: obj2).
	txn := db newTransaction.

	"Storing two objects with an intermediate collection stores all three objects
	into one cluster"
	txn makePersistent: obj1.
	txn prepare.
	
	self assert: txn changesPackage changes size equals: 1.
	txn abort.
	
]

{ #category : #tests }
ODBDatabaseTest >> testPersistTwoObjectsWithCollectionSeparate [
	| txn obj1 obj2 |
	obj1 := ODBTestClass1 new.
	obj2 := ODBTestClass1 new.
	obj1 one: (OrderedCollection with: obj2).
	txn := db newTransaction.

	"storing two objects with intermediate collection making both objects persistent 
	leads to two clusters: cluster1 contains obj1 and the collection. Cluster2 contains
	obj2"
	txn makePersistent: obj2.
	txn makePersistent: obj1.
	txn prepare.
	
	self assert: txn changesPackage changes size equals: 2.
	txn abort.
	
]

{ #category : #tests }
ODBDatabaseTest >> testPersistTwoObjectsWithDictionaryInCluster [
	| txn obj1 obj2 dict |
	obj1 := ODBTestClass1 new.
	obj2 := ODBTestClass1 new.
	txn := db newTransaction.
	
	"Storing two objects with an intermediate Dictionary and making both objects
	persistent will store them into two clusters: cluster1 contains obj1 and the 
	dictionary. Cluster2 contains obj2"
	dict := Dictionary new.
	txn makePersistent: dict.
	obj1 one: dict.
	dict at: #key put: obj2.
	
	txn makePersistent: obj1.
	txn prepare.
	
	self assert: txn changesPackage changes size equals: 2.
	txn abort.
	
]

{ #category : #tests }
ODBDatabaseTest >> testPersistTwoObjectsWithODBDictionary [
	| txn obj1 obj2 dict |
	obj1 := ODBTestClass1 new.
	obj2 := ODBTestClass1 new.
	txn := db newTransaction.
	
	"Storing two objects with an intermediate ODBPersistentDictionary and making 
	obj1 and the dictionary persistent will store in multiple clusters. Cluster1 for
	obj1 and cluster2 for the dictionary. The ODBPersistentDictionary makes all its
	values persistent so we get three clusters"
	dict := ODBPersistentDictionary new.
	txn makePersistent: dict.
	obj1 one: dict.
	dict at: #key put: obj2.
	
	txn makePersistent: obj1.
	txn prepare.
	
	self assert: txn changesPackage changes size equals: 3.
	txn abort.
	
]
