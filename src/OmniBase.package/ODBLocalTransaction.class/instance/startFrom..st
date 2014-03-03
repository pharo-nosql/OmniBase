public
startFrom: aTransaction 
	"Start transaction.
	Transaction is read-only until no objects are locked.
	Version descriptor from aTransaction is valid at start."

	versionDescriptor := aTransaction versionDescriptor copy