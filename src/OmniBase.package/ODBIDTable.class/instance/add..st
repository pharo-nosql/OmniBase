public
add: anInteger 
	"Store anInteger and answer its ID."

	lastID := self getLastID + 1.
	stream
		atPosition: lastID * 4 + self headerLength putLong: anInteger;
		atPosition: self headerLength putLong: lastID.
	^lastID