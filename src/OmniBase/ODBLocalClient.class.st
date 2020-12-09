Class {
	#name : #ODBLocalClient,
	#superclass : #ODBClient,
	#instVars : [
		'hasGlobalLock',
		'freeTransactionFile'
	],
	#category : 'OmniBase'
}

{ #category : #public }
ODBLocalClient >> createOn: aClientManager clientID: anInteger [ 
	| userName machineName |
	"get logged in user and local hostname"
	self odbToDo.
	userName := nil.
	machineName := nil.
	(userName isNil or: [userName isEmpty]) ifTrue: [userName := 'unknown-user'].
	(machineName isNil or: [machineName isEmpty]) ifTrue: [machineName := 'unknown-host'].
	id := anInteger.
	clientManager := aClientManager.
	clientFile := ODBClientFile createOn: (clientManager clientFileName: id).
	clientManager addOpenedClient: self.
	self description: 'OmniBase 2.1 [clientID=' , id printString , '] ' , userName , '@' 
				, machineName
]

{ #category : #'private/for transaction control only' }
ODBLocalClient >> currentGlobalLockedTransaction [

    transactions do: [:each | each transactionFile == nil ifFalse: [ ^each ]].
    ^nil
]

{ #category : #'public/accessing' }
ODBLocalClient >> description: aString [
        "Set client description string."

    clientFile clientDescription: aString
]

{ #category : #'public/unclassified' }
ODBLocalClient >> globalLock [
        "Set global write lock to all objects in the database.
        No other client will be able to write to the database
        until the lock is released by globalUnlock. Answer <true>
        if sucessfull or <false> if failed. Global lock will fail if
        any client (including local client) allready has read-write
        transactions running. When database is globaly locked only one
        read-write transaction can run at that time."

    | count |
    count := transactionFiles size.
    freeTransactionFile isNil ifFalse: [ count := count - 1 ].
    (hasGlobalLock not and: [ count == 0 ])
        ifTrue: [ hasGlobalLock := clientManager setGlobalLockFor: id ].
    ^hasGlobalLock
]

{ #category : #'public/unclassified' }
ODBLocalClient >> globalUnlock [
        "Release global lock on database.
        Answer <true> if successfull."

    hasGlobalLock ifFalse: [ ^false ].
    transactions do: [:each | each isGlobalLocked ifTrue: [ ^false ]].
    clientManager globalUnlock.
    hasGlobalLock := false.
    ^true
]

{ #category : #'private/initialization' }
ODBLocalClient >> initialize [
        "Private - Initialize receiver."

    transactions := IdentitySet new: 20.
    transactionFiles := OrderedCollection new.
    hasGlobalLock := false.
]

{ #category : #'public/unclassified' }
ODBLocalClient >> isGlobalLocked [

    ^hasGlobalLock
]

{ #category : #'public/accessing' }
ODBLocalClient >> isLocal [

    ^true
]

{ #category : #private }
ODBLocalClient >> makeRootObject [
	"Private - Initialize root object."

	[:txn|
		txn
			root: ODBPersistentDictionary new;
			commit] value: self newTransaction
]

{ #category : #'public/unclassified' }
ODBLocalClient >> newReadOnlyTransaction [
		"Answer new read-only transaction for receiver."

	^ODBReadOnlyTransaction new
		setClient: self environment: clientManager environment;
		start
]

{ #category : #'public/unclassified' }
ODBLocalClient >> newTransaction [
        "Answer new transaction for receiver."

    | transaction |
    hasGlobalLock
        ifFalse: [ transaction := ODBLocalTransaction new ]
        ifTrue: [ transaction := ODBGlobalLockedTransaction new ].
    ^transaction setClient: self environment: clientManager environment; start
]

{ #category : #private }
ODBLocalClient >> newTransactionFileFor: aTransaction [ 
	| transactionFile transactionID count |
	count := transactionFiles size.
	freeTransactionFile isNil ifFalse: [count := count - 1].
	hasGlobalLock 
		ifTrue: 
			[aTransaction isGlobalLocked ifFalse: [^nil].
			count == 0 ifFalse: [^nil]]
		ifFalse: 
			[aTransaction isGlobalLocked ifTrue: [^nil].
			count == 0 ifTrue: [(clientManager requestLocksFor: id) ifFalse: [^nil]]].
	freeTransactionFile isNil 
		ifFalse: 
			[transactionFile := freeTransactionFile.
			freeTransactionFile := nil.
			transactions add: aTransaction.
			^transactionFile].
	transactionID := id bitShift: 8.
	256 timesRepeat: 
			[(transactionFiles includes: transactionID) 
				ifFalse: 
					[transactionFiles add: transactionID.
					clientFile transactionIDs: transactionFiles.
					[transactionFile := ODBTransactionFile createOn: (self trnFileName: transactionID)] 
						on: Error
						do: [:er | transactionFile := nil].
					transactionFile isNil 
						ifTrue: [transactionFiles remove: transactionID]
						ifFalse: 
							[transactions add: aTransaction.
							^transactionFile transactionID: transactionID]].
			transactionID := transactionID + 1].
	OmniBase signalError: 'Maximum number of active read-write transactions reached'
]

{ #category : #'public/unclassified' }
ODBLocalClient >> newTransactionFrom: aTransaction [
        "Answer new transaction for receiver from aTransaction. 
        Objects accessible in aTransaction will also be accessible 
        in new transaction."

    | transaction |
    transaction := aTransaction class new.
    ^transaction setClient: self environment: clientManager environment; startFrom: aTransaction
]

{ #category : #'public/unclassified' }
ODBLocalClient >> newTransactionInVersion: aVersionDescriptor [
        "Answer new transaction with given version descriptor."

    | transaction |
    hasGlobalLock
        ifFalse: [ transaction := ODBLocalTransaction new ]
        ifTrue: [ transaction := ODBGlobalLockedTransaction new ].
    ^transaction setClient: self environment: clientManager environment; startInVersion: aVersionDescriptor
]

{ #category : #'public/unclassified' }
ODBLocalClient >> remove [

    freeTransactionFile isNil ifFalse: [ freeTransactionFile remove ].
    freeTransactionFile := true. "do not cache transaction files anymore"
    ^super remove
]

{ #category : #'private/unclassified' }
ODBLocalClient >> transactionRemove: aTransaction [
        "Private - Remove aTransaction."

    | trnFile trID |
    (trnFile := aTransaction transactionFile) == nil ifTrue: [ ^self ].
    freeTransactionFile == nil
        ifTrue: [ freeTransactionFile := trnFile reinitialize ]
        ifFalse: [
            trID := trnFile transactionID.
            trnFile remove
                ifTrue: [
                    transactionFiles remove: trID ifAbsent: [].
                    clientFile transactionIDs: transactionFiles.
                ]
        ].
    transactionFiles size > 1 ifFalse: [ clientManager removeLocksFor: id ].
    transactions remove: aTransaction ifAbsent: []
]
