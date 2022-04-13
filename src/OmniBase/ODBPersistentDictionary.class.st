Class {
	#name : #ODBPersistentDictionary,
	#superclass : #Dictionary,
	#instVars : [
		'transaction'
	],
	#category : #'OmniBase-Storage'
}

{ #category : #public }
ODBPersistentDictionary class >> odbDeserialize: deserializer [ 

	^ deserializer stream nextPersistentDictionary: self
]

{ #category : #adding }
ODBPersistentDictionary >> add: anAssociation [

	| t |
	t := transaction.
	anAssociation key isODBReference ifTrue: [ 
		self error: 'Invalid key!' ].
	super add: anAssociation.
	transaction := t.
	transaction ifNil: [ ^ anAssociation ].
	anAssociation value isImmediateObject ifFalse: [ 
		transaction makePersistent: anAssociation value ].
	transaction markDirty: self.
	^ anAssociation
]

{ #category : #converting }
ODBPersistentDictionary >> asDictionary [
	| dict |
	dict := Dictionary new.
	self associationsDo: [:assoc | dict add: assoc].
	^dict
]

{ #category : #accessing }
ODBPersistentDictionary >> at: key put: value [

	| oldValue |
	key isODBReference ifTrue: [ self error: 'Invalid key!' ].
	oldValue := self at: key ifAbsent: nil.
	value == oldValue ifTrue: [ ^ value ].
	oldValue := transaction.
	super at: key put: value.
	transaction := oldValue.
	transaction ifNil: [ ^ value ].
	transaction markDirty: self.
	(value isImmediateObject or: [ value == key ]) ifFalse: [ 
		transaction makePersistent: value ].
	^ value
]

{ #category : #public }
ODBPersistentDictionary >> odbBasicSerialize: serializer [ 
	serializer stream nextPutPersistentDictionary: self
]

{ #category : #private }
ODBPersistentDictionary >> odbLoadedIn: anOmniBaseTransaction [
	"This method is sent when the object is loaded from the database."

	transaction := anOmniBaseTransaction
]

{ #category : #private }
ODBPersistentDictionary >> odbMadePersistentIn: anOmniBaseTransaction [ 
	"This method is sent when the object is made persistent."

	transaction ifNotNil: [self error: 'Object is already persistent in another transaction'].
	transaction := anOmniBaseTransaction.
	self do: [:each | each isImmediateObject ifFalse: [transaction makePersistent: each]]
]

{ #category : #removing }
ODBPersistentDictionary >> removeKey: aKey ifAbsent: aBlock [

	| t |
	t := transaction.
	super removeKey: aKey ifAbsent: [ ^ aBlock value ].
	transaction := t.
	transaction ifNotNil: [ transaction markDirty: self ]
]

{ #category : #private }
ODBPersistentDictionary >> superAt: key put: value [

	^super at: key put: value
]

{ #category : #public }
ODBPersistentDictionary >> transaction [

	^transaction
]
