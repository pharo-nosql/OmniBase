Class {
	#name : #ODBBTreeTest,
	#superclass : #ODBDiskBasedTest,
	#category : #'OmniBase-Tests'
}

{ #category : #tests }
ODBBTreeTest >> testBTree [
	"Test basic B-Tree dictionary functionality."
	| t dict |
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
]

{ #category : #tests }
ODBBTreeTest >> testBTreeIdentity [
	"Test B-Tree identity dictionary functionality."

	| t dict1 dict2 obj1 obj2 obj3 |
	t := db newTransaction.
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
	t := db newTransaction
]

{ #category : #tests }
ODBBTreeTest >> testBTreeIterator [
		"Test b-tree iterator by inserting large number of associations into b-tree dictionary."

	| dict |

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

]
