private
loadError
	| id |
	stream position: stream position - 1.
	id := stream getByte.
	OmniBase 
		signalError: 'OmniBase deserializer: Unknown serialization id (' , id printString , ')'