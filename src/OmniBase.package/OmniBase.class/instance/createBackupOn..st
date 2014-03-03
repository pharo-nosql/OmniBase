public
createBackupOn: newDirectoryName
	"Starts an on-line backup process and creates a backup copy
	of the receiver database.
	The database will be copied based on the current version of the data.
	The copy of the database will have its containers compacted with no old versions.
	The version counter will be reset to zero and b-trees will be reorganized to be up to 1 node full."

	OmniBaseArchiver new onlineBackup: self to: newDirectoryName