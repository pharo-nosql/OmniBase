public
storeItem
	"Store page on iterator stream."

	| offset |
	offset := itemLength * indexOnPage + 1 + keyLength.
	iterator stream atPosition: pagePosition + offset
		putBytesFrom: (contents copyFrom: 1 + offset to: offset + valueLength + 2)