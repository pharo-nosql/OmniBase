public
close
	"Close file associatied with receiver."

	self closeHandle: fileHandle.
	fileHandle := nil.