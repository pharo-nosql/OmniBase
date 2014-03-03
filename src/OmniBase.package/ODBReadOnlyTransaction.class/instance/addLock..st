private
addLock: aLock 
	"Private - Add anODBLock to receiver."

	OmniBase signalError: 'Read-only transaction should not set locks'