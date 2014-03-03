public
clientTableAt: index lockAndPut: value 
	"Private - Put value at client table index."

	self waitForLockAt: self headerLength + index length: 1.
	[self clientTableAt: index put: value] 
		ensure: [self unlockAt: self headerLength + index length: 1]