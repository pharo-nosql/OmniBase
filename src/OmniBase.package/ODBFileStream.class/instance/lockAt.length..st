public
lockAt: pos length: length
		"Lock portion of file starting at position pos. 
		Answer <true> if successfull, <false> if failed.
		Also sets an internal lock to prevent setting lock twice.
		Unix style fcntl locking will answer true if a lock is set twice.
		For OmniBase this is not allowed."

	^self class lockAt: pos length: length pathName: pathName fileHandle: fileHandle seekingMutex: mutex position: position