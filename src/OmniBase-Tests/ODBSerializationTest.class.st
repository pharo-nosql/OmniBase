Class {
	#name : #ODBSerializationTest,
	#superclass : #OmniBaseTest,
	#category : #'OmniBase-Tests'
}

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
ODBSerializationTest >> testSerializationWideString [ 
	| string serialized materialized |
	string := String
		with: 16r0154 asCharacter
		with: 16r0110 asCharacter
		with: 16r0155 asCharacter
		with: 16r0111 asCharacter.
	
	serialized := ODBSerializer serializeToBytes: string.
	self assert: serialized equals: #[0 0 1 0 0 0 36 8 197 148 196 144 197 149 196 145].

	materialized := ODBDeserializer deserializeFromBytes: serialized .
	self assert: materialized equals: string.


]
