Class {
	#name : #ODBChangesPackage,
	#superclass : #Object,
	#instVars : [
		'changes'
	],
	#category : 'OmniBase'
}

{ #category : #'as yet unclassified' }
ODBChangesPackage class >> new [

    ^super new initialize
]

{ #category : #public }
ODBChangesPackage >> add: aChange [ 
	changes add: aChange
]

{ #category : #public }
ODBChangesPackage >> changes [
	^changes
]

{ #category : #'private/unclassified' }
ODBChangesPackage >> collectChangeClassIDsFrom: rootClass to: aDictionary [
        "Private - Collect all change classIDs and store them to aDictionary."

    rootClass changeClassID notNil
        ifTrue: [aDictionary at: rootClass changeClassID put: rootClass].
    rootClass subclasses do: [:each | self collectChangeClassIDsFrom: each to: aDictionary]
]

{ #category : #public }
ODBChangesPackage >> commit [
	changes do: [:each | each commit]
]

{ #category : #'public/unclassified' }
ODBChangesPackage >> committed [
        "Changes have just been committed."

    changes do: [:each | each committed]
]

{ #category : #private }
ODBChangesPackage >> fixTemps [
	^self
]

{ #category : #private }
ODBChangesPackage >> initialize [
	changes := (SortedCollection new: 300) sortBlock: self
]

{ #category : #public }
ODBChangesPackage >> loadFromStream: aStream [ 
	"Load receiver from aStream."

	"collect change class IDs"

	| memoryStream classID classes change |
	classes := IdentityDictionary new.
	self collectChangeClassIDsFrom: ODBChange to: classes.
	"load changes"
	changes := OrderedCollection new.
	memoryStream := ODBMemoryReadStream new readFrom: aStream.
	[(classID := memoryStream getByte) > 0] whileTrue: 
			[change := (classes at: classID
						ifAbsent: [OmniBase signalError: 'Transaction rollback: Unknown change classID']) new 
						loadFromStream: memoryStream.
			changes add: change]
]

{ #category : #public }
ODBChangesPackage >> rollback [
	"Rollback change objects."

	changes do: [:each | each rollback]
]

{ #category : #public }
ODBChangesPackage >> storeOnStream: aStream [ 
	"Store receiver on aStream."

	| memoryStream classID |
	memoryStream := ODBMemoryWriteStream new.
	changes do: 
			[:each | 
			(classID := each class changeClassID) isNil 
				ifFalse: 
					[memoryStream putByte: classID.
					each storeOnStream: memoryStream]].
	memoryStream
		putByte: 0;
		writeOn: aStream
]

{ #category : #public }
ODBChangesPackage >> transaction: aTransaction [ 
	changes do: [:each | each transaction: aTransaction]
]

{ #category : #private }
ODBChangesPackage >> value: change1 value: change2 [ 
	"Private - Answer <true> if change1 is to be committed before change2.
	Disk access optimization so that files are updated sequentialy."

	| oid1 oid2 cid1 cid2 |
	(oid1 := change1 objectID) isNil ifTrue: [^true].
	(oid2 := change2 objectID) isNil ifTrue: [^false].
	(cid1 := oid1 containerID) == (cid2 := oid2 containerID) 
		ifTrue: [^oid1 index < oid2 index].
	^cid1 < cid2
]
