Class {
	#name : #ODBSerializerBugsTest,
	#superclass : #TestCase,
	#category : #'OmniBase-Tests'
}

{ #category : #tests }
ODBSerializerBugsTest >> testSerializationSmallFloat64Two [
	| object serialized materialized |
	
	"try to serialize an object that references twice the same small floats"
	object := {1.11 . 1.11}.

	serialized := ODBSerializer serializeToBytes: object.
	materialized := ODBDeserializer deserializeFromBytes: serialized.
	self assert: materialized equals: object.
	
	"We changed serialization fixing https://github.com/ApptiveGrid/MoniBase/issues/22
	This checks that we can load the old serialized Floats after the change"
	
	materialized := ODBDeserializer 
		deserializeFromBytes: #[0 0 1 0 0 0 47 158 138 142 255 7 134 215 199 194 11].
	self assert: materialized equals: object first.
]
