public
storeItemLocked
	"Store item at indexOnPage to iterator stream."

	| offset |
	offset := itemLength * indexOnPage + 1 + keyLength.
	iterator waitForLockAt: pagePosition + offset length: valueLength + 2.
	iterator stream atPosition: pagePosition + offset
		putBytesFrom: (contents copyFrom: 1 + offset to: offset + valueLength + 2).
	iterator unlockAt: pagePosition + offset length: valueLength + 2