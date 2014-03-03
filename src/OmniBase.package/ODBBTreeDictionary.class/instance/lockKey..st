public
lockKey: aKey 
	"Lock key aKey so that other transactions wont be able
	to change it. Answer <true> if successfull."

	^self basicLockKey: (self bytesFromKey: aKey)