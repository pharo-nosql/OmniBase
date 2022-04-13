Extension { #name : #BoxedFloat64 }

{ #category : #'*OmniBase' }
BoxedFloat64 >> odbBasicSerialize: serializer [ 
	serializer stream nextPutBoxedFloat64: self 
]

{ #category : #'*OmniBase' }
BoxedFloat64 >> odbSerialize: serializer [

	self odbBasicSerialize: serializer
]
