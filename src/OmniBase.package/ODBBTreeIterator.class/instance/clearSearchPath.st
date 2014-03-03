private
clearSearchPath
	"Private - Clear search path."

	[searchPathHeight == 0] whileFalse: 
			[searchPath at: searchPathHeight put: nil.
			searchPathHeight := searchPathHeight - 1]