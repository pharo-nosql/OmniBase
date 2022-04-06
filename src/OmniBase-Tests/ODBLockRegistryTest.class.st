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
ODBLockRegistryTest >> testAddLockTwiceInSameTransaction [
	| tx col |
	tx := db newTransaction.
	col := OrderedCollection with: #foo.
	[tx makePersistent: col.
	tx checkpoint.
	tx lock: col.
	tx checkpoint.
	tx lock: col.
	self assert: db lockRegistry size equals: 1]
		ensure: [ tx abort ]
]

{ #category : #tests }
ODBLockRegistryTest >> testAddLockTwiceInSeparateTransaction [
	| tx col tx2 |
	tx := db newTransaction.
	tx root at: #foo put: (OrderedCollection with: #foo).
	tx commit.
	tx := db newTransaction.
	col := tx root at: #foo.
	tx2 := db newTransaction .
	[
	tx lock: col.
	self 
		should: [ tx2 lock: col ]
		raise: ODBError ]
		ensure: [ 
			tx abort.
			tx2 abort ]
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
