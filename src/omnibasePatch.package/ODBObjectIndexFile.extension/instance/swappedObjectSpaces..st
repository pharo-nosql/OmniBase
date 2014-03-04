*omnibasePatch
swappedObjectSpaces: aBoolean 
	"Set to <true> if object space A and B were swapped due to single container reorganization."

	| buf |
	buf := ByteArray new: 1.
	buf at: 1 put: (aBoolean ifTrue: [1] ifFalse: [0]).
	stream
		atPosition: self headerLength + 15 putBytesFrom: buf;
		flush