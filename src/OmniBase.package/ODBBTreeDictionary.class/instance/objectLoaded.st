private
objectLoaded
	"Sent to transaction object when it is loaded into transaction."

	initialSize := dataBaseObject iterator getSizeAt: transaction versionDescriptor
				oldHolders: transaction oldHolders