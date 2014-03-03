private
basicLockKey: key 
	"Private - Lock key so that other transactions wont be able
	to change it. Answer <true> if successfull."

	| lock lockID value |
	dataBaseObject isNil ifTrue: [^true].
	(lockID := transaction lockID) isNil ifTrue: [^false].
	transaction isGlobalLocked ifTrue: [^true].
	locks isNil 
		ifTrue: [locks := Dictionary new]
		ifFalse: [(locks includesKey: key) ifTrue: [^true]].
	lock := (ODBKeyLock new)
				objectID: holder objectID;
				lockID: lockID;
				key: key.
	value := self valueAt: key.
	dataBaseObject iterator critical: 
			[transaction addLoggedLock: lock.
			((dataBaseObject iterator)
				goTo: key;
				lockCurrentValue: value contents with: lockID) 
					ifFalse: 
						[transaction removeLoggedLock: lock.
						^false]].
	locks at: key put: lock.
	^true