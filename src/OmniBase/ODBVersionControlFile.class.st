Class {
	#name : #ODBVersionControlFile,
	#superclass : #ODBFile,
	#instVars : [
		'lastReadTime',
		'versionDescriptor'
	],
	#category : #'OmniBase-Files'
}

{ #category : #public }
ODBVersionControlFile >> created [
	"Create version table for maximum 255 clients."

	stream
		putBytesFrom: (ByteArray new: (255 + 1) * 4);
		flush
]

{ #category : #'private/initialization' }
ODBVersionControlFile >> descriptionString [

    ^'OmniBase Version Control
OmniBase 1.0, David Gorisek (c) 1998

'
]

{ #category : #public }
ODBVersionControlFile >> getNewVersionNumberFor: clientID [ 
	"Answer new version number for clientID."

	| versionNumber |
	(clientID > 0 and: [clientID <= ODBClientTable maxClients]) 
		ifFalse: [OmniBase signalError: 'Bad OmniBase connection ID'].
	self waitForLockAt: self headerLength length: 4.
	versionNumber := (stream atPositionGetLong: self headerLength) + 1.
	stream
		atPosition: self headerLength putLong: versionNumber;
		atPosition: clientID * 4 + self headerLength putLong: versionNumber;
		flush.
	self unlockAt: self headerLength length: 4.
	^versionNumber
]

{ #category : #public }
ODBVersionControlFile >> removeCommittingFor: clientID [ 
	"Remove committing version number for clientID."

	(clientID > 0 and: [clientID <= ODBClientTable maxClients]) 
		ifFalse: [OmniBase signalError: 'Bad client ID'].
	stream atPosition: clientID * 4 + self headerLength putLong: 0.
	versionDescriptor := nil
]

{ #category : #public }
ODBVersionControlFile >> versionDescriptor [
	"Answer read versionDescriptor."

	| versionTable size time |
	(versionDescriptor isNil or: [ 
		 ((time := Time millisecondClockValue) - lastReadTime) abs > 500 ]) 
		ifTrue: [ 
			size := ODBClientTable maxClients + 1 * 4.
			versionTable := ByteArray new: size.
			stream
				atPosition: self headerLength
				getBytesFor: versionTable
				len: size.
			lastReadTime := time
				                ifNil: [ Time millisecondClockValue ]
				                ifNotNil: [ time ].
			versionDescriptor := ODBVersionDescriptor new fromVersionTable: versionTable ].
	^ versionDescriptor
]
