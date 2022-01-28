Class {
	#name : #ODBSerializationTest,
	#superclass : #OmniBaseTest,
	#category : #'OmniBase-Tests'
}

{ #category : #tests }
ODBSerializationTest >> testSerializationSelector [
	| object serialized materialized |
	object := #someSelector.
	serialized := ODBSerializer serializeToBytes: object.
	self assert: serialized equals: #[0 0 0 0 0 0 18 12 115 111 109 101 83 101 108 101 99 116 111 114].

	materialized := ODBDeserializer deserializeFromBytes: serialized .
	self assert: materialized equals: #someSelector
]

{ #category : #tests }
ODBSerializationTest >> testSerializationSmallFloat64 [
	| float serialized materialized |
	float := 1.11.
	self assert: float class equals: SmallFloat64.
	serialized := ODBSerializer serializeToBytes: float.
	self assert: serialized equals: #[0 0 1 0 0 0 47 158 138 142 255 7 134 215 199 194 11].

	materialized := ODBDeserializer deserializeFromBytes: serialized .
	self assert: materialized equals: 1.11

]

{ #category : #tests }
ODBSerializationTest >> testSerializationString [ 
	| string serialized materialized |
	string := 'hello'.
	serialized := ODBSerializer serializeToBytes: string.
	self assert: serialized equals: #[0 0 1 0 0 0 75 104 101 108 108 111].

	materialized := ODBDeserializer deserializeFromBytes: serialized .
	self assert: materialized equals: 'hello'


]

{ #category : #tests }
ODBSerializationTest >> testSerializationUndefindedObject [
	| object serialized materialized |
	object := nil.
	serialized := ODBSerializer serializeToBytes: object.
	self assert: serialized equals: #[0 0 0 0 0 0 14].

	materialized := ODBDeserializer deserializeFromBytes: serialized .
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

	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized equals: string.

]
