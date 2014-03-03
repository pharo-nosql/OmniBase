public
checkpoint
	"Commit all changes in persistent objects to the database
	and leave all locks set. Current transaction can still be used
	to change more objects."

	self currentTransaction checkpoint