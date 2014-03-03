private
odbObjectID
	"Private - answer an object ID of the database connection instance.
	This is used when a persistent object is referencing current database connection.
	When deserialized it will set reference to the current database connection."

	^ODBObjectID containerID: 0 index: 4