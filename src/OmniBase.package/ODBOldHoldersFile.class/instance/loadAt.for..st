public
loadAt: anInteger for: aByteArray 
	"Load holder contents at position anInteger."

	anInteger == 0 ifTrue: [OmniBase signalError: 'Previous version position error !'].
	stream atPosition: anInteger getBytesFor: aByteArray