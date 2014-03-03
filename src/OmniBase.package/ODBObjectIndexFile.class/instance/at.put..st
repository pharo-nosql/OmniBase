public
at: anInteger put: value 
	"Put value at anInteger."

	anInteger < 1 ifTrue: [OmniBase signalError: 'Invalid object ID'].
	stream 
		atPosition: (anInteger - 1) * valueLength + start
		putBytesFrom: value
		len: valueLength