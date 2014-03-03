public
numberOfClients
	"Answer total number of client connections currently working with database.
	(this will answer how many times a database on a given directory has been opened)"

	| clients count |
	count := 0.
	clients := clientManager
				removeDisconnectedClients;
				clients.
	clients do: [:eachClient | eachClient isTerminated ifFalse: [count := count + 1]].
	clientManager closeForeignClients.
	^count