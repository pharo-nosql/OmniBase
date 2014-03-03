private
createNewObjectSpaces
	"Private - Create new object space for each container."

	gcFile status = 1 ifFalse: [^self].
	containers do: [:each | each createNewObjectSpace].
	"new object spaces created"
	gcFile status: 2