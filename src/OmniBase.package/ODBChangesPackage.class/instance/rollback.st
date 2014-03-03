public
rollback
	"Rollback change objects."

	changes do: [:each | each rollback]