Class {
	#name : #ODBSerializationTest,
	#superclass : #OmniBaseTest,
	#category : #'OmniBase-Tests'
}

{ #category : #testing }
ODBSerializationTest >> expectedFailures [ 
	^ #( testSerializationWideString )
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
ODBSerializationTest >> testSerializationWideString [ 
	| smileyCodePoint string serialized materialized |
	smileyCodePoint := Character codePoint: 16rF600.
	string := 'hello ', smileyCodePoint asString.
	serialized := ODBSerializer serializeToBytes: string.

	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized equals: string


]
