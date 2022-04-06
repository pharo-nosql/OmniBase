Extension { #name : #BinaryFileStream }

{ #category : #'*OmniBase' }
BinaryFileStream >> fileHandle [

	^ handle pointerAt: 9
]

{ #category : #'*OmniBase' }
BinaryFileStream >> writeFrom: aString startingAt: aNumber for: length [ 

	^ File 
		write: handle 
		from: aString 
		startingAt: aNumber 
		count: length
]
