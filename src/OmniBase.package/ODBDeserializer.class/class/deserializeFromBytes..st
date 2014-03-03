public
deserializeFromBytes: aByteArray 
	| memoryStream referenceManager classManager |
	memoryStream := ODBMemoryReadStream new createOn: aByteArray.
	memoryStream getPositiveInteger = 0 
		ifFalse: [self error: 'External references not defined'].
	classManager := ODBClassManagerForSerialization new.
	classManager loadFromStream: memoryStream.
	^self new 
		deserializeFrom: memoryStream
		referenceManager: nil
		classManager: classManager