Extension { #name : #ProcessorScheduler }

{ #category : #'*omnibase' }
ProcessorScheduler >> odbBasicSerialize: serializer [
	self class == ProcessorScheduler ifFalse: [ ^ super odbBasicSerialize: serializer ].
	serializer stream nextPutProcessorScheduler: self
]

{ #category : #'*omnibase' }
ProcessorScheduler >> odbSerialize: serializer [

	self odbBasicSerialize: serializer
]
