public
objectAt: anODBObjectID 
	"Answer a persistent object with a given object id. The object will be fetched right away 
	without instantiating a proxy object first. Answer <nil> if object id is nonexistent i.e. 
	there is no persistent object with such oid."

	^self currentTransaction objectAt: anODBObjectID