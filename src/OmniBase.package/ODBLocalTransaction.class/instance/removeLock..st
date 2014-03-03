private
removeLock: aLock 
	"Private - Remove aLock from collection of set locks."

	locks remove: aLock ifAbsent: []