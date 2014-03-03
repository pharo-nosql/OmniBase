public
root
	"Answer the database root object. Root object represents an entry point into the database.
	Only objects referenced from the root object will remain after the garbage collection is 
	performed on the database. By default the root object is a dictionary with persistent objects
	as its values. This can be changed if needed using message #root: on transaction."

	^self currentTransaction root