public
at: anInteger 
	"Answer <position> at anInteger or <nil> if absent."

	anInteger > lastID ifTrue: [anInteger > self getLastID ifTrue: [^nil]].
	^stream atPositionGetLong: anInteger * 4 + self headerLength