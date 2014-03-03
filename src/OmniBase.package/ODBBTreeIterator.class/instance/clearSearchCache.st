public
clearSearchCache
	"Clear search path."

	mutex critical: [self clearSearchPath]