public
clients
	"Answer collection of all clients currently connected to database."

	| client coll |
	coll := OrderedCollection new.
	idTable 
		onClientIDsDo: [:clientID | (client := self clientAt: clientID) == nil ifFalse: [coll add: client]].
	^coll