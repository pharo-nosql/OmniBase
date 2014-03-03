public
root: anObject 
	"Set the root object of the database."

	| rootObjectHolder rootOID |
	rootOID := ODBObjectID containerID: 1 index: 1.
	(rootObjectHolder := self objectAt: rootOID) isNil 
		ifTrue: 
			[rootObjectHolder := ODBRootObjectHolder new.
			self store: rootObjectHolder.
			cacheMutex critical: [objects at: rootOID put: rootObjectHolder]].
	rootObjectHolder rootObject: anObject