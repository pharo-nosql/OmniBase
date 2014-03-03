public
store
	"Store page on iterator stream."

	iterator stream 
		atPosition: pagePosition
		putBytesFrom: contents
		len: ((contents at: 1) > 127 
				ifFalse: [(itemLength + 4) * self pageSize + 5]
				ifTrue: [itemLength * self pageSize + 1])