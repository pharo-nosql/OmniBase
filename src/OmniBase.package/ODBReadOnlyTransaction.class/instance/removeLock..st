private
removeLock: aLock 
	"Private - Remove anODBLock from receiver."

	OmniBase signalError: 'Read-only transaction should not set locks'