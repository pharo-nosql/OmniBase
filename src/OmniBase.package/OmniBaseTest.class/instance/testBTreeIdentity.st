tests
testBTreeIdentity
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