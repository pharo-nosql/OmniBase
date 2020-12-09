Class {
	#name : #ODBClientTable,
	#superclass : #ODBFile,
	#instVars : [
		'table'
	],
	#category : 'OmniBase'
}

{ #category : #public }
ODBClientTable class >> maxClients [
	"Answer maximum number of clients connected to database. 
	Valid numbers are from 1 to 255."

	^64
]

{ #category : #accessing }
ODBClientTable >> activateClientID: clientID [
        "Mark clientID as active."

    self clientTableAt: clientID lockAndPut: 1
]

{ #category : #private }
ODBClientTable >> clientTableAt: index [
                "Private - Answer value at client table index."

        ^table at: index + 1
]

{ #category : #public }
ODBClientTable >> clientTableAt: index lockAndPut: value [ 
	"Private - Put value at client table index."

	self waitForLockAt: self headerLength + index length: 1.
	[self clientTableAt: index put: value] 
		ensure: [self unlockAt: self headerLength + index length: 1]
]

{ #category : #private }
ODBClientTable >> clientTableAt: index put: value [
                "Private - Put value at client table index."

        stream position: self headerLength + index; putByte: value
]

{ #category : #private }
ODBClientTable >> created [
                "Private - Put default values into file."

        "client table"
        stream putBytesFrom: (ByteArray new: 258); flush
]

{ #category : #defining }
ODBClientTable >> descriptionString [

    ^'OmniBase Client Table
OmniBase 1.0, David Gorisek (c) 1998

'
]

{ #category : #private }
ODBClientTable >> globalLockClientID [
                "Private - Answer clientID of client that has set global lock."

        ^table at: 1
]

{ #category : #private }
ODBClientTable >> globalLockClientID: clientID [
                "Private - Write clientID of client that has put global lock."

        stream position: self headerLength; putByte: clientID
]

{ #category : #public }
ODBClientTable >> globalUnlock [
	self lockTable.
	[self globalLockClientID: 0] ensure: [self unlockTable]
]

{ #category : #public }
ODBClientTable >> initialize [
	table := ByteArray new: self class maxClients + 1
]

{ #category : #accessing }
ODBClientTable >> isBeingRemoved: clientID [
        "Answer <true> if clientID is being removed."

    ^(self clientTableAt: clientID) == 2
]

{ #category : #private }
ODBClientTable >> loadTable [
                "Private - Load client table from file."

        stream atPosition: self headerLength getBytesFor: table
]

{ #category : #private }
ODBClientTable >> lockTable [
                "Private - Lock client table from being changed."

	self waitForLockAt: self headerLength length: table size
]

{ #category : #public }
ODBClientTable >> onClientIDsDo: aBlock [ 
	"Evaluate aBlock on every active or disconnected clientID."

	self loadTable.
	1 to: self class maxClients
		do: [:i | (self clientTableAt: i) == 0 ifFalse: [aBlock value: i]]
]

{ #category : #public }
ODBClientTable >> onNewClientIDDo: aBlock [ 
	"Evaluate aBlock with new clientID.
	aBlock will not be evaluated if no clientID is avaiable."

	self lockTable.
	
	[self loadTable.
	1 to: self class maxClients
		do: 
			[:i | 
			(self clientTableAt: i) == 0 
				ifTrue: 
					[self clientTableAt: i put: 2.
					stream flush.
					aBlock value: i.
					self clientTableAt: i put: 1.
					^self]]] 
			ensure: [self unlockTable]
]

{ #category : #accessing }
ODBClientTable >> removeClientID: clientID [
        "Remove clientID."

    self clientTableAt: clientID lockAndPut: 0
]

{ #category : #public }
ODBClientTable >> removingClientID: clientID [ 
	"Client clientID is being removed."

	self lockTable.
	
	[self loadTable.
	self globalLockClientID == clientID ifTrue: [self globalLockClientID: 0].
	(self clientTableAt: clientID) > 0 ifTrue: [self clientTableAt: clientID put: 2]] 
			ensure: [self unlockTable]
]

{ #category : #public }
ODBClientTable >> requestLockForClientID: clientID [ 
	"If global lock has not been set yet, mark that 
	clientID has requested transaction file to store locks. 
	Answer <true> if client can lock objects or <false> if not."

	self lockTable.
	
	[self loadTable.
	self globalLockClientID == 0 ifFalse: [^false].
	self clientTableAt: clientID put: 10.
	^true] 
			ensure: [self unlockTable]
]

{ #category : #public }
ODBClientTable >> setGlobalLockFor: clientID [ 
	"Try to global lock database. Answer <true> if successfull."

	self lockTable.
	
	[self loadTable.
	self globalLockClientID == 0 ifFalse: [^false].
	1 to: self class maxClients do: [:i | (self clientTableAt: i) == 10 ifTrue: [^false]].
	self globalLockClientID: clientID.
	^true] 
			ensure: [self unlockTable]
]

{ #category : #private }
ODBClientTable >> unlockTable [
                "Private - Unlock client table."

	self unlockAt: self headerLength length: table size
]
