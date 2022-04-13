Class {
	#name : #ODBEncodingStream,
	#superclass : #Object,
	#instVars : [
		'stream',
		'readerWriter'
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
ODBEncodingStream class >> characterEncoder [
	^ characterEncoder
]

{ #category : #accessing }
ODBEncodingStream class >> characterEncoding: aString [
	characterEncoder := aString asZnCharacterEncoder
]

{ #category : #convenience }
ODBEncodingStream class >> decodeBytes: aByteArray [ 
	^ characterEncoder decodeBytes: aByteArray 
]

{ #category : #convenience }
ODBEncodingStream class >> encodeString: aString [ 
	^ characterEncoder encodeString: aString
]

{ #category : #initialization }
ODBEncodingStream class >> initialize [ 
	self initializeTypeCodeMapping.
	self initializeEncoding 
]

{ #category : #initialization }
ODBEncodingStream class >> initializeEncoding [
	"see ZnUTFEncoder knownEncodingIdentifiers for all supported encodings"
	self characterEncoding: #utf8
]

{ #category : #initialization }
ODBEncodingStream class >> initializeTypeCodeMapping [
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
		"legacy double entry with type code 46?"
		at: 40                                   put: Float;
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
ODBEncodingStream class >> on: aStream [ 
	^ self new 
		stream: aStream
]

{ #category : #'initialize-release' }
ODBEncodingStream >> close [
	stream ifNotNil: [
		stream close.
		stream := nil ]
]

{ #category : #finalization }
ODBEncodingStream >> finalize [
	self close
]

{ #category : #finalization }
ODBEncodingStream >> flush [
	"Force all data written to the 
	receiver to be recorded on disk."

	stream flush
]

{ #category : #public }
ODBEncodingStream >> getBytesFor: aByteCollection len: len [ 
	"Read len bytes from stream to aByteCollection. 
	Answer number of bytes actualy read."
	
	^ stream getBytesFor: aByteCollection len: len 
]

{ #category : #accessing }
ODBEncodingStream >> lockAt: position length: length [ 

	^ stream lockAt: position length: length 
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextArray: aDeserializer [ 
	| array |
	array := Array new: stream getPositiveInteger.
	aDeserializer register: array.
	1 to: array size do: [:i | array at: i put: aDeserializer odbNextObject ].
	^array
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextAssociation: aDeserializer [ 
	| result |
	readerWriter register: (result := Association new).
	^result
		key: readerWriter odbNextObject;
		value: readerWriter odbNextObject
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextByteArray: aDeserializer [
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
ODBEncodingStream >> nextCharacter: aDeserializer [ 
	^ stream getChar
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextClass: aDeserializer [ 
	^ Smalltalk 
		at: stream getString asSymbol 
		ifAbsent: nil
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextDate: aDeserializer [ 
	^ aDeserializer register: (Date 
		odbDateFromSeconds: stream getInteger 
		offset: stream getInteger) 
		
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextDictionary: aDeserializer [
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
ODBEncodingStream >> nextDictionary: aDeserializer class: aClass [
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
ODBEncodingStream >> nextDoubleByteCharacter: aDeserializer [ 
	^ Character value: stream getWord
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextFloatAs100Integer: deserializer [ 

    ^ stream getInteger / 100.0
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextFloatAsInteger: deserializer [ 

    ^ stream getInteger asFloat
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextFraction: aDeserializer [ 
	^ Fraction 
		numerator: stream getInteger
		denominator: stream getInteger
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextIdentityDictionary: aDeserializer [ 
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
ODBEncodingStream >> nextIdentityDictionary: anODBDeserializer class: aClass [ 
	| size dict |
	size := stream getPositiveInteger.
	dict := aClass new: size.
	readerWriter register: dict.
	size timesRepeat: [
		dict 
			at: readerWriter odbNextObject
			put: readerWriter odbNextObject].
	^dict
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextLargeNegativeInteger: aDeserializer [ 
	^ 0 - stream getPositiveInteger
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextLargePositiveInteger: aDeserializer [ 
	^ stream getPositiveInteger
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextMessage: aDeserializer [ 
	| result |
	readerWriter register: (result := Message new).
	^ result
		setSelector: readerWriter odbNextObject arguments: readerWriter odbNextObject;
		yourself
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextMessageSend: aDeserializer [ 
	| result |
	readerWriter register: (result := MessageSend new).
	^result
		receiver: readerWriter odbNextObject;
		selector: readerWriter odbNextObject;
		arguments: readerWriter odbNextObject;
		yourself
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextODBIdentityDictionary: anODBDeserializer class: aClass [ 
	| size dict key |
	size := stream getPositiveInteger.
	dict := aClass new: size.
	readerWriter register: dict.
	size timesRepeat: 
			[key := readerWriter odbNextObject.
			dict at: key put: readerWriter odbNextObject].
	^dict
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextOneCharacterString: aDeserializer [ 
	^ stream getChar asString
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextOrderedCollection: aDeserializer [ 
	| coll size |
	size := stream getPositiveInteger.
	aDeserializer register: (coll := OrderedCollection new: size).
	size timesRepeat: [ coll addLast: aDeserializer odbNextObject ].
	^coll
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextPersistentDictionary: aDeserializer [
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
ODBEncodingStream >> nextPutArray: anArray [
	stream 
		putByte: ODBArrayCode; 
		putPositiveInteger: anArray size.
	1 to: anArray size do: [:i | 
		(anArray at: i) odbSerialize: readerWriter ].
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextPutAssociation: anAssociation [ 
	stream putByte: ODBAssociationCode.
	anAssociation key odbSerialize: readerWriter.
	anAssociation value odbSerialize: readerWriter.
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextPutBoxedFloat64: aNumber [ 
	stream
		putByte: ODBFloatCode;
		putInteger: (aNumber at: 1);
		putInteger: (aNumber at: 2)
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextPutByteArray: aByteArray [
	stream 
		putByte: ODBByteArrayCode; 
		putPositiveInteger: aByteArray size.
	1 to: aByteArray size do: [:i |
		stream putByte: (aByteArray at: i)].
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextPutCharacter: aCharacter [ 
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
ODBEncodingStream >> nextPutClass: aClass [ 
	stream 
		putByte: ODBClassCode; 
		putString: aClass name asString
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextPutDate: aDate [ 
	stream 
		putByte: ODBDateCode; 
		putInteger: aDate julianDayNumber - 2415386; 
		putInteger: aDate offset hours
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextPutDictionary: aDictionary [
	aDictionary class == Dictionary ifFalse: [ ^ super odbBasicSerialize: readerWriter ].
	stream 
		putByte: ODBDictionaryCode;
		putPositiveInteger: aDictionary size.
	aDictionary keysAndValuesDo: [:key :value |
		key odbSerialize: readerWriter.
		value odbSerialize: readerWriter ]
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextPutExternalReference: anObjectID [ 
	stream
		putByte: ODBExternalReferenceCode;
		putPositiveInteger: anObjectID 
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextPutFalse: aBoolean [ 
	stream putByte: ODBFalseCode
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextPutFraction: aNumber [ 
	stream
		putByte: ODBFractionCode;
		putInteger: aNumber numerator;
		putInteger: aNumber denominator
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextPutIdentityDictionary: anIdentityDictionary [ 
	anIdentityDictionary class == IdentityDictionary ifFalse: [ ^super odbBasicSerialize: readerWriter ].
	stream 
		putByte: ODBIdentityDictionaryCode;
		putPositiveInteger: anIdentityDictionary size.
	anIdentityDictionary keysAndValuesDo: [:key :value |
		key odbSerialize: readerWriter.
		value odbSerialize: readerWriter ]
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextPutInteger: anInteger [ 
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
ODBEncodingStream >> nextPutInternalReference: anInteger [ 
	stream
		putByte: ODBInternalReference;
		putPositiveInteger: anInteger
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextPutMessage: aMessage [ 
	(aMessage class == Message) 
		ifFalse: [ ^ super odbBasicSerialize: readerWriter ].
 	stream putByte: ODBMessageCode.
	aMessage selector odbSerialize: readerWriter.
	aMessage arguments odbSerialize: readerWriter
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextPutMessageSend: aMessageSend [ 
	(aMessageSend class == MessageSend) 
		ifFalse: [ ^ super odbBasicSerialize: readerWriter ].
	stream putByte: ODBMessageSendCode.
	aMessageSend receiver odbSerialize: readerWriter.
	aMessageSend selector odbSerialize: readerWriter.
	aMessageSend arguments odbSerialize: readerWriter
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextPutNil: anUndefinedObject [ 
	stream putByte: ODBUndefinedObjectCode 
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextPutOrderedCollection: aCollection [ 
	stream
		putByte: ODBOrderedCollectionCode;
		putPositiveInteger: aCollection size.
	aCollection do: [:each | each odbSerialize: readerWriter ].
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextPutPersistentDictionary: aPersistentDictionary [
	stream
		putByte: ODBPersistentDictionaryCode;
		putPositiveInteger: aPersistentDictionary size.
	aPersistentDictionary keysAndValuesDo: [:key :value | 
		key odbSerialize: readerWriter.
		value odbSerialize: readerWriter ]
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextPutProcessorScheduler: aProcessorScheduler [ 
	stream putByte: ODBProcessSchedulerCode 
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextPutSmallFloat64: aNumber [ 
	stream
		putByte: ODBSmallFloat64Code;
		putInteger: (aNumber at: 1);
		putInteger: (aNumber at: 2)  
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextPutString: aString [ 
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
ODBEncodingStream >> nextPutSymbol: aSymbol [ 
	stream
		putByte: ODBSymbolCode;
		putPositiveInteger: aSymbol size;
		putBytesFrom: aSymbol asByteArray len: aSymbol size
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextPutSystemDictionary: aCollection [ 
	stream putByte: ODBSystemDictionaryCode 
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextPutTime: aTime [ 
	stream
		putByte: ODBTimeCode;
		putPositiveInteger: aTime asSeconds
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextPutTransaction: aTransaction [ 
	stream putByte: ODBTransactionCode 
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextPutTrue: aBoolean [ 
	stream putByte: ODBTrueCode
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextPutWideString: aWideString [
	| buf |
	buf := self class encodeString: aWideString.
	stream
		putByte: ODBWideStringCode;
		putPositiveInteger: buf size;
		putBytesFrom: buf len: buf size
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextSmallFloat64: aDeserializer [ 
	^ BoxedFloat64 basicNew
		  at: 1 put: stream getInteger;
		  at: 2 put: stream getInteger;
		  * 1
]

{ #category : #actions }
ODBEncodingStream >> nextString [
	| buf len |
	buf := ByteArray new: (len := stream getPositiveInteger).
	stream getBytesFor: buf len: len.
	^  buf asString
]

{ #category : #actions }
ODBEncodingStream >> nextString: aDeserializer [
	| buf len string |
	buf := ByteArray new: (len := stream getPositiveInteger).
	stream getBytesFor: buf len: len.
	string := buf asString.
	aDeserializer register: string.
	^ string

]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextSymbol: aDeserializer [ 
	| bytes len |
	bytes := ByteArray new: (len := stream getPositiveInteger).
	stream getBytesFor: bytes len: len.
	^ bytes asString asSymbol
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextTime: aDeserializer [ 
	^ aDeserializer register: (Time fromSeconds: stream getPositiveInteger)
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextWideString: aDeserializer [ 
	| buf len |
	buf := ByteArray new: (len := stream getPositiveInteger).
	stream getBytesFor: buf len: len.
	^ aDeserializer register: (self class decodeBytes: buf)
]

{ #category : #'as yet unclassified' }
ODBEncodingStream >> nextnCharacterString: aDeserializer size: size [
	    | buf |
   stream getBytesFor: (buf := ByteArray new: size) len: size.
    ^ readerWriter register: buf asString
]

{ #category : #accessing }
ODBEncodingStream >> position: anInteger [ 
	^ stream position: anInteger 
]

{ #category : #accessing }
ODBEncodingStream >> primitive [
	^ stream 
]

{ #category : #public }
ODBEncodingStream >> putBytesFrom: aByteCollection len: len [ 
	"Write len bytes from aByteCollection to file."

	stream putBytesFrom: aByteCollection len: len
]

{ #category : #accessing }
ODBEncodingStream >> readerWriter: anODBSerializer [ 
	readerWriter := anODBSerializer 
]

{ #category : #removing }
ODBEncodingStream >> remove [
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
ODBEncodingStream >> size [
	^ stream size
]

{ #category : #accessing }
ODBEncodingStream >> stream: aStream [ 
	stream := aStream
]

{ #category : #accessing }
ODBEncodingStream >> truncate: anInteger [ 
	"Truncate stream so that its size will be anInteger. 
	Position to anInteger."

	stream truncate: anInteger 
]

{ #category : #accessing }
ODBEncodingStream >> unlockAt: position length: length [

	^ stream unlockAt: position length: length 
]
