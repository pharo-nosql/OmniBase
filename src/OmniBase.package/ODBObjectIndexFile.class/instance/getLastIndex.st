public
getLastIndex
	"Private - Answer index of last object holder."

	^stream atPositionGetLong: self headerLength + 4