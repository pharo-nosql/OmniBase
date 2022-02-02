Extension { #name : #SmallFloat64 }

{ #category : #'*OmniBase' }
SmallFloat64 >> odbSerialize: serializer [ 
	serializer stream
		putByte: 47;
		putInteger: (self at: 1);
		putInteger: (self at: 2)  
]
