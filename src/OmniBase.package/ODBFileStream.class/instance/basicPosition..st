public
basicPosition: anInteger
	"Positiones stream to anInteger. Answer anInteger."

	fileHandle position: anInteger.
	^position := anInteger
