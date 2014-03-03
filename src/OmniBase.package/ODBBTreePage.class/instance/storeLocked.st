public
storeLocked
	"Store page on iterator stream."

	| length |
	(contents at: 1) > 127 
		ifFalse: [length := (itemLength + 4) * self pageSize + 5]
		ifTrue: [length := itemLength * self pageSize + 1].
	iterator waitForLockAt: pagePosition length: length.
	iterator stream 
		atPosition: pagePosition
		putBytesFrom: contents
		len: length.
	iterator unlockAt: pagePosition length: length