Class {
	#name : #ODBPersistentDictionary,
	#superclass : #Dictionary,
	#instVars : [
		'transaction'
	],
	#category : 'OmniBase'
}

{ #category : #public }
ODBPersistentDictionary class >> odbDeserialize: deserializer [ 
	| size dict key |
	size := deserializer stream getPositiveInteger.
	dict := self new: size.
	deserializer register: dict.
	size timesRepeat: 
			[key := deserializer odbNextObject.
			dict superAt: key put: deserializer odbNextObject].
	^dict
]

{ #category : #public }
ODBPersistentDictionary >> add: anAssociation [ 
	| t |
	t := transaction.
	anAssociation key isODBReference ifTrue: [self error: 'Invalid key!'].
	super add: anAssociation.
	transaction := t.
	transaction isNil ifTrue: [^anAssociation].
	anAssociation value isImmediate 
		ifFalse: [transaction makePersistent: anAssociation value].
	transaction markDirty: self.
	^anAssociation
]

{ #category : #public }
ODBPersistentDictionary >> asDictionary [
	| dict |
	dict := Dictionary new.
	self associationsDo: [:assoc | dict add: assoc].
	^dict
]

{ #category : #public }
ODBPersistentDictionary >> at: key put: value [ 
	| oldValue |
	key isODBReference ifTrue: [self error: 'Invalid key!'].
	oldValue := super at: key ifAbsent: [].
	value == oldValue ifTrue: [^value].
	oldValue := transaction.
	super at: key put: value.
	transaction := oldValue.
	transaction isNil ifTrue: [^value].
	transaction markDirty: self.
	(value isImmediate or: [value == key]) ifFalse: [transaction makePersistent: value].
	^value
]

{ #category : #public }
ODBPersistentDictionary >> odbBasicSerialize: serializer [ 
	(serializer stream)
		putByte: 83;
		putPositiveInteger: self size.
	self keysAndValuesDo: 
			[:key :value | 
			key odbSerialize: serializer.
			value odbSerialize: serializer]
]

{ #category : #private }
ODBPersistentDictionary >> odbLoadedIn: anOmniBaseTransaction [
		"This method is sent when the object is loaded from the database."

	transaction := anOmniBaseTransaction
]

{ #category : #private }
ODBPersistentDictionary >> odbMadePersistentIn: anOmniBaseTransaction [ 
	"This method is sent when the object is made persistent."

	transaction notNil 
		ifTrue: [self error: 'Object is already persistent in another transaction'].
	transaction := anOmniBaseTransaction.
	self do: [:each | each isImmediate ifFalse: [transaction makePersistent: each]]
]

{ #category : #public }
ODBPersistentDictionary >> removeKey: aKey ifAbsent: aBlock [ 
	| t |
	t := transaction.
	super removeKey: aKey ifAbsent: [^aBlock value].
	transaction := t.
	transaction isNil ifFalse: [transaction markDirty: self]
]

{ #category : #private }
ODBPersistentDictionary >> superAt: key put: value [

	^super at: key put: value
]

{ #category : #public }
ODBPersistentDictionary >> transaction [

	^transaction
]
