public
newReadOnlyTransaction
	"Answer new read-only transaction. Read only transactions
	are here only to prevent user code from writing into the database.
	Read-only transaction are not meant to improve concurrency since
	multi-version concurrency control is used in OmniBase and therefore
	all transactions run as read-only transactions up to the point when the
	first object is locked."

	^clientManager localClient newReadOnlyTransaction