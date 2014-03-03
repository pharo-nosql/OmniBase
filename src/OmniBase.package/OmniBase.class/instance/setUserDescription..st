public
setUserDescription: aString 
	"Set user description.
	This string can be read by other database connections to identify who has opened a database."

	self localClient description: aString