Extension { #name : #ProcessorScheduler }

{ #category : #'*omnibase' }
ProcessorScheduler >> odbBasicSerialize: serializer [

	serializer stream nextPutProcessorScheduler: self
]

{ #category : #'*omnibase' }
ProcessorScheduler >> odbSerialize: serializer [

	self odbBasicSerialize: serializer
]
