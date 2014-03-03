public
rollback
	"Release all locks set in the current transaction and forget 
	all changes done on persistent objects."

	self currentTransaction abort