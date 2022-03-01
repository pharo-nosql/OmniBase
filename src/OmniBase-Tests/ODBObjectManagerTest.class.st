Class {
	#name : #ODBObjectManagerTest,
	#superclass : #ODBDiskBasedTest,
	#instVars : [
		'objectManager'
	],
	#category : #'OmniBase-Tests'
}

{ #category : #initialization }
ODBObjectManagerTest >> setUp [ 
	super setUp.
	objectManager := db objectManager.
]

{ #category : #running }
ODBObjectManagerTest >> tearDown [ 
	super tearDown.
	objectManager := nil
]

{ #category : #tests }
ODBObjectManagerTest >> testClassVersionReshapes [
	| tmpClass obj1 obj2 transaction info1 info2 |
	tmpClass := ODBTestClass1 copy.
	self assertCollection: tmpClass instVarNames hasSameElements: #( one two three).
	obj1 := tmpClass new 
		one: 'one1';
		two: 'two1';
		three: 'three1'.
	transaction := db newTransaction.
	transaction makePersistent: obj1.
	transaction root at: 'test1' put: obj1.
	info1 := db classManager find: tmpClass.
	transaction commit.
	tmpClass 
		removeInstVarNamed: 'two';
		"addInstVarNamed: 'four';"
		addInstVarNamed: 'two'.
	self assertCollection: tmpClass instVarNames hasSameElements: #( one three two).
	obj2 := tmpClass new 
		one: 'one2';
		two: 'two2';
		three: 'three2';
		"instVarNamed: #four put: 'four';"
		yourself.
	info2 := db classManager find: tmpClass.

	self assert: obj2 one equals: 'one2'.
	self assert: obj2 two equals: 'two2'.
	self assert: obj2 three equals: 'three2'
]

{ #category : #tests }
ODBObjectManagerTest >> testDefaultIsOneContainer [
	self assert: objectManager containers size equals: 1
]
