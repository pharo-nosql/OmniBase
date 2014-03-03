public
allocateBuffer
	"Private - Allocate space in file for buffer so that less locking 
	and file I/O calls are needed when transaction is committing."

	self waitForAddingLock.
	
	[filePos := stream setToEnd.
	stream truncate: filePos + 512] ensure: [self unlockAdding].
	buffer := ByteArray new: 512.
	bufPos := 0