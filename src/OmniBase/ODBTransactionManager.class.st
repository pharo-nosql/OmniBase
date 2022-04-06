Class {
	#name : #ODBTransactionManager,
	#superclass : #Object,
	#instVars : [
		'committingTransaction',
		'dbConnection',
		'mutex',
		'oldHolders',
		'serializingTransactionsSemaphore',
		'transactionReferences',
		'versionControl'
	],
	#category : #'OmniBase-Base'
}

{ #category : #public }
ODBTransactionManager >> close [
	versionControl notNil 
		ifTrue: 
			[versionControl close.
			versionControl := nil].
	oldHolders notNil 
		ifTrue: 
			[oldHolders close.
			oldHolders := nil].
	dbConnection := nil
]

{ #category : #public }
ODBTransactionManager >> createOn: aDatabase [ 
	self initializeOn: aDatabase.
	
	[versionControl := ODBVersionControlFile createOn: self vcFileName.
	oldHolders := ODBOldHoldersFile createOn: self oldHoldersFileName.
	self initializeReferences] 
			ifCurtailed: [self close]
]

{ #category : #'public/accessing' }
ODBTransactionManager >> critical: aBlock [

	mutex critical: aBlock
]

{ #category : #public }
ODBTransactionManager >> currentVersionDescriptor [
	^versionControl versionDescriptor copy
]

{ #category : #private }
ODBTransactionManager >> initializeOn: aDatabase [ 
	dbConnection := aDatabase.
	mutex := Semaphore forMutualExclusion.
	serializingTransactionsSemaphore := Semaphore new.
	serializingTransactionsSemaphore signal
]

{ #category : #private }
ODBTransactionManager >> initializeReferences [
	"Private - Initialize dictionary of transaction references."

	transactionReferences := Array new: 4.
	transactionReferences
		at: 1 put: nil;
		at: 2 put: true;
		at: 3 put: false;
		at: 4 put: dbConnection
]

{ #category : #'public/accessing' }
ODBTransactionManager >> oldHolders [

    ^oldHolders
]

{ #category : #private }
ODBTransactionManager >> oldHoldersFileName [
	^dbConnection dirName , ODBFileStream pathSeparatorString , 'omnibase.log'
]

{ #category : #public }
ODBTransactionManager >> openOn: anOmniBase [ 
	self initializeOn: anOmniBase.
	
	[versionControl := ODBVersionControlFile openOn: self vcFileName.
	[oldHolders := ODBOldHoldersFile openOn: self oldHoldersFileName] on: Error
		do: [:er | oldHolders := ODBOldHoldersFile createOn: self oldHoldersFileName].
	self initializeReferences] 
			ifCurtailed: [self close]
]

{ #category : #public }
ODBTransactionManager >> transactionAborted: aTransaction [ 
	"Discard version descriptor. Default do nothing."

	committingTransaction == aTransaction 
		ifTrue: 
			[versionControl removeCommittingFor: aTransaction client clientID.
			committingTransaction := nil.
			serializingTransactionsSemaphore signal]
]

{ #category : #public }
ODBTransactionManager >> transactionCommitBegin: aTransaction [ 
	| versionNumber |
	serializingTransactionsSemaphore wait.
	committingTransaction notNil 
		ifTrue: [OmniBase signalError: 'Concurrent commit is not allowed'].
	committingTransaction := aTransaction.
	versionNumber := versionControl getNewVersionNumberFor: aTransaction client clientID.
	aTransaction versionDescriptor versionNumber: versionNumber
]

{ #category : #public }
ODBTransactionManager >> transactionCommitEnd: aTransaction [ 
	committingTransaction == aTransaction 
		ifTrue: 
			[versionControl removeCommittingFor: aTransaction client clientID.
			committingTransaction := nil.
			serializingTransactionsSemaphore signal]
]

{ #category : #public }
ODBTransactionManager >> transactionReferenceAt: index [ 
	^(index > transactionReferences size or: [index = 0]) 
		ifFalse: [transactionReferences at: index]
]

{ #category : #'public/unclassified' }
ODBTransactionManager >> transactionStart: aTransaction [
                "Set transaction version descriptor upon transaction start."
        aTransaction versionDescriptor: versionControl versionDescriptor copy
]

{ #category : #private }
ODBTransactionManager >> vcFileName [
	^dbConnection dirName , ODBFileStream pathSeparatorString , 'omnibase.vcf'
]

{ #category : #private }
ODBTransactionManager >> versionControl [
	^versionControl
]
