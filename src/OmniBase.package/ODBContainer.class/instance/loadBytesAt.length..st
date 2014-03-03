public
loadBytesAt: anInteger length: length 
	| byteArray stream bytesRead |
	(anInteger bitAnd: 1) == 0 
		ifTrue: 
			[dataFileA isNil ifTrue: [dataFileA := ODBObjectStorage openOn: self dataFileNameA].
			stream := dataFileA stream]
		ifFalse: 
			[dataFileB isNil ifTrue: [dataFileB := ODBObjectStorage openOn: self dataFileNameB].
			stream := dataFileB stream].
	byteArray := ByteArray new: length.
	bytesRead := stream 
				atPosition: (anInteger bitShift: -1)
				getBytesFor: byteArray
				len: length.
	bytesRead == length ifTrue: [^byteArray].
	^OmniBase signalError: 'Can not read object'