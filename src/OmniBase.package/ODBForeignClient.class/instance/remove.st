public
remove
	"Remove client from database. 
	Close files only, because client may be still active."

	clientFile isNil 
		ifFalse: 
			[self transactions copy do: [:each | each abort].
			clientFile close.
			clientFile := nil.
			clientManager removeForeignActiveClient: id]