private
lockObjectManager
	gcFile status = 0 ifFalse: [^self].
	"objectManager lock."	"don't lock it because db is allready opened exclusively"
	"object manager has been locked"
	gcFile status: 1