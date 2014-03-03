public
closeAll
	"Closes all opened database sessions. Do not use this method if you're using
	the Source Tracking System for development since it will also close its connection
	to the source code repository."

	sessions isNil ifTrue: [^false].
	sessions copy 
		do: [:each | [each close] on: Error do: [:er | sessions remove: each ifAbsent: []]]