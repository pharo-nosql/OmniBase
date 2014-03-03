public
lock: index 
	"Lock <value> at index."

	self waitForLockAt: (index - 1) * valueLength + start length: valueLength