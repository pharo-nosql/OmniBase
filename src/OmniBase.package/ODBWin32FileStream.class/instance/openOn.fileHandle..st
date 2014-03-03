private
openOn: aString fileHandle: win32Handle
	"Private - Initialize receiver."

	pathName := aString.
	fileHandle := win32Handle.
	mutex := Semaphore forMutualExclusion.
	externalLong := ByteArray new: 4.