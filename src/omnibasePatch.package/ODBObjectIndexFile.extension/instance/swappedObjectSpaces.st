*omnibasePatch
swappedObjectSpaces
	"Answer <true> if object space A and B were swapped due to single container reorganization."

	| buf |
	buf := ByteArray new: 1.
	(stream atPosition: self headerLength + 15 getBytesFor: buf) = 1 ifTrue: [^(buf at: 1) = 1].
	OmniBase signalError: 'File read error'