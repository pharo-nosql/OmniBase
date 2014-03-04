locking
waitForLockAt: pos length: length whileWaitingDo: aBlock
		"Wait for lock at given position. 
		Evaluate aBlock in each iteration."

	"Dec, 2010. sas: evaluating code in each iteration while waiting sounds weird but whatever.
	I think this was designed on the wrong assumption that the OS always will provide a false 
	in the first try but what actually happens is that in win32 you always will 
	get at least one false but in *nixes you don't do see that happening (which is totally reasonable).
	BEWARE of stupid code relying on this stupid assumption (I've already patched #lockDataFile because of this)."
	
	| startTime currentTime |
	(stream lockAt: pos length: length) ifFalse: [
		startTime := Time totalSeconds.
		[stream lockAt: pos length: length] whileFalse: [
			aBlock value.
			currentTime := Time totalSeconds.
			currentTime - startTime < self timeOutLength
				ifFalse: [
					ODBLockNotification signal
						ifTrue: [startTime := currentTime]
						ifFalse: [^ODBCannotLock signal]]]]