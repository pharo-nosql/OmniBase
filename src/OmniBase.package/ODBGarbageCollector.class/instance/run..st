public
run: silenceBool 
	(objectManager environment globalLock and: [objectManager reopenExclusively]) 
		ifFalse: 
			[objectManager environment globalUnlock.
			self close.
			silenceBool = true 
				ifFalse: [OmniBase warningMessage: 'Database is still being accessed by other users !'].
			^false].
	silenceBool = true 
		ifTrue: [self basicRun]
		ifFalse: 
			['OmniBase garbage collection in progress'
				displayProgressAt: Sensor cursorPoint
				from: 0 to: 100
				during:
					[:bar |
						progressDialog := bar.
						progressValue := bar.
						self basicRun]].
	^true