Extension { #name : #SmallFloat64 }

{ #category : #'*OmniBase' }
SmallFloat64 >> odbBasicSerialize: serializer [ 
	serializer stream
		putByte: 47;
		putInteger: (self at: 1);
		putInteger: (self at: 2)  
]

{ #category : #'*OmniBase' }
SmallFloat64 >> odbSerialize: serializer [ 
	self odbBasicSerialize: serializer
]
