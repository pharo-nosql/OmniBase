private
addLock: aLock 
	"Private - Add aLock to receiver."

	OmniBase signalError: 'Global transaction should not set locks'