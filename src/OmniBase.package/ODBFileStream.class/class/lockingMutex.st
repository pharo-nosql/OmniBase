locking
lockingMutex

	lockingMutex isNil
		ifTrue: [
			lockingMutex := Semaphore forMutualExclusion.
			locks := Dictionary new ].
	^lockingMutex