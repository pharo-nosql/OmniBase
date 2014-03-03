public
flushBytes
	"Store byte array queue to dataFile and update object holders in queue."

	| pos bufPos stream buf size bytes objectPosition |
	queueSize == 0 ifTrue: [^self].
	self lockDataFile.
	stream := activeDataFile stream.
	pos := stream setToEnd.
	buf := ByteArray new: queueSize.
	bufPos := 0.
	byteStorageQueue do: 
			[:each | 
			bytes := each bytes.
			size := bytes size.
			buf 
				replaceFrom: bufPos + 1
				to: bufPos + size
				with: bytes
				startingAt: 1.
			objectPosition := pos + bufPos bitShift: 1.
			activeDataFile == dataFileA 
				ifTrue: [each objectPosition: objectPosition]
				ifFalse: [each objectPosition: (objectPosition bitOr: 1)].
			bufPos := bufPos + size].
	stream
		atPosition: pos
			putBytesFrom: buf
			len: queueSize;
		flush.
	activeDataFile unlockAdding.
	byteStorageQueue do: [:each | each bytesStored].
	byteStorageQueue := OrderedCollection new.
	queueSize := 0