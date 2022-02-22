Class {
	#name : #ODBLockRegistryTest,
	#superclass : #ODBDiskBasedTest,
	#category : #'OmniBase-Tests'
}

{ #category : #tests }
ODBLockRegistryTest >> testAddLock [ 
	| tx col |
	tx := db newTransaction.
	col := OrderedCollection with: #foo.
	[tx makePersistent: col.
	tx checkpoint.
	tx lock: col.
	self assert: db lockRegistry size equals: 1]
		ensure: [ tx abort ]
]

{ #category : #tests }
ODBLockRegistryTest >> testRegisterByOpeningDatabase [ 
	self assert: ODBLockRegistry registeredPaths size equals: 1.
	db close.
	db := nil.
	Smalltalk garbageCollect .
	Smalltalk garbageCollect .
	Smalltalk garbageCollect .
	self assert: ODBLockRegistry registeredPaths size equals: 0 
]
