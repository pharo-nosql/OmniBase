Extension { #name : #BoxedFloat64 }

{ #category : #'*OmniBase' }
BoxedFloat64 >> odbBasicSerialize: serializer [ 
	serializer stream
		putByte: 40;
		putInteger: (self at: 1);
		putInteger: (self at: 2)
]

{ #category : #'*OmniBase' }
BoxedFloat64 >> odbSerialize: serializer [

	self odbBasicSerialize: serializer
]
