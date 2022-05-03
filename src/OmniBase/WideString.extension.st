Extension { #name : #WideString }

{ #category : #'*OmniBase' }
WideString >> odbBasicSerialize: serializer [
	
	serializer stream nextPutWideString: self
]

{ #category : #'*OmniBase' }
WideString class >> odbDeserialize: deserializer [

	^ deserializer stream nextWideString
]
