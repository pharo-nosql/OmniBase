public
at: anInteger put: aPosition 
	"Put aPosition at anInteger."

	^stream atPosition: anInteger * 4 + self headerLength putLong: aPosition