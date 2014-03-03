public
flushContainers
	"Flush all containers before commit."

	containers do: [:each | each isNil ifFalse: [each flushBytes]]