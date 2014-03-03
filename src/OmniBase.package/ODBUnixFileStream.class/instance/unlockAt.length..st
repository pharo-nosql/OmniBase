public
unlockAt: pos length: length
	^ (OSProcess accessor unlockFile: fileHandle from: pos to: pos + length -1) notNil