public
waitForLockAt: pos length: length 
	"Wait for lock at given position."

	^self 
		waitForLockAt: pos
		length: length
		whileWaitingDo: [(Delay forMilliseconds: 250) wait]