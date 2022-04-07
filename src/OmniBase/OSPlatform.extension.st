Extension { #name : #OSPlatform }

{ #category : #'*OmniBase' }
OSPlatform >> omnibaseFileStreamClass [
	^ self error: 'Platform not Supported'
]
