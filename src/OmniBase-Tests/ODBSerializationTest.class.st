Class {
	#name : #ODBSerializationTest,
	#superclass : #TestCase,
	#pools : [
		'ODBTypeCodes'
	],
	#category : #'OmniBase-Tests'
}

{ #category : #tests }
ODBSerializationTest >> testSerializationArray [
	| object serialized materialized |
	object := #(1 2 3 5).
	serialized := ODBSerializer serializeToBytes: object.
	self assert: serialized equals: #[0 0 1 0 0 0 35 4 51 52 53 55].
	self assert: (serialized at: 7) equals: ODBArrayCode.

	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized equals: object
]

{ #category : #tests }
ODBSerializationTest >> testSerializationAssociation [
	| object serialized materialized |
	object := 1 -> 2.
	serialized := ODBSerializer serializeToBytes: object.
	self assert: serialized equals: #[0 0 1 0 0 0 31 51 52].
	self assert: (serialized at: 7) equals: ODBAssociationCode.

	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized equals: object
]

{ #category : #tests }
ODBSerializationTest >> testSerializationBoolean [
	| object serialized materialized |
	object := true.
	serialized := ODBSerializer serializeToBytes: object.
	self assert: serialized equals: #[0 0 0 0 0 0 15].
	self assert: (serialized at: 7) equals: ODBTrueCode.

	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized.
	
	"Check false"
	object := false.
	serialized := ODBSerializer serializeToBytes: object.
	self assert: serialized equals: #[0 0 0 0 0 0 16].
	self assert: (serialized at: 7) equals: ODBFalseCode.
	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self deny: materialized
]

{ #category : #tests }
ODBSerializationTest >> testSerializationBoxedFloat64 [
	| float serialized materialized |
	float := 2.45227231256843e-45.
	self assert: float class equals: BoxedFloat64.
	serialized := ODBSerializer serializeToBytes: float.
	self 
		assert: serialized 
		equals: #[0 1 12 66 111 120 101 100 70 108 111 97 116 54 52 1 1 0 1 0 0 0 2 1 2 128 128 224 234 6 0].
	"self assert: (serialized at: 7) equals: ODBFloatCode."
	self flag: #TODO. "Implement BoxedFloat Serialisation and de-serialization"
	
	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: float class equals: BoxedFloat64.
	self assert: materialized equals: 2.45227231256843e-45

]

{ #category : #tests }
ODBSerializationTest >> testSerializationByteArray [
	| object serialized materialized |
	object := #[1 2 3 5].
	serialized := ODBSerializer serializeToBytes: object.
	self assert: serialized equals: #[0 1 9 66 121 116 101 65 114 114 97 121 1 1 0 1 0 0 0 2 1 4 1 2 3 5].
	"self assert: (serialized at: 7) equals: ODBByteArrayCode."
	self flag: #TODO. "Implement ByteArray Serialisation and de-serialization"

	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized equals: object
]

{ #category : #tests }
ODBSerializationTest >> testSerializationCharacter [
	| object serialized materialized |
	object := $a.
	serialized := ODBSerializer serializeToBytes: object.
	self assert: serialized equals: #[0 0 0 0 0 0 13 97].
	self assert: (serialized at: 7) equals: ODBCharacterCode.

	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized equals: object.
	
	object := 16rF600 asCharacter.
	serialized := ODBSerializer serializeToBytes: object.
	self assert: serialized equals: #[0 0 0 0 0 0 29 0 246].
	self assert: (serialized at: 7) equals: ODBDoubleByteCharacterCode.

	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized equals: object.
]

{ #category : #tests }
ODBSerializationTest >> testSerializationClass [
	| object serialized materialized |
	object := Point.
	serialized := ODBSerializer serializeToBytes: object.
	self assert: serialized equals: #[0 0 0 0 0 0 26 5 80 111 105 110 116].
	self assert: (serialized at: 7) equals: ODBClassCode.
	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized  equals: Point.
]

{ #category : #tests }
ODBSerializationTest >> testSerializationDate [
	| object serialized materialized |
	object := Date fromDays: 10.
	serialized := ODBSerializer serializeToBytes: object.
	self assert: serialized equals: #[0 0 1 0 0 0 32 20 0].
	self assert: (serialized at: 7) equals: ODBDateCode.

	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized equals: object
]

{ #category : #tests }
ODBSerializationTest >> testSerializationDictionary [
	| object serialized materialized |
	object := { 1->2 . 3->4 } asDictionary.
	serialized := ODBSerializer serializeToBytes: object.
	self assert: serialized equals: #[0 0 1 0 0 0 37 2 51 52 53 54].
	self assert: (serialized at: 7) equals: ODBDictionaryCode.

	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized equals: object
]

{ #category : #tests }
ODBSerializationTest >> testSerializationFraction [
	| object serialized materialized |
	object := 1/2.
	self assert: object class equals: Fraction.
	serialized := ODBSerializer serializeToBytes: object.
	self assert: serialized equals: #[0 0 0 0 0 0 39 2 4].
	self assert: (serialized at: 7) equals: ODBFractionCode.
	
	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized equals: object
]

{ #category : #tests }
ODBSerializationTest >> testSerializationIdentityDictionary [
	| object serialized materialized |
	object := IdentityDictionary newFrom: { #test->2 . #now->4 }.
	serialized := ODBSerializer serializeToBytes: object.
	self assert: serialized equals: #[0 0 1 0 0 0 38 2 18 4 116 101 115 116 52 18 3 110 111 119 54].
	self assert: (serialized at: 7) equals: ODBIdentityDictionaryCode.

	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized equals: object
]

{ #category : #tests }
ODBSerializationTest >> testSerializationLargeInteger [
	| object serialized materialized |
	
	"Integers are small if they are in between -3 and 16"
	"The test in addition tests LargeIntegers, but for the databse, they are just the same"
	
	object := 17.
	serialized := ODBSerializer serializeToBytes: object.
	self assert: serialized equals: #[0 0 0 0 0 0 11 17].
	self assert: (serialized at: 7) equals: ODBLargePositiveIntegerCode.

	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized equals: object.
	
	object := -4.
	serialized := ODBSerializer serializeToBytes: object.
	self assert: serialized equals: #[0 0 0 0 0 0 12 4].
	self assert: (serialized at: 7) equals: ODBLargeNegativeIntegerCode.

	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized equals: object.
	
	
	object := SmallInteger maxVal + 1.
	serialized := ODBSerializer serializeToBytes: object.
	self assert: serialized equals: #[0 0 0 0 0 0 11 128 128 128 128 128 128 128 128 16].
	self assert: (serialized at: 7) equals: ODBLargePositiveIntegerCode.

	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized equals: object.
	
	"Negative"
	object := SmallInteger minVal - 1.
	serialized := ODBSerializer serializeToBytes: object.
	self assert: serialized equals: #[0 0 0 0 0 0 12 129 128 128 128 128 128 128 128 16].
		self assert: (serialized at: 7) equals: ODBLargeNegativeIntegerCode.

	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized equals: object
]

{ #category : #tests }
ODBSerializationTest >> testSerializationMessage [
	| object serialized materialized |
	object := Message selector: #+ argument: 2.
	serialized := ODBSerializer serializeToBytes: object.
	self assert: serialized equals: #[0 0 2 0 0 0 17 18 1 43 35 1 52].
	self assert: (serialized at: 7) equals: ODBMessageCode.

	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized selector equals: object selector.
	self assert: materialized arguments equals: object arguments.
	self assert: materialized lookupClass equals: object lookupClass.
]

{ #category : #tests }
ODBSerializationTest >> testSerializationMessageSend [
	| object serialized materialized |
	object := MessageSend receiver: 1 selector: #+ argument: 2.
	serialized := ODBSerializer serializeToBytes: object.
	self assert: serialized equals: #[0 0 2 0 0 0 20 51 18 1 43 35 1 52].
	self assert: (serialized at: 7) equals: ODBMessageSendCode.

	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized selector equals: object selector.
	self assert: materialized arguments equals: object arguments.
	self assert: materialized receiver equals: object receiver.
]

{ #category : #tests }
ODBSerializationTest >> testSerializationODBPersistentDictionary [
	| object serialized materialized |
	object :=  ODBPersistentDictionary new.
	object at: #key put: 1.
	serialized := ODBSerializer serializeToBytes: object.
	self assert: serialized equals: #[0 0 1 0 0 0 83 1 18 3 107 101 121 51].
	self assert: (serialized at: 7) equals: ODBPersistentDictionaryCode.

	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized equals: object
]

{ #category : #tests }
ODBSerializationTest >> testSerializationObject [
	| object serialized materialized |
	object := Object new.
	serialized := ODBSerializer serializeToBytes: object.
	self assert: serialized equals: #[0 1 6 79 98 106 101 99 116 0 0 0 1 0 0 0 2 1].

	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized class equals: Object
]

{ #category : #tests }
ODBSerializationTest >> testSerializationOrderedCollection [
	| object serialized materialized |
	object := #(1 2 3 5) asOrderedCollection.
	serialized := ODBSerializer serializeToBytes: object.
	self assert: serialized equals: #[0 0 1 0 0 0 81 4 51 52 53 55].
	self assert: (serialized at: 7) equals: ODBOrderedCollectionCode.

	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized equals: object
]

{ #category : #tests }
ODBSerializationTest >> testSerializationProcessSchedulerCode [
	| object serialized materialized |
	object := Processor.
	serialized := ODBSerializer serializeToBytes: object.
	self assert: serialized equals: #[0 0 0 0 0 0 22].
	self assert: (serialized at: 7) equals: ODBProcessSchedulerCode.

	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized equals: Processor
]

{ #category : #tests }
ODBSerializationTest >> testSerializationSmallFloat64 [
	| float serialized materialized |
	float := 1.11.
	self assert: float class equals: SmallFloat64.
	serialized := ODBSerializer serializeToBytes: float.
	self assert: serialized equals: #[0 0 0 0 0 0 47 158 138 142 255 7 134 215 199 194 11].
	self assert: (serialized at: 7) equals: ODBSmallFloat64Code.
	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized class equals: SmallFloat64.
	self assert: materialized equals: 1.11

]

{ #category : #tests }
ODBSerializationTest >> testSerializationSmallInteger [
	| object serialized materialized |
	object := 15.
	serialized := ODBSerializer serializeToBytes: object.
	self assert: serialized equals: #[0 0 0 0 0 0 65].
	self assert: (serialized at: 7) equals: ODBSmallPositiveIntegerBaseCode + object.

	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized equals: 15.

	object := -3.
	serialized := ODBSerializer serializeToBytes: object.
	self assert: serialized equals: #[0 0 0 0 0 0 67].
	self assert: (serialized at: 7) equals: ODBMinusThreeCode.

	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized equals: -3.
	
	self assert: ((ODBSerializer serializeToBytes: -1) at: 7) equals: ODBMinusOne.
		self assert: ((ODBSerializer serializeToBytes: -2) at: 7) equals: ODBMinusTwo.
]

{ #category : #tests }
ODBSerializationTest >> testSerializationString [ 
	| string serialized materialized |
	"First Small String with size < 10"
	
	string := 'hello'.
	serialized := ODBSerializer serializeToBytes: string.
	self assert: serialized equals: #[0 0 1 0 0 0 75 104 101 108 108 111].
	self assert: (serialized at: 7) equals: ODBSmallStringBaseCode + string size.

	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized equals: 'hello'.

	"Larger (all other) Strings"
	
	string := 'helloWithMoreCharacters'.
	serialized := ODBSerializer serializeToBytes: string.
	self 
		assert: serialized
		equals: #[0 0 1 0 0 0 34 23 104 101 108 108 111 87 105 116 104 77 111 114 101 67 104 97 114 97 99 116 101 114 115].
	self assert: (serialized at: 7) equals: ODBStringCode.
	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized equals: string
]

{ #category : #tests }
ODBSerializationTest >> testSerializationSymbol [
	| object serialized materialized |
	object := #someSelector.
	serialized := ODBSerializer serializeToBytes: object.
	self assert: serialized equals: #[0 0 0 0 0 0 18 12 115 111 109 101 83 101 108 101 99 116 111 114].
	self assert: (serialized at: 7) equals: ODBSymbolCode.
	
	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized equals: #someSelector
]

{ #category : #tests }
ODBSerializationTest >> testSerializationSystemDictionary [
	| object serialized materialized |
	object := Smalltalk globals.
	object at: #Object put: Object.
	serialized := ODBSerializer serializeToBytes: object.
	self assert: serialized equals: #[0 0 0 0 0 0 19].
	self assert: (serialized at: 7) equals: ODBSystemDictionaryCode.

	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self flag: #TODO.
	"this shows that we do not de-serialize the dictionary, but the global Smalltalk binding"
	self assert: materialized equals: Smalltalk
]

{ #category : #tests }
ODBSerializationTest >> testSerializationTime [
	| object serialized materialized |
	object := Time midnight.
	serialized := ODBSerializer serializeToBytes: object.
	self assert: serialized equals: #[0 0 1 0 0 0 33 0].
	self assert: (serialized at: 7) equals: ODBTimeCode.

	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized equals: object
]

{ #category : #tests }
ODBSerializationTest >> testSerializationUndefindedObject [
	| object serialized materialized |
	object := nil.
	serialized := ODBSerializer serializeToBytes: object.
	self assert: serialized equals: #[0 0 0 0 0 0 14].
	self assert: (serialized at: 7) equals: ODBUndefinedObjectCode.

	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized equals: nil
]

{ #category : #tests }
ODBSerializationTest >> testSerializationWideStringUTF16 [

	| string serialized materialized |
	string := String
		with: 16rF600 asCharacter
		with: 16rF603 asCharacter
		with: 16r0155 asCharacter
		with: 16r0111 asCharacter.
	self assert: string isWideString.
	ODBTypeCodes encoding: #utf16.
	
	serialized := ODBSerializer serializeToBytes: string.
	self assert: serialized equals: #[0 0 1 0 0 0 36 8 246 0 246 3 1 85 1 17].
	self assert: (serialized at: 7) equals: ODBWideStringCode.

	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized equals: string.

]

{ #category : #tests }
ODBSerializationTest >> testSerializationWideStringUTF32 [

	| string serialized materialized |
	string := String
		with: 16rF600 asCharacter
		with: 16rF603 asCharacter
		with: 16r0155 asCharacter
		with: 16r0111 asCharacter.
	self assert: string isWideString.
	ODBTypeCodes encoding: #utf32.
	
	serialized := ODBSerializer serializeToBytes: string.
	self assert: serialized equals: #[0 0 1 0 0 0 36 16 0 0 246 0 0 0 246 3 0 0 1 85 0 0 1 17].
	self assert: (serialized at: 7) equals: ODBWideStringCode.
	
	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized equals: string.

]

{ #category : #tests }
ODBSerializationTest >> testSerializationWideStringUTF8 [
	| string serialized materialized |
	string := String
		with: 16rF600 asCharacter
		with: 16rF603 asCharacter
		with: 16r0155 asCharacter
		with: 16r0111 asCharacter.
	self assert: string isWideString.
	ODBTypeCodes encoding: #utf8.
	
	serialized := ODBSerializer serializeToBytes: string.
	self assert: serialized equals: #[0 0 1 0 0 0 36 10 239 152 128 239 152 131 197 149 196 145].
	self assert: (serialized at: 7) equals: ODBWideStringCode.

	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized equals: string.

]
