Extension { #name : #ProcessorScheduler }

{ #category : #'*omnibase' }
ProcessorScheduler >> odbBasicSerialize: serializer [

	serializer stream putByte: 22
]

{ #category : #'*omnibase' }
ProcessorScheduler >> odbSerialize: serializer [

	serializer stream putByte: 22
]
