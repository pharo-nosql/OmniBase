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
		at: ODBFloatCode                         put: Float;
		at: ODBFloatValue0                       put: (ODBCopyValue value: 0.0);
		at: ODBFloatValue1                       put: (ODBCopyValue value: 1.0);
		at: ODBFloatAsIntegerCode                put: ODBFloatAsInteger;
		at: ODBFloatAs100IntegerCode             put: ODBFloatAs100Integer;
		at: ODBScaledDecimalCode                 put: ScaledDecimal;
		"legacy double entry with type code 40?"
		"at: ODBFloatCode                         put: Float;"
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

{ #category : #reading }
ODBEncodingStream >> nextArray: aClass [
	| array |
	array := aClass new: stream getPositiveInteger.
	readerWriter register: array.
	1 to: array size do: [:i | array at: i put: readerWriter odbNextObject ].
	^array
]

{ #category : #reading }
ODBEncodingStream >> nextAssociation: aClass [
	| result |
	readerWriter register: (result := aClass new).
	^result
		key: readerWriter odbNextObject;
		value: readerWriter odbNextObject
]

{ #category : #reading }
ODBEncodingStream >> nextByteArray: aClass [
	| array |
	array := aClass new: stream getPositiveInteger.
	readerWriter register: array.
	1 to: array size do: [:i | 
		array 
			at: i 
			put: stream getPositiveInteger ].
	^array
]

{ #category : #reading }
ODBEncodingStream >> nextCharacter [
	"call to #register: not needed as character is an immediate Object"
	^ stream getChar
]

{ #category : #reading }
ODBEncodingStream >> nextClass [
	^ Smalltalk 
		at: stream getString asSymbol 
		ifAbsent: nil
]

{ #category : #reading }
ODBEncodingStream >> nextDate: aClass [
	^ readerWriter register: (aClass 
		odbDateFromSeconds: stream getInteger 
		offset: stream getInteger)
]

{ #category : #reading }
ODBEncodingStream >> nextDictionary: aClass [
	| size dict key |
	size := stream getPositiveInteger.
	dict := aClass new: size.
	readerWriter register: dict.
	size timesRepeat: [
		key := readerWriter odbNextObject.
		dict at: key put: readerWriter odbNextObject.
	].
	^dict
]

{ #category : #reading }
ODBEncodingStream >> nextDoubleByteCharacter [
	"call to #register: not needed as character is an immediate Object"
	^ Character value: stream getWord
]

{ #category : #reading }
ODBEncodingStream >> nextFloatAs100Integer [

    ^ stream getInteger / 100.0
]

{ #category : #reading }
ODBEncodingStream >> nextFloatAsInteger [

    ^ stream getInteger asFloat
]

{ #category : #reading }
ODBEncodingStream >> nextFraction: aClass [
	^ aClass 
		numerator: stream getInteger
		denominator: stream getInteger
]

{ #category : #reading }
ODBEncodingStream >> nextLargeNegativeInteger [
	^ 0 - stream getPositiveInteger
]

{ #category : #reading }
ODBEncodingStream >> nextLargePositiveInteger [
	^ stream getPositiveInteger
]

{ #category : #reading }
ODBEncodingStream >> nextMessage: aClass [
	| result |
	readerWriter register: (result := aClass new).
	^ result
		setSelector: readerWriter odbNextObject arguments: readerWriter odbNextObject;
		yourself
]

{ #category : #reading }
ODBEncodingStream >> nextMessageSend: aClass [
	| result |
	readerWriter register: (result := aClass new).
	^result
		receiver: readerWriter odbNextObject;
		selector: readerWriter odbNextObject;
		arguments: readerWriter odbNextObject;
		yourself
]

{ #category : #reading }
ODBEncodingStream >> nextODBIdentityDictionary: aClass [ 
	| size dict key |
	size := stream getPositiveInteger.
	dict := aClass new: size.
	readerWriter register: dict.
	size timesRepeat: 
			[key := readerWriter odbNextObject.
			dict at: key put: readerWriter odbNextObject].
	^dict
]

{ #category : #reading }
ODBEncodingStream >> nextOneCharacterString [
	^  readerWriter register: stream getChar asString
]

{ #category : #reading }
ODBEncodingStream >> nextOrderedCollection: aClass [
	| coll size |
	size := stream getPositiveInteger.
	readerWriter register: (coll := aClass new: size).
	size timesRepeat: [ coll addLast: readerWriter odbNextObject ].
	^coll
]

{ #category : #reading }
ODBEncodingStream >> nextPersistentDictionary: aClass [
		| size dict |
	size := stream getPositiveInteger.
	dict := aClass new: size.
	readerWriter register: dict.
	size timesRepeat: [
		dict 
			superAt: readerWriter odbNextObject 
			put: readerWriter odbNextObject ].
	^dict
]

{ #category : #writing }
ODBEncodingStream >> nextPutArray: anArray [
	stream 
		putByte: ODBArrayCode; 
		putPositiveInteger: anArray size.
	1 to: anArray size do: [:i | 
		(anArray at: i) odbSerialize: readerWriter ].
]

{ #category : #writing }
ODBEncodingStream >> nextPutAssociation: anAssociation [ 
	stream putByte: ODBAssociationCode.
	anAssociation key odbSerialize: readerWriter.
	anAssociation value odbSerialize: readerWriter.
]

{ #category : #writing }
ODBEncodingStream >> nextPutBoxedFloat64: aNumber [ 
	stream
		putByte: ODBFloatCode;
		putInteger: (aNumber at: 1);
		putInteger: (aNumber at: 2)
]

{ #category : #writing }
ODBEncodingStream >> nextPutByteArray: aByteArray [
	stream 
		putByte: ODBByteArrayCode; 
		putPositiveInteger: aByteArray size.
	1 to: aByteArray size do: [:i |
		stream putByte: (aByteArray at: i)].
]

{ #category : #writing }
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

{ #category : #writing }
ODBEncodingStream >> nextPutClass: aClass [ 
	stream 
		putByte: ODBClassCode; 
		putString: aClass name asString
]

{ #category : #writing }
ODBEncodingStream >> nextPutDate: aDate [ 
	stream 
		putByte: ODBDateCode; 
		putInteger: aDate julianDayNumber - 2415386; 
		putInteger: aDate offset hours
]

{ #category : #writing }
ODBEncodingStream >> nextPutDictionary: aDictionary [
	stream 
		putByte: ODBDictionaryCode;
		putPositiveInteger: aDictionary size.
	aDictionary keysAndValuesDo: [:key :value |
		key odbSerialize: readerWriter.
		value odbSerialize: readerWriter ]
]

{ #category : #writing }
ODBEncodingStream >> nextPutExternalReference: anObjectID [ 
	stream
		putByte: ODBExternalReferenceCode;
		putPositiveInteger: anObjectID
]

{ #category : #writing }
ODBEncodingStream >> nextPutFalse: aBoolean [ 
	stream putByte: ODBFalseCode
]

{ #category : #writing }
ODBEncodingStream >> nextPutFraction: aNumber [ 
	stream
		putByte: ODBFractionCode;
		putInteger: aNumber numerator;
		putInteger: aNumber denominator
]

{ #category : #writing }
ODBEncodingStream >> nextPutIdentityDictionary: anIdentityDictionary [ 
	stream 
		putByte: ODBIdentityDictionaryCode;
		putPositiveInteger: anIdentityDictionary size.
	anIdentityDictionary keysAndValuesDo: [:key :value |
		key odbSerialize: readerWriter.
		value odbSerialize: readerWriter ]
]

{ #category : #writing }
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

{ #category : #writing }
ODBEncodingStream >> nextPutInternalReference: anInteger [ 
	stream
		putByte: ODBInternalReference;
		putPositiveInteger: anInteger
]

{ #category : #writing }
ODBEncodingStream >> nextPutMessage: aMessage [ 
 	stream putByte: ODBMessageCode.
	aMessage selector odbSerialize: readerWriter.
	aMessage arguments odbSerialize: readerWriter
]

{ #category : #writing }
ODBEncodingStream >> nextPutMessageSend: aMessageSend [ 
	stream putByte: ODBMessageSendCode.
	aMessageSend receiver odbSerialize: readerWriter.
	aMessageSend selector odbSerialize: readerWriter.
	aMessageSend arguments odbSerialize: readerWriter
]

{ #category : #writing }
ODBEncodingStream >> nextPutNil: anUndefinedObject [ 
	stream putByte: ODBUndefinedObjectCode
]

{ #category : #writing }
ODBEncodingStream >> nextPutOrderedCollection: aCollection [ 
	stream
		putByte: ODBOrderedCollectionCode;
		putPositiveInteger: aCollection size.
	aCollection do: [:each | each odbSerialize: readerWriter ].
]

{ #category : #writing }
ODBEncodingStream >> nextPutPersistentDictionary: aPersistentDictionary [
	stream
		putByte: ODBPersistentDictionaryCode;
		putPositiveInteger: aPersistentDictionary size.
	aPersistentDictionary keysAndValuesDo: [:key :value | 
		key odbSerialize: readerWriter.
		value odbSerialize: readerWriter ]
]

{ #category : #writing }
ODBEncodingStream >> nextPutProcessorScheduler: aProcessorScheduler [ 
	stream putByte: ODBProcessSchedulerCode
]

{ #category : #writing }
ODBEncodingStream >> nextPutSmallFloat64: aNumber [ 
	stream
		putByte: ODBSmallFloat64Code;
		putInteger: (aNumber at: 1);
		putInteger: (aNumber at: 2)
]

{ #category : #writing }
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

{ #category : #writing }
ODBEncodingStream >> nextPutSymbol: aSymbol [ 
	stream
		putByte: ODBSymbolCode;
		putPositiveInteger: aSymbol size;
		putBytesFrom: aSymbol asByteArray len: aSymbol size
]

{ #category : #writing }
ODBEncodingStream >> nextPutSystemDictionary: aCollection [ 
	stream putByte: ODBSystemDictionaryCode
]

{ #category : #writing }
ODBEncodingStream >> nextPutTime: aTime [ 
	stream
		putByte: ODBTimeCode;
		putPositiveInteger: aTime asSeconds
]

{ #category : #writing }
ODBEncodingStream >> nextPutTransaction: aTransaction [ 
	stream putByte: ODBTransactionCode
]

{ #category : #writing }
ODBEncodingStream >> nextPutTrue: aBoolean [ 
	stream putByte: ODBTrueCode
]

{ #category : #writing }
ODBEncodingStream >> nextPutWideString: aWideString [
	| buf |
	buf := self class encodeString: aWideString.
	stream
		putByte: ODBWideStringCode;
		putPositiveInteger: buf size;
		putBytesFrom: buf len: buf size
]

{ #category : #reading }
ODBEncodingStream >> nextSmallFloat64: aDeserializer [ 
	"We multiply the Boxesfloat by 1, this way we create a SmallFloat if possible"
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
	^ readerWriter register: buf asString.

]

{ #category : #reading }
ODBEncodingStream >> nextSymbol [
	| bytes len |
	bytes := ByteArray new: (len := stream getPositiveInteger).
	stream getBytesFor: bytes len: len.
	^ bytes asString asSymbol
]

{ #category : #reading }
ODBEncodingStream >> nextTime [
	^ readerWriter register: (Time fromSeconds: stream getPositiveInteger)
]

{ #category : #reading }
ODBEncodingStream >> nextWideString [
	| buf len |
	buf := ByteArray new: (len := stream getPositiveInteger).
	stream getBytesFor: buf len: len.
	^ readerWriter register: (self class decodeBytes: buf)
]

{ #category : #reading }
ODBEncodingStream >> nextnCharacterStringSize: size [
	    | buf |
   stream getBytesFor: (buf := ByteArray new: size) len: size.
    ^ readerWriter register: buf asString
]

{ #category : #accessing }
ODBEncodingStream >> position: anInteger [ 
	stream position: anInteger
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
