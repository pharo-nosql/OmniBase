public
at: anInteger ifAbsent: aBlock 
	"Answer <position> at anInteger. Evaluate aBlock if absent."

	anInteger > lastID ifTrue: [anInteger > self getLastID ifTrue: [^aBlock value]].
	^stream atPositionGetLong: anInteger * 4 + self headerLength