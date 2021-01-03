Extension { #name : #BinaryFileStream }

{ #category : #'*OmniBase' }
BinaryFileStream >> fileHandle [

	^ handle pointerAt: 9
]

{ #category : #'*OmniBase' }
BinaryFileStream >> readInto: aByteArray startingAt: aNumber for: length [

	^ File 
		read: handle 
		into: aByteArray 
		startingAt: aNumber 
		count: length
]

{ #category : #'*OmniBase' }
BinaryFileStream >> readOnlyCopy [

	^ file openForRead
]

{ #category : #'*OmniBase' }
BinaryFileStream >> writeFrom: aString startingAt: aNumber for: length [ 

	^ File 
		write: handle 
		from: aString 
		startingAt: aNumber 
		count: length
]
