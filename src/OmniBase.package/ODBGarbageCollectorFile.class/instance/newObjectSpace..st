public
newObjectSpace: anInteger 
	"Set garbage collector new object space."

	stream
		position: self headerLength + 1;
		putByte: anInteger;
		flush