public
globalLock
	"Lock database so that only one user can change objects in
	it. No locks will be made to objects stored in the database
	files while the database is globaly locked. Answer <true>
	if successfull or <false> if failed. Global write lock will
	fail if there are read-write transactions already running."

	clientManager removeDisconnectedClients.
	^clientManager localClient globalLock