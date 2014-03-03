private
keySize: anInteger 
	"Private - Set the key upon creation size."

	keySize := anInteger.
	(keySize < 300 and: [keySize > 1]) 
		ifFalse: [OmniBase signalError: 'Please choose key size between 2 and 300 bytes']