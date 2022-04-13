Class {
	#name : #ODBDeserializer,
	#superclass : #Object,
	#instVars : [
		'classArray',
		'classes',
		'classesCounter',
		'classManager',
		'counter',
		'objects',
		'stream',
		'referenceManager',
		'transaction'
	],
	#classInstVars : [
		'classArray'
	],
	#category : #'OmniBase-Serializers'
}

{ #category : #private }
ODBDeserializer class >> classArray [

	^classArray ifNil: [ self init ]
]

{ #category : #public }
ODBDeserializer class >> deserializeFromBytes: aByteArray [ 
	| memoryStream classManager |
	memoryStream := ODBMemoryStreamWrapper on: aByteArray readStream.
	memoryStream getPositiveInteger = 0 
		ifFalse: [self error: 'External references not defined'].
	classManager := ODBClassManagerForSerialization new.
	classManager loadFromStream: memoryStream.
	^self new 
		deserializeFrom:  (ODBEncodingStream on: memoryStream)
		referenceManager: nil
		classManager: classManager
]

{ #category : #public }
ODBDeserializer class >> deserializeFromBytes: aByteArray externalReferencesLoaderBlock: aBlock [ 
	| memoryStream referenceManager classManager |
	memoryStream := ODBMemoryStreamWrapper on: aByteArray readStream.
	referenceManager := ODBReferenceManager new.
	referenceManager loadFromStream: memoryStream externalReferencesLoaderBlock: aBlock.
	classManager := ODBClassManagerForSerialization new.
	classManager loadFromStream: memoryStream.
	^self new 
		deserializeFrom: memoryStream
		referenceManager: referenceManager
		classManager: classManager
]

{ #category : #private }
ODBDeserializer class >> init [
	<script>

	classArray := Array new: 255.
	classArray
		at: 2 put: ODBNewObjectNewClass;
		at: 3 put: ODBNewObject;
		at: 4 put: ODBExistingObject;
		at: 5 put: ODBExternalReference;
		at: 6 put: ODBClassManagerForSerialization;
		at: 10 put: nil;
		at: 11 put: ODBLargePositiveInteger;
		at: 12 put: ODBLargeNegativeInteger;
		at: 13 put: Character;
		at: 14 put: UndefinedObject;
		at: 15 put: true;
		at: 16 put: false;
		at: 17 put: Message;
		at: 18 put: Symbol;
		at: 19 put: Smalltalk globals;
		at: 20 put: MessageSend;
		at: 22 put: Processor;
		at: 26 put: Class;
		at: 29 put: ODBDoubleByteCharacter;
		at: 31 put: Association;
		at: 32 put: Date;
		at: 33 put: Time;
		at: 34 put: String;
		at: 35 put: Array;
		at: 36 put: WideString;
		at: 37 put: Dictionary;
		at: 38 put: IdentityDictionary;
		at: 39 put: Fraction;
		at: 40 put: Float;
		at: 41 put: (ODBCopyValue value: 0.0);
		at: 42 put: (ODBCopyValue value: 1.0);
		at: 43 put: ODBFloatAsInteger;
		at: 44 put: ODBFloatAs100Integer;
		at: 45 put: ScaledDecimal;
		at: 46 put: Float;
		at: 47 put: SmallFloat64;
	
		at: 50 put: 0;
		at: 51 put: 1;
		at: 52 put: 2;
		at: 53 put: 3;
		at: 54 put: 4;
		at: 55 put: 5;
		at: 56 put: 6;
		at: 57 put: 7;
		at: 58 put: 8;
		at: 59 put: 9;
		at: 60 put: 10;
		at: 61 put: 11;
		at: 62 put: 12;
		at: 63 put: 13;
		at: 64 put: 14;
		at: 65 put: 15;
		at: 66 put: 16;
		at: 67 put: -3;
		at: 68 put: -2;
		at: 69 put: -1;
		at: 70 put: ODBEmptyString;
		at: 71 put: ODB1CharacterString;
		at: 72 put: (ODBnCharacterString length: 2);
		at: 73 put: (ODBnCharacterString length: 3);
		at: 74 put: (ODBnCharacterString length: 4);
		at: 75 put: (ODBnCharacterString length: 5);
		at: 76 put: (ODBnCharacterString length: 6);
		at: 77 put: (ODBnCharacterString length: 7);
		at: 78 put: (ODBnCharacterString length: 8);
		at: 79 put: (ODBnCharacterString length: 9);
		at: 80 put: ByteArray;
		at: 81 put: OrderedCollection;
		at: 82 put: ODBIdentityDictionary;
		at: 83 put: ODBPersistentDictionary;
		at: 84 put: ODBTransaction.
	^classArray
]

{ #category : #public }
ODBDeserializer >> deserializeFrom: aStream referenceManager: aReferenceManager classManager: aClassManager [ 
	stream := aStream readerWriter: self.
	referenceManager := aReferenceManager.
	classManager := aClassManager.
	classArray := self class classArray.
	objects := Array new: stream primitive getLong.
	classes := OrderedCollection new: 30.
	counter := 0.
	classesCounter := 0.
	^self odbNextObject
]

{ #category : #public }
ODBDeserializer >> deserializeFrom: aStream
	referenceManager: aReferenceManager
	transaction: aTransaction [

	stream := aStream readerWriter: self.
	referenceManager := aReferenceManager.
	classManager := aTransaction environment classManager.
	transaction := aTransaction.
	classArray := self class classArray.
	objects := Array new: stream primitive getLong.
	classes := OrderedCollection new: 30.
	counter := 0.
	classesCounter := 0.
	^self odbNextObject
]

{ #category : #private }
ODBDeserializer >> existingObject [

	^ objects at: stream primitive getPositiveInteger
]

{ #category : #private }
ODBDeserializer >> loadError [
	| id |
	stream primitive position: stream primitive position - 1.
	id := stream primitive getByte.
	OmniBase 
		signalError: 'OmniBase deserializer: Unknown serialization id (' , id printString , ')'
]

{ #category : #private }
ODBDeserializer >> loadReference [

	^self register: (referenceManager referenceAt: stream primitive getPositiveInteger)
]

{ #category : #private }
ODBDeserializer >> newObjectNewClass [
	| classInfo |
	classInfo := classManager classDescriptionAt: stream primitive getPositiveInteger.
	classesCounter := classesCounter + 1.
	classes add: classInfo.
	^classInfo realClass odbLoadVariables: self classInfo: classInfo
]

{ #category : #private }
ODBDeserializer >> newObjectOldClass [

	| classInfo |
	^(classInfo := classes at: stream primitive getPositiveInteger) realClass
		odbLoadVariables: self
		classInfo: classInfo
]

{ #category : #private }
ODBDeserializer >> odbNextObject [

	^(classArray at: stream primitive getByte) odbDeserialize: self
]

{ #category : #private }
ODBDeserializer >> register: anObject [

	^objects at: (counter := counter + 1) put: anObject
]

{ #category : #public }
ODBDeserializer >> stream [

	^stream
]

{ #category : #private }
ODBDeserializer >> transaction [

	^transaction
]
