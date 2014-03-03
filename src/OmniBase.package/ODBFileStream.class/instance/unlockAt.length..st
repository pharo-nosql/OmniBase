public
unlockAt: pos length: length
		"Unlock portion of file at position pos.
		Answer <true> if successfull, <false> if failed."

	^self class unlockAt: pos length: length pathName: pathName fileHandle: fileHandle seekingMutex: mutex position: position