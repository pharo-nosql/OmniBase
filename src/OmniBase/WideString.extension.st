Extension { #name : #WideString }

{ #category : #'*OmniBase' }
WideString >> odbBasicSerialize: serializer [
	| buf |
	
	buf := ODBTypeCodes encoder encodeString: self.
	serializer stream
		putByte: 36;
		putPositiveInteger: buf size;
		putBytesFrom: buf len: buf size
]

{ #category : #'*OmniBase' }
WideString class >> odbDeserialize: deserializer [

	| buf len |
	buf := ByteArray new: (len := deserializer stream getPositiveInteger).
	deserializer stream getBytesFor: buf len: len.
	^deserializer register: (ODBTypeCodes encoder decodeBytes: buf)
]
