public
commit
	"Commit all changes in persistent objects to the database
	and release all locks. Current transaction can not be used
	anymore."

	self currentTransaction commit