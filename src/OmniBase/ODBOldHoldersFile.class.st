Class {
	#name : #ODBOldHoldersFile,
	#superclass : #ODBFile,
	#instVars : [
		'buffer',
		'bufPos',
		'filePos'
	],
	#category : 'OmniBase'
}

{ #category : #public }
ODBOldHoldersFile >> allocateBuffer [
	"Private - Allocate space in file for buffer so that less locking 
	and file I/O calls are needed when transaction is committing."

	self waitForAddingLock.
	
	[filePos := stream setToEnd.
	stream truncate: filePos + 512] ensure: [self unlockAdding].
	buffer := ByteArray new: 512.
	bufPos := 0
]

{ #category : #'private/initialization' }
ODBOldHoldersFile >> descriptionString [

    ^'OmniBase Old Holders
OmniBase 1.0, David Gorisek (c) 1998

'
]

{ #category : #public }
ODBOldHoldersFile >> flush [
	(buffer isNil or: [bufPos == 0]) ifTrue: [^self].
	stream 
		atPosition: filePos
		putBytesFrom: buffer
		len: bufPos.
	buffer size - bufPos < 16 
		ifTrue: [buffer := nil]
		ifFalse: 
			[filePos := filePos + bufPos.
			buffer := buffer copyFrom: bufPos + 1 to: buffer size.
			bufPos := 0]
]

{ #category : #public }
ODBOldHoldersFile >> loadAt: anInteger for: aByteArray [ 
	"Load holder contents at position anInteger."

	anInteger == 0 ifTrue: [OmniBase signalError: 'Previous version position error !'].
	stream atPosition: anInteger getBytesFor: aByteArray
]

{ #category : #public }
ODBOldHoldersFile >> store: aByteArray [ 
	"Store holder contents and answer its position on the stream."

	| result |
	buffer isNil 
		ifTrue: [self allocateBuffer]
		ifFalse: 
			[buffer size - bufPos < aByteArray size 
				ifTrue: 
					[self
						flush;
						allocateBuffer]].
	buffer 
		replaceFrom: bufPos + 1
		to: bufPos + aByteArray size
		with: aByteArray
		startingAt: 1.
	result := filePos + bufPos.
	bufPos := bufPos + aByteArray size.
	^result
]

{ #category : #'private/unclassified' }
ODBOldHoldersFile >> truncate [

	stream truncate: self headerLength
]
