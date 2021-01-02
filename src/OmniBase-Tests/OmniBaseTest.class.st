Class {
	#name : #OmniBaseTest,
	#superclass : #TestCase,
	#category : #'OmniBase-Tests'
}

{ #category : #benchmarks }
OmniBaseTest >> benchmarkCommitNewObjects [
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

{ #category : #accessing }
OmniBaseTest >> collection [

	| coll |
	coll := OrderedCollection new.
	coll
		add: 1;
		add: -1;
		add: true;
		add: false;
		add: nil;
		add: 1000;
		add: -1000;
		add: 0.0;
		add: 1.0;
		add: -123.43;
		add: 13 factorial;
		add: 215345245.3425;
		add: 2 / 3;
		add: Date today;
		add: (Time fromSeconds: 20000);
		add: $a;
		add: #symbol;
		add: '';
		add: 'Hello world';
		add: self class;
		"add: Smalltalk;"
		add: (Dictionary new at: 'key' put: 'value'; yourself);
		add: IdentityDictionary new;
		add: (Array with: 'a' with: 'b');
		add: coll.
	^coll
]

{ #category : #accessing }
OmniBaseTest >> dir [

	^ (FileLocator imageDirectory  / 'OmniBaseTester') resolve pathString
]

{ #category : #running }
OmniBaseTest >> setUp [
	| db |
	[db := OmniBase createOn: self dir ] ensure: [db close]
]

{ #category : #running }
OmniBaseTest >> tearDown [
	self dir asFileReference exists ifTrue: [
		self dir asFileReference deleteAll]
]

{ #category : #tests }
OmniBaseTest >> testBTree [
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
]

{ #category : #tests }
OmniBaseTest >> testBTreeIdentity [
	"Test B-Tree identity dictionary functionality."

	| db t dict1 dict2 obj1 obj2 obj3 |
	db := OmniBase openOn: self dir.
	
	[t := db newTransaction.
	dict1 := db newBTreeIdentityDictionary.
	dict2 := db newBTreeIdentityDictionary.
	obj1 := Array with: 'Array with String as obj1'.
	obj2 := Array with: obj1 with: 'Array with String and obj1 as obj2'.
	obj3 := Array with: Date today.
	t root at: 'obj2' put: obj2.
	dict1 at: obj1 put: obj2.
	
	self assert: (dict1 at: obj1) == obj2.
	
	dict2 at: obj1 put: t root.
	dict2 at: t root put: obj1.
	dict1 at: t root put: obj1.
	dict2 at: t root put: dict1.
	dict2 at: dict2 put: obj1.
	
	self assert: (dict2 at: obj1) == t root.
	self assert: dict1 size = 2.
	self assert: dict2 size = 3.
	
	dict1 at: obj3 put: Date today.
	t makePersistent: dict2.
	dict2 at: obj3 put: Date today.
	dict1 removeKey: obj3.
	dict2 removeKey: obj3.
	t makePersistent: dict1.
	
	self assert: dict1 size = 2.
	self assert: dict2 size = 3.
	
	t checkpoint.
	
	self assert: (dict1 at: obj1) == obj2.
	t root at: 'identity-dict1' put: dict1.
	dict1 at: t root put: dict2.
	t commit.
	t := db newTransaction.
	dict1 := t root at: 'identity-dict1'.
	dict2 := dict1 at: t root.
	obj1 := dict2 at: dict2.
	obj2 := dict1 at: obj1.
	
	self assert: ((dict2 at: obj1) isIdenticalTo: t root).
	self assert: ((dict2 at: t root) isIdenticalTo: dict1).
	
	t checkpoint.
	t commit.
	t := db newTransaction] 
			ensure: [db close]
]

{ #category : #tests }
OmniBaseTest >> testBTreeIterator [
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
]

{ #category : #tests }
OmniBaseTest >> testBTreeKeyLocking [
	"Test local B-Tree key locking"

	| db1 db2 t1 t2 dict dict2 |
	db1 := OmniBase openOn: self dir.
	db2 := OmniBase openOn: self dir.
	
	[t1 := db1 newTransaction.
	dict := db1 newBTreeDictionary: 5.
	t1 root at: 'concurrent-btree' put: dict.
	t1 checkpoint.
	t2 := db2 newTransaction.

	"inserting keys in one transaction"
	1 to: 100 do: [:i | dict at: i put: 'test'].
	t1 checkpoint.
	dict2 := t2 root at: 'concurrent-btree'.
	"inserting keys in another transaction"
	101 to: 200 do: [:i | dict2 at: i put: 'test'].
	t2 checkpoint.

	"every transaction sees only its own associations since t1 and t2 overlap
	(t2 was started before the t1 checkpointed its state)"
	self assert: dict size = 100.
	self assert: dict2 size = 100.
	
	t1 commit.
	t2 commit.
	t1 := db1 newTransaction.
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
	(Delay forMilliseconds: 501) wait.
	t1 := db1 newTransaction.
	t2 := db2 newTransaction.
	dict := t1 root at: 'concurrent-btree'.
	dict at: 10 put: 'changed-again'.
	t1 commit.
	dict2 := t2 root at: 'concurrent-btree'.
	
	"in t2 the value should stay as it was since the t2 was started before t1 committed"
	self assert: (dict2 at: 10) = 'changed'.
	self deny: (dict2 lockKey: 10)] 
			ensure: 
				[db1 close.
				db2 close]
]

{ #category : #tests }
OmniBaseTest >> testBackup [
	"Test database backup."

	| db t obj |
	db := OmniBase openOn: self dir.
	t := db newTransaction.
	obj := Array with: 'to je test'.
	t makePersistent: obj.
	t root at: 'backup1' put: obj.
	obj := OmniBase newBTreeDictionary: 20.
	t makePersistent: obj.
	obj at: 'test' put: 'test'.
	t root at: 'backup2' put: obj.
	t commit.
	db createBackupOn: self dir, 'BackupTest'.
	db close.
	db := OmniBase openOn: self dir, 'BackupTest'.
	t := db newTransaction.
	
	self assert: (t root at: 'backup1') = (Array with: 'to je test').
	self assert: ((t root at: 'backup2') at: 'test') = 'test'.
	
	db close.
	(self dir, 'BackupTest') asFileReference ensureDeleteAll
]

{ #category : #tests }
OmniBaseTest >> testEquality [

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
]

{ #category : #tests }
OmniBaseTest >> testGC [
	"Test garbage collection"

	| db |
	self timeLimit: 1 minute. 
	db := OmniBase openOn: self dir.
	self shouldnt: [db garbageCollect] raise: Error.
	db close
]

{ #category : #tests }
OmniBaseTest >> testIdentity [

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
]

{ #category : #tests }
OmniBaseTest >> testMakePersistent [

	| db txn |
	[
		db := OmniBase openOn: self dir.
		txn := db newTransaction.
		txn makePersistent: self collection.
		txn commit.
	] ensure: [db close]
]

{ #category : #tests }
OmniBaseTest >> testNewPersistent [

	| db |
	[
		db := OmniBase openOn: self dir.
		[ OrderedCollection newPersistent
			add: 'string object';
			add: 1;
			add: Date today ] evaluateAndCommitIn: db newTransaction.
	] ensure: [db close]
]

{ #category : #tests }
OmniBaseTest >> testNumberOfClients [

	| db |
	[
		db := OmniBase openOn: self dir.
		self assert: db numberOfClients equals: 0.
	] ensure: [db close].
]

{ #category : #tests }
OmniBaseTest >> testObjectLocking [
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
]

{ #category : #tests }
OmniBaseTest >> testObjectLocking2 [
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
]
