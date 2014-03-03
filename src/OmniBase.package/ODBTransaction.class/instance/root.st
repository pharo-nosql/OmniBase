public
root
	"Answer the database root object. Root object represents an entry point into the database.
	Only objects that are being referenced from the root object will remain after the garbage
	collection on the database."

	| rootObjectHolder |
	^(rootObjectHolder := self objectAt: (ODBObjectID containerID: 1 index: 1)) isNil 
		ifFalse: [rootObjectHolder rootObject]