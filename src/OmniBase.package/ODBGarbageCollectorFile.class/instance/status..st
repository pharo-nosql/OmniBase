public
status: anInteger 
	"Set garbage collector status."

	status := anInteger.
	stream
		position: self headerLength;
		putByte: anInteger;
		flush