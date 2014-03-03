private
opened
	"Private - Receiver has just been opened."

	clients := Array new: ODBClientTable maxClients.
	"ensure that directory exists in case the database was unzipped
	(WinZIP does not zip and later create empty directories)."
	(ODBFileStream directoryExists: self dirName) 
		ifFalse: [ODBFileStream directoryCreate: self dirName]