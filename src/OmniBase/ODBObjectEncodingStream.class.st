Class {
	#name : #ODBObjectEncodingStream,
	#superclass : #Object,
	#instVars : [
		'stream',
		'desy'
	],
	#pools : [
		'ODBTypeCodes'
	],
	#classInstVars : [
		'typeCodeMapping',
		'characterEncoder'
	],
	#category : #'OmniBase-Streams'
}

{ #category : #accessing }
ODBObjectEncodingStream class >> characterEncoder [
	^ characterEncoder
]

{ #category : #accessing }
ODBObjectEncodingStream class >> characterEncoding: aString [
	characterEncoder := aString asZnCharacterEncoder
]

{ #category : #convenience }
ODBObjectEncodingStream class >> decodeBytes: aByteArray [ 
	^ characterEncoder decodeBytes: aByteArray 
]

{ #category : #convenience }
ODBObjectEncodingStream class >> encodeString: aString [ 
	^ characterEncoder encodeString: aString
]

{ #category : #initialization }
ODBObjectEncodingStream class >> initialize [ 
	self initializeTypeCodeMapping.
	self initializeEncoding 
]

{ #category : #initialization }
ODBObjectEncodingStream class >> initializeEncoding [
	"see ZnUTFEncoder knownEncodingIdentifiers for all supported encodings"
	self characterEncoding: #utf8
]

{ #category : #initialization }
ODBObjectEncodingStream class >> initializeTypeCodeMapping [
	<script>

	typeCodeMapping := Array new: 255.
	typeCodeMapping
		at: 2                                    put: ODBNewObjectNewClass;
		at: 3                                    put: ODBNewObject;
		at: ODBInternalReference                 put: ODBExistingObject;
		at: ODBExternalReferenceCode             put: ODBExternalReference;
		at: 6                                    put: ODBClassManagerForSerialization;
		at: ODBNilCode                           put: nil;
		at: ODBLargePositiveIntegerCode          put: ODBLargePositiveInteger;
		at: ODBLargeNegativeIntegerCode          put: ODBLargeNegativeInteger;
		at: ODBCharacterCode                     put: Character;
		at: ODBUndefinedObjectCode               put: UndefinedObject;
		at: ODBTrueCode                          put: true;
		at: ODBFalseCode                         put: false;
		at: ODBMessageCode                       put: Message;
		at: ODBSymbolCode                        put: Symbol;
		at: ODBSystemDictionaryCode              put: Smalltalk globals;
		at: ODBMessageSendCode                   put: MessageSend;
		at: ODBProcessSchedulerCode              put: Processor;
		at: ODBClassCode                         put: Class;
		at: ODBDoubleByteCharacterCode           put: ODBDoubleByteCharacter;
		at: ODBAssociationCode                   put: Association;
		at: ODBDateCode                          put: Date;
		at: ODBTimeCode                          put: Time;
		at: ODBStringCode                        put: String;
		at: ODBArrayCode                         put: Array;
		at: ODBWideStringCode                    put: WideString;
		at: ODBDictionaryCode                    put: Dictionary;
		at: ODBIdentityDictionaryCode            put: IdentityDictionary;
		at: ODBFractionCode                      put: Fraction;
		at: ODBFloatCode                         put: Float;
		at: ODBFloatValue0                       put: (ODBCopyValue value: 0.0);
		at: ODBFloatValue1                       put: (ODBCopyValue value: 1.0);
		at: ODBFloatAsIntegerCode                put: ODBFloatAsInteger;
		at: ODBFloatAs100IntegerCode             put: ODBFloatAs100Integer;
		at: ODBScaledDecimalCode                 put: ScaledDecimal;
		at: ODBFloatCode                         put: Float;
		at: ODBSmallFloat64Code                  put: SmallFloat64;
	
		at: ODBSmallPositiveIntegerBaseCode      put: 0;
		at: ODBSmallPositiveIntegerBaseCode + 1  put: 1;
		at: ODBSmallPositiveIntegerBaseCode + 2  put: 2;
		at: ODBSmallPositiveIntegerBaseCode + 3  put: 3;
		at: ODBSmallPositiveIntegerBaseCode + 4  put: 4;
		at: ODBSmallPositiveIntegerBaseCode + 5  put: 5;
		at: ODBSmallPositiveIntegerBaseCode + 6  put: 6;
		at: ODBSmallPositiveIntegerBaseCode + 7  put: 7;
		at: ODBSmallPositiveIntegerBaseCode + 8  put: 8;
		at: ODBSmallPositiveIntegerBaseCode + 9  put: 9;
		at: ODBSmallPositiveIntegerBaseCode + 10 put: 10;
		at: ODBSmallPositiveIntegerBaseCode + 11 put: 11;
		at: ODBSmallPositiveIntegerBaseCode + 12 put: 12;
		at: ODBSmallPositiveIntegerBaseCode + 13 put: 13;
		at: ODBSmallPositiveIntegerBaseCode + 14 put: 14;
		at: ODBSmallPositiveIntegerBaseCode + 15 put: 15;
		at: ODBSmallPositiveIntegerBaseCode + 16 put: 16;
		at: ODBMinusThreeCode                    put: -3;
		at: ODBMinusTwo                          put: -2;
		at: ODBMinusOne                          put: -1;
		at: ODBSmallStringBaseCode               put: ODBEmptyString;
		at: ODBSmallStringBaseCode + 1           put: ODB1CharacterString;
		at: ODBSmallStringBaseCode + 2           put: (ODBnCharacterString length: 2);
		at: ODBSmallStringBaseCode + 3           put: (ODBnCharacterString length: 3);
		at: ODBSmallStringBaseCode + 4           put: (ODBnCharacterString length: 4);
		at: ODBSmallStringBaseCode + 5           put: (ODBnCharacterString length: 5);
		at: ODBSmallStringBaseCode + 6           put: (ODBnCharacterString length: 6);
		at: ODBSmallStringBaseCode + 7           put: (ODBnCharacterString length: 7);
		at: ODBSmallStringBaseCode + 8           put: (ODBnCharacterString length: 8);
		at: ODBSmallStringBaseCode + 9           put: (ODBnCharacterString length: 9);
		at: ODBByteArrayCode                     put: ByteArray;
		at: ODBOrderedCollectionCode             put: OrderedCollection;
		at: ODBODBIdentityDictionaryCode         put: ODBIdentityDictionary;
		at: ODBPersistentDictionaryCode          put: ODBPersistentDictionary;
		at: ODBTransactionCode                   put: ODBTransaction.
]

{ #category : #'instance creation' }
ODBObjectEncodingStream class >> on: aStream [ 
	^ self new 
		stream: aStream
]

{ #category : #'initialize-release' }
ODBObjectEncodingStream >> close [
	stream ifNotNil: [
		stream close.
		stream := nil ]
]

{ #category : #accessing }
ODBObjectEncodingStream >> desy: anODBSerializer [ 
	desy := anODBSerializer 
]

{ #category : #finalization }
ODBObjectEncodingStream >> finalize [
	self close
]

{ #category : #finalization }
ODBObjectEncodingStream >> flush [
	"Force all data written to the 
	receiver to be recorded on disk."

	stream flush
]

{ #category : #public }
ODBObjectEncodingStream >> getBytesFor: aByteCollection len: len [ 
	"Read len bytes from stream to aByteCollection. 
	Answer number of bytes actualy read."
	
	^ stream getBytesFor: aByteCollection len: len 
]

{ #category : #accessing }
ODBObjectEncodingStream >> lockAt: position length: length [ 

	^ stream lockAt: position length: length 
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextArray: aDeserializer [ 
	| array |
	array := Array new: stream getPositiveInteger.
	aDeserializer register: array.
	1 to: array size do: [:i | array at: i put: aDeserializer odbNextObject ].
	^array
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextAssociation: aDeserializer [ 
	| result |
	desy register: (result := Association new).
	^result
		key: desy odbNextObject;
		value: desy odbNextObject
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextByteArray: aDeserializer [
	| array |
	array := ByteArray new: stream getPositiveInteger.
	aDeserializer register: array.
	1 to: array size do: [:i | 
		array 
			at: i 
			put: stream getPositiveInteger ].
	^array
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextCharacter: aDeserializer [ 
	^ stream getChar
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextClass: aDeserializer [ 
	^ Smalltalk 
		at: stream getString asSymbol 
		ifAbsent: nil
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextDate: aDeserializer [ 
	^ aDeserializer register: (Date 
		odbDateFromSeconds: stream getInteger 
		offset: stream getInteger) 
		
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextDictionary: aDeserializer [
	| size dict key |
	size := stream getPositiveInteger.
	dict := Dictionary new: size.
	aDeserializer register: dict.
	size timesRepeat: [
		key := aDeserializer odbNextObject.
		dict at: key put: aDeserializer odbNextObject.
	].
	^dict
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextDictionary: aDeserializer class: aClass [
	| size dict key |
	size := stream getPositiveInteger.
	dict := aClass new: size.
	aDeserializer register: dict.
	size timesRepeat: [
		key := aDeserializer odbNextObject.
		dict at: key put: aDeserializer odbNextObject.
	].
	^dict
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextDoubleByteCharacter: aDeserializer [ 
	^ Character value: stream getWord
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextFloatAs100Integer: deserializer [ 

    ^ stream getInteger / 100.0
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextFloatAsInteger: deserializer [ 

    ^ stream getInteger asFloat
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextFraction: aDeserializer [ 
	^ Fraction 
		numerator: stream getInteger
		denominator: stream getInteger
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextIdentityDictionary: aDeserializer [ 
	| size dict key |
	size := stream getPositiveInteger.
	dict := self new: size.
	aDeserializer register: dict.
	size timesRepeat: 
			[key := aDeserializer odbNextObject.
			dict at: key put: aDeserializer odbNextObject].
	^dict
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextIdentityDictionary: anODBDeserializer class: aClass [ 
	| size dict |
	size := stream getPositiveInteger.
	dict := aClass new: size.
	desy register: dict.
	size timesRepeat: [
		dict 
			at: desy odbNextObject
			put: desy odbNextObject].
	^dict
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextLargeNegativeInteger: aDeserializer [ 
	^ 0 - stream getPositiveInteger
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextLargePositiveInteger: aDeserializer [ 
	^ stream getPositiveInteger
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextMessage: aDeserializer [ 
	| result |
	desy register: (result := Message new).
	^ result
		setSelector: desy odbNextObject arguments: desy odbNextObject;
		yourself
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextMessageSend: aDeserializer [ 
	| result |
	desy register: (result := MessageSend new).
	^result
		receiver: desy odbNextObject;
		selector: desy odbNextObject;
		arguments: desy odbNextObject;
		yourself
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextODBIdentityDictionary: anODBDeserializer class: aClass [ 
	| size dict key |
	size := stream getPositiveInteger.
	dict := aClass new: size.
	desy register: dict.
	size timesRepeat: 
			[key := desy odbNextObject.
			dict at: key put: desy odbNextObject].
	^dict
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextOneCharacterString: aDeserializer [ 
	^ stream getChar asString
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextOrderedCollection: aDeserializer [ 
	| coll size |
	size := stream getPositiveInteger.
	aDeserializer register: (coll := OrderedCollection new: size).
	size timesRepeat: [ coll addLast: aDeserializer odbNextObject ].
	^coll
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextPersistentDictionary: aDeserializer [
		| size dict key |
	size := stream getPositiveInteger.
	dict := ODBPersistentDictionary new: size.
	aDeserializer register: dict.
	size timesRepeat: 
			[key := aDeserializer odbNextObject.
			dict superAt: key put: aDeserializer odbNextObject].
	^dict
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextPutArray: anArray [
	stream 
		putByte: ODBArrayCode; 
		putPositiveInteger: anArray size.
	1 to: anArray size do: [:i | 
		(anArray at: i) odbSerialize: desy ].
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextPutAssociation: anAssociation [ 
	stream putByte: ODBAssociationCode.
	anAssociation key odbSerialize: desy.
	anAssociation value odbSerialize: desy.
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextPutBoxedFloat64: aNumber [ 
	stream
		putByte: ODBFloatCode;
		putInteger: (aNumber at: 1);
		putInteger: (aNumber at: 2)
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextPutByteArray: aByteArray [
	stream 
		putByte: ODBByteArrayCode; 
		putPositiveInteger: aByteArray size.
	1 to: aByteArray size do: [:i |
		stream putByte: (aByteArray at: i)].
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextPutCharacter: aCharacter [ 
	aCharacter asInteger < 256 ifTrue: [
		stream 
			putByte: ODBCharacterCode; 
			putChar: aCharacter.
		^ aCharacter
	].
	stream 
		putByte: ODBDoubleByteCharacterCode; 
		putWord: aCharacter asInteger
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextPutClass: aClass [ 
	stream 
		putByte: ODBClassCode; 
		putString: aClass name asString
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextPutDate: aDate [ 
	stream 
		putByte: ODBDateCode; 
		putInteger: aDate julianDayNumber - 2415386; 
		putInteger: aDate offset hours
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextPutDictionary: aDictionary [
	aDictionary class == Dictionary ifFalse: [ ^ super odbBasicSerialize: desy ].
	stream 
		putByte: ODBDictionaryCode;
		putPositiveInteger: aDictionary size.
	aDictionary keysAndValuesDo: [:key :value |
		key odbSerialize: desy.
		value odbSerialize: desy ]
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextPutExternalReference: anObjectID [ 
	stream
		putByte: ODBExternalReferenceCode;
		putPositiveInteger: anObjectID 
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextPutFalse: aBoolean [ 
	stream putByte: ODBFalseCode
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextPutFraction: aNumber [ 
	stream
		putByte: ODBFractionCode;
		putInteger: aNumber numerator;
		putInteger: aNumber denominator
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextPutIdentityDictionary: anIdentityDictionary [ 
	anIdentityDictionary class == IdentityDictionary ifFalse: [ ^super odbBasicSerialize: desy ].
	stream 
		putByte: ODBIdentityDictionaryCode;
		putPositiveInteger: anIdentityDictionary size.
	anIdentityDictionary keysAndValuesDo: [:key :value |
		key odbSerialize: desy.
		value odbSerialize: desy ]
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextPutInteger: anInteger [ 
	anInteger < 0 ifTrue: [
		anInteger > -4 ifTrue: [ ^ stream putByte: anInteger + 70 ].
		^ stream 
			putByte: ODBLargeNegativeIntegerCode ; 
			putPositiveInteger: 0 - anInteger.
	].
	anInteger < 17 ifTrue: [ 
		^ stream putByte: anInteger + ODBSmallPositiveIntegerBaseCode  ].
	stream 
		putByte: ODBLargePositiveIntegerCode; 
		putPositiveInteger: anInteger
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextPutInternalReference: anInteger [ 
	stream
		putByte: ODBInternalReference;
		putPositiveInteger: anInteger
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextPutMessage: aMessage [ 
	(aMessage class == Message) 
		ifFalse: [ ^ super odbBasicSerialize: desy ].
 	stream putByte: ODBMessageCode.
	aMessage selector odbSerialize: desy.
	aMessage arguments odbSerialize: desy
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextPutMessageSend: aMessageSend [ 
	(aMessageSend class == MessageSend) 
		ifFalse: [ ^ super odbBasicSerialize: desy ].
	stream putByte: ODBMessageSendCode.
	aMessageSend receiver odbSerialize: desy.
	aMessageSend selector odbSerialize: desy.
	aMessageSend arguments odbSerialize: desy
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextPutNil: anUndefinedObject [ 
	stream putByte: ODBUndefinedObjectCode 
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextPutOrderedCollection: aCollection [ 
	stream
		putByte: ODBOrderedCollectionCode;
		putPositiveInteger: aCollection size.
	aCollection do: [:each | each odbSerialize: desy ].
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextPutPersistentDictionary: aPersistentDictionary [
	stream
		putByte: ODBPersistentDictionaryCode;
		putPositiveInteger: aPersistentDictionary size.
	aPersistentDictionary keysAndValuesDo: [:key :value | 
		key odbSerialize: desy.
		value odbSerialize: desy ]
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextPutProcessorScheduler: aProcessorScheduler [ 
	stream putByte: ODBProcessSchedulerCode 
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextPutSmallFloat64: aNumber [ 
	stream
		putByte: ODBSmallFloat64Code;
		putInteger: (aNumber at: 1);
		putInteger: (aNumber at: 2)  
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextPutString: aString [ 
		| buf |
	(buf := aString asByteArray) size < 10
		ifTrue: [
			^ stream
				putByte: ODBSmallStringBaseCode + buf size;
				putBytesFrom: buf len: buf size ].
	stream
		putByte: ODBStringCode;
		putPositiveInteger: buf size;
		putBytesFrom: buf len: buf size
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextPutSymbol: aSymbol [ 
	stream
		putByte: ODBSymbolCode;
		putPositiveInteger: aSymbol size;
		putBytesFrom: aSymbol asByteArray len: aSymbol size
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextPutSystemDictionary: aCollection [ 
	stream putByte: ODBSystemDictionaryCode 
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextPutTime: aTime [ 
	stream
		putByte: ODBTimeCode;
		putPositiveInteger: aTime asSeconds
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextPutTransaction: aTransaction [ 
	stream putByte: ODBTransactionCode 
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextPutTrue: aBoolean [ 
	stream putByte: ODBTrueCode
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextPutWideString: aWideString [
	| buf |
	buf := self class encodeString: aWideString.
	stream
		putByte: ODBWideStringCode;
		putPositiveInteger: buf size;
		putBytesFrom: buf len: buf size
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextSmallFloat64: aDeserializer [ 
	^ BoxedFloat64 basicNew
		  at: 1 put: stream getInteger;
		  at: 2 put: stream getInteger;
		  * 1
]

{ #category : #actions }
ODBObjectEncodingStream >> nextString [
	| buf len |
	buf := ByteArray new: (len := stream getPositiveInteger).
	stream getBytesFor: buf len: len.
	^  buf asString
]

{ #category : #actions }
ODBObjectEncodingStream >> nextString: aDeserializer [
	| buf len string |
	buf := ByteArray new: (len := stream getPositiveInteger).
	stream getBytesFor: buf len: len.
	string := buf asString.
	aDeserializer register: string.
	^ string

]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextSymbol: aDeserializer [ 
	| bytes len |
	bytes := ByteArray new: (len := stream getPositiveInteger).
	stream getBytesFor: bytes len: len.
	^ bytes asString asSymbol
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextTime: aDeserializer [ 
	^ aDeserializer register: (Time fromSeconds: stream getPositiveInteger)
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextWideString: aDeserializer [ 
	| buf len |
	buf := ByteArray new: (len := stream getPositiveInteger).
	stream getBytesFor: buf len: len.
	^ aDeserializer register: (self class decodeBytes: buf)
]

{ #category : #'as yet unclassified' }
ODBObjectEncodingStream >> nextnCharacterString: aDeserializer size: size [
	    | buf |
   stream getBytesFor: (buf := ByteArray new: size) len: size.
    ^ desy register: buf asString
]

{ #category : #accessing }
ODBObjectEncodingStream >> position: anInteger [ 
	^ stream position: anInteger 
]

{ #category : #accessing }
ODBObjectEncodingStream >> primitive [
	^ stream 
]

{ #category : #public }
ODBObjectEncodingStream >> putBytesFrom: aByteCollection len: len [ 
	"Write len bytes from aByteCollection to file."

	stream putBytesFrom: aByteCollection len: len
]

{ #category : #removing }
ODBObjectEncodingStream >> remove [
	"Close and remove receiver. Answer <true> if removed."
	| file |
	file := stream name asFileReference.
	self close.
	[ file delete ]
		on: Error 
		do: [:err | ^ false ].
	^ true
]

{ #category : #public }
ODBObjectEncodingStream >> size [
	^ stream size
]

{ #category : #accessing }
ODBObjectEncodingStream >> stream: aStream [ 
	stream := aStream
]

{ #category : #accessing }
ODBObjectEncodingStream >> truncate: anInteger [ 
	"Truncate stream so that its size will be anInteger. 
	Position to anInteger."

	stream truncate: anInteger 
]

{ #category : #accessing }
ODBObjectEncodingStream >> unlockAt: position length: length [

	^ stream unlockAt: position length: length 
]
