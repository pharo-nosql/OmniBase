public
newObjectSpace
	"Answer garbage collector new object space."

	^stream
		position: self headerLength + 1;
		getByte