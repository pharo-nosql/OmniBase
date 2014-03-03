public
setLastIndex: anInteger 
	"Private - Answer set index of last object holder."

	^stream atPosition: self headerLength + 4 putLong: anInteger