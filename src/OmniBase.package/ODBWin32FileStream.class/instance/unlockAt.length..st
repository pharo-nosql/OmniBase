public
unlockAt: pos length: length 
	"Unlock portion of file at position pos. 
	Answer <true> if successfull, <false> if failed."

	^(self
		unlockFile: fileHandle
		offsetLow: pos
		offsetHigh: 0
		lengthLow: length
		lengthHigh: 0) ~= 0