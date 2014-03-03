public
at: anInteger 
	"Answer bytes at index anInteger, <nil> if none."

	| bytes |
	anInteger < 1 ifTrue: [OmniBase signalError: 'Invalid object ID'].
	bytes := ByteArray new: valueLength.
	(stream 
		atPosition: (anInteger - 1) * valueLength + start
		getBytesFor: bytes
		len: valueLength) == valueLength 
		ifFalse: [^nil].
	"   (bytes at: 1) == 0 ifFalse: [ ^bytes ].
    (bytes at: 2) == 0 ifFalse: [ ^bytes ].
    (bytes at: 3) == 0 ifFalse: [ ^bytes ].
    (bytes at: 4) == 0 ifFalse: [ ^bytes ]."
	(bytes at: 9) == 0 ifFalse: [^bytes].
	^nil