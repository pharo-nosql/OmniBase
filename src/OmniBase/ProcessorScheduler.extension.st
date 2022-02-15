Extension { #name : #ProcessorScheduler }

{ #category : #'*omnibase' }
ProcessorScheduler >> odbSerialize: serializer [

	serializer stream putByte: 22
]
