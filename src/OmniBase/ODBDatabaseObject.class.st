Class {
	#name : #ODBDatabaseObject,
	#superclass : #Object,
	#instVars : [
		'objectHolder'
	],
	#classVars : [
		'ClassIDs'
	],
	#category : 'OmniBase'
}

{ #category : #private }
ODBDatabaseObject class >> addClassIDsTo: aDictionary [
        "Private - Add classID of each subclass of receiver 
        to aDictionary. Answer class ID maximum."

    | maxID |
    maxID := 0.
    self subclasses do: [:each |
        aDictionary at: each classID put: each.
        maxID := (each classID max: maxID) max: (each addClassIDsTo: aDictionary)].
    ^maxID
]

{ #category : #public }
ODBDatabaseObject class >> hasBytes [
	"Answer <true> if the object stores its contents as bytes."

	^false
]

{ #category : #public }
ODBDatabaseObject class >> hasExternalFiles [
	"Answer <true> if the object stores its contents into external files."

	^false
]

{ #category : #private }
ODBDatabaseObject class >> initialize [
	"Private - Initialize ClassIDs array used to convert classID to appropriate class."

	| dict maxID |
	dict := IdentityDictionary new.
	maxID := self addClassIDsTo: dict.
	ClassIDs := Array new: maxID.
	dict keysAndValuesDo: [:key :value | ClassIDs at: key put: value]
]

{ #category : #accessing }
ODBDatabaseObject class >> persistentClassAt: anInteger [
        "Answer persistent class for a given class ID."

    ^ClassIDs at: anInteger
]

{ #category : #'public/create/open/close' }
ODBDatabaseObject >> close [
        "Implemented by subclasses."
]

{ #category : #public }
ODBDatabaseObject >> garbageCollectOn: anODBGarbageCollector [ 
	self close
]

{ #category : #public }
ODBDatabaseObject >> makeTransactionObject: aTransaction [ 
	"Make transaction object from receiver. "

	self subclassResponsibility
]

{ #category : #'public/accessing' }
ODBDatabaseObject >> objectHolder [

    ^objectHolder
]

{ #category : #'public/create/open/close' }
ODBDatabaseObject >> openOn: anObjectHolder [

    objectHolder := anObjectHolder
]

{ #category : #'public/unclassified' }
ODBDatabaseObject >> referencesDo: aBlock [
]

{ #category : #'public/unclassified' }
ODBDatabaseObject >> remove [
]
