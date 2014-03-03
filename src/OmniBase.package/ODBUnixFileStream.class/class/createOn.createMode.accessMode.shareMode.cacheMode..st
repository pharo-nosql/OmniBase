create/open
createOn: pathString createMode: createMode accessMode: accessMode shareMode: shareMode cacheMode: cacheMode
	| stream needsWrite |

	stream := self createFileStreamForPath: pathString createMode: createMode.
	
	^	[self ensureAccessMode: accessMode forFileStream: stream.
		self setShareMode: shareMode forFileStream: stream.
	
		self new openOn: pathString fileHandle: stream]
			ifCurtailed: [stream close. nil]