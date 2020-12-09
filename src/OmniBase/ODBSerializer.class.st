Class {
	#name : #ODBSerializer,
	#superclass : #Object,
	#instVars : [
		'mainObject',
		'classCollection',
		'classes',
		'classesCounter',
		'classManager',
		'counter',
		'externalObjects',
		'objects',
		'stream',
		'referenceManager'
	],
	#category : 'OmniBase'
}

{ #category : #public }
ODBSerializer class >> classDescriptionFor: aClass [

    ^ODBClassDescription new createFor: aClass
]

{ #category : #public }
ODBSerializer class >> classDescriptionFrom: aStream [ 
	^ODBClassDescription new loadFromStream: aStream
]

{ #category : #public }
ODBSerializer class >> new [

	^super new initialize
]

{ #category : #public }
ODBSerializer class >> serialize: anObject on: aWriteStream [ 
	| classManager byteStream byteStream2 |
	classManager := ODBClassManagerForSerialization new initializeForSerialization.
	byteStream := ODBMemoryWriteStream new.
	self new 
		serialize: anObject
		onStream: byteStream
		referenceManager: nil
		classManager: classManager.
	byteStream2 := ODBMemoryWriteStream new.
	byteStream2 putPositiveInteger: 0.
	classManager saveOnStream: byteStream2.
	byteStream2 writeOn: aWriteStream.
	byteStream writeOn: aWriteStream
]

{ #category : #public }
ODBSerializer class >> serializeToBytes: anObject [ 
	"Serialize anObject to bytes."

	| classManager byteStream byteStream2 |
	classManager := ODBClassManagerForSerialization new initializeForSerialization.
	byteStream := ODBMemoryWriteStream new.
	self new 
		serialize: anObject
		onStream: byteStream
		referenceManager: nil
		classManager: classManager.
	byteStream2 := ODBMemoryWriteStream new.
	"brez reference manager-ja"
	byteStream2 putPositiveInteger: 0.
	classManager saveOnStream: byteStream2.
	^byteStream2 asByteArray , byteStream asByteArray
]

{ #category : #public }
ODBSerializer >> addExternalReference: anObject objectId: anObjectId [ 
	"Adds anObject as externaly referenced object.
	If this anObject is encountered during the serialization it will be replaced with an external reference to anObjectId and will not be serialized together."

	| dict |
	(dict := externalObjects at: anObject class) isNil 
		ifTrue: [dict := externalObjects at: anObject class put: anObject class odbGetRegDictionary].
	dict at: anObject put: anObjectId
]

{ #category : #private }
ODBSerializer >> cantSave: anObject [ 
	anObject class name , ' can''t be stored!' odbSerialize: self
]

{ #category : #private }
ODBSerializer >> initialize [

	externalObjects := ODBIdentityDictionary new: 127
]

{ #category : #private }
ODBSerializer >> register: anObject [ 
	| class dict id |
	(dict := objects at: (class := anObject class)) isNil 
		ifTrue: 
			[(objects at: class put: class odbGetRegDictionary) at: anObject
				put: (counter := counter + 1).
			anObject == mainObject ifTrue: [^false].
			(dict := externalObjects at: class) isNil 
				ifFalse: 
					[(id := dict at: anObject) isNil 
						ifFalse: 
							[self saveExternalReference: id.
							^true]].
			^false].
	(id := dict at: anObject ifAbsentPutValue: counter + 1) > counter 
		ifTrue: 
			[counter := id.
			anObject == mainObject 
				ifFalse: 
					[(dict := externalObjects at: class) isNil 
						ifFalse: 
							[(id := dict at: anObject) isNil 
								ifFalse: 
									[self saveExternalReference: id.
									^true]]].
			^false].
	self saveInternalReference: id.
	^true
]

{ #category : #private }
ODBSerializer >> registerClass: class [ 
	| index classInfo |
	(index := classes at: class) isNil 
		ifTrue: 
			[classInfo := classManager register: class.
			stream
				putByte: 2;
				putPositiveInteger: classInfo classID.
			classCollection add: classInfo.
			classes at: class put: (classesCounter := classesCounter + 1).
			^classInfo].
	stream
		putByte: 3;
		putPositiveInteger: index.
	classInfo := classCollection at: index.
	^classInfo
]

{ #category : #private }
ODBSerializer >> saveExternalReference: anObjectId [ 
	stream
		putByte: 5;
		putPositiveInteger: (referenceManager addReference: anObjectId)
]

{ #category : #private }
ODBSerializer >> saveInternalReference: anInteger [
		"Shrani referenco na interni objekt z indeksom anInteger."

	stream putByte: 4; putPositiveInteger: anInteger
]

{ #category : #public }
ODBSerializer >> serialize: anObject
	onStream: aStream
	referenceManager: aReferenceManager
	classManager: aClassManager [

	| startPos endPos |
	stream := aStream.
	referenceManager := aReferenceManager.
	classManager := aClassManager.
	mainObject := anObject.
	classes := ODBIdentityDictionary new: 31.
	objects := ODBIdentityDictionary new: 63.
	counter := 0.
	classesCounter := 0.
	classCollection := OrderedCollection new: 30.
	startPos := stream position.
	stream putLong: 0.

	mainObject odbSerialize: self.

	endPos := stream position.
	stream
		position: startPos;
		putLong: counter;
		position: endPos.
]

{ #category : #public }
ODBSerializer >> serializeToBytes: anObject [ 
	| byteStream2 |
	self 
		serialize: anObject
		onStream: ODBMemoryWriteStream new
		referenceManager: ODBReferenceManager new
		classManager: ODBClassManagerForSerialization new initializeForSerialization.
	byteStream2 := ODBMemoryWriteStream new.
	referenceManager saveOnStream: byteStream2.
	classManager saveOnStream: byteStream2.
	^byteStream2 asByteArray , stream asByteArray
]

{ #category : #public }
ODBSerializer >> stream [

    ^stream
]
