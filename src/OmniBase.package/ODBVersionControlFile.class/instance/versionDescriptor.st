public
versionDescriptor
	"Answer read versionDescriptor."

	| versionTable size time |
	(versionDescriptor isNil 
		or: [((time := Time millisecondClockValue) - lastReadTime) abs > 500]) 
			ifTrue: 
				[size := (ODBClientTable maxClients + 1) * 4.
				versionTable := ByteArray new: size.
				stream 
					atPosition: self headerLength
					getBytesFor: versionTable
					len: size.
				lastReadTime := time isNil ifTrue: [Time millisecondClockValue] ifFalse: [time].
				versionDescriptor := ODBVersionDescriptor new fromVersionTable: versionTable].
	^versionDescriptor