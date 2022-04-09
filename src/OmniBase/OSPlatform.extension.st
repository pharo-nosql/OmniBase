Extension { #name : #OSPlatform }

{ #category : #'*OmniBase' }
OSPlatform >> flockClass [ 
	Error signal: 'no support for file locking on this platform'
]

{ #category : #'*OmniBase' }
OSPlatform >> omnibaseFileStreamClass [
	^ self error: 'Platform not Supported'
]
