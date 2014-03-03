tests
testBTreeKeyLocking
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