public
lockAt: pos length: length
	^ (OSProcess accessor lockFile: fileHandle from: pos to: pos + length -1) notNil