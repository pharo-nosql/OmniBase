private
removeLock: aLock 
	"Private - Remove aLock from receiver."

	OmniBase signalError: 'Global transaction should not set locks'