load/store
saveOnStream: stream 
	references isNil 
		ifTrue: [stream putPositiveInteger: 0]
		ifFalse: 
			[stream putPositiveInteger: references size.
			references do: [:each | each storeOnStream: stream]]