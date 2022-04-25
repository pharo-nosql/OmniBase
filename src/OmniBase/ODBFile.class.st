Class {
	#name : #ODBFile,
	#superclass : #Object,
	#instVars : [
		'stream'
	],
	#category : #'OmniBase-Files'
}

{ #category : #'instance creation' }
ODBFile class >> createOn: aString [

    ^self new createOn: aString
]

{ #category : #'instance creation' }
ODBFile class >> openOn: aFileReference [

    ^self new openOn: aFileReference
]

{ #category : #'create/open/close' }
ODBFile >> close [
        "Close stream associated with receiver."

    stream isNil ifFalse: [
        stream close.
        stream := nil]
]

{ #category : #public }
ODBFile >> compareHeader [
	"Private - Compare bytes in file with file header. Answer <nil>, 
	if the file does not have the appropriate description string."

	| header |
	header := self header.
	
	[(stream compare: (header copyFrom: 2 to: header size) at: 1) 
		ifFalse: [OmniBase signalError: 'File has bad header'].
	self opened] 
			ifCurtailed: [self close]
]

{ #category : #'create/open/close' }
ODBFile >> createOn: aFileReference [
	stream := self 
		newCodecStreamOn: aFileReference 
		using: [ :s | s truncate: 0 ].
    ^ self writeHeader
]

{ #category : #private }
ODBFile >> created [
                "Private - Implemented by subclasses."

        stream flush
]

{ #category : #initialization }
ODBFile >> descriptionString [

    ^'OmniBase File
OmniBase 1.0, David Gorisek (c) 1998

'
]

{ #category : #finalization }
ODBFile >> finalize [

    self close
]

{ #category : #locking }
ODBFile >> flush [
        "Flush stream."

    stream flush
]

{ #category : #private }
ODBFile >> header [
        "Private - Answer receiver's header."

	| header desc |
	header := String new: self headerLength.
	desc := self descriptionString.
	header replaceFrom: 1
		to: desc size
		with: desc
		startingAt: 1.
	^header
]

{ #category : #private }
ODBFile >> headerLength [
        "Private - Answer receiver's header length."

	^128
]

{ #category : #'create/open/close' }
ODBFile >> newCodecStreamOn: aFileReference [

	^ (File named: aFileReference pathString) openForWrite asODBPrimitiveEncodingStream.
]

{ #category : #'create/open/close' }
ODBFile >> newCodecStreamOn: aFileReference using: aBlock [
	| fileStream |
	fileStream := (File named: aFileReference pathString) openForWrite.
	[ aBlock cull: fileStream ]
		ifCurtailed: [ fileStream close. ^ nil ].
	^ fileStream asODBPrimitiveEncodingStream.
]

{ #category : #'create/open/close' }
ODBFile >> openExclusivelyOn: aFileReference [

	stream := self 
		newCodecStreamOn: aFileReference  
		using: [ :s | s shareModeExclusive ].
	^ self compareHeader
]

{ #category : #'create/open/close' }
ODBFile >> openOn: aFileReference [

	stream := self newCodecStreamOn: aFileReference.
	^ self compareHeader
]

{ #category : #'create/open/close' }
ODBFile >> openReadOnlyOn: aFileReference [

	stream := ((File named: aFileReference pathString) openForRead)
		asODBPrimitiveEncodingStream.
    ^self compareHeader
]

{ #category : #private }
ODBFile >> opened [
        "Private - Implemented by subclasses."
]

{ #category : #'create/open/close' }
ODBFile >> remove [
        "Close and remove file coressponding to receiver. 
        Answer <true> if successfull."

    | answer |
    answer := stream remove.
    stream := nil.
    ^answer
]

{ #category : #accessing }
ODBFile >> size [ 

	^ stream size
]

{ #category : #accessing }
ODBFile >> stream [

    ^stream
]

{ #category : #public }
ODBFile >> timeOutLength [
	"Private - Answer number of seconds to wait for lock."

	^7
]

{ #category : #locking }
ODBFile >> unlockAdding [
	"Unlock file for writing at the end of file."

    ^stream unlockAt: 0 length: 1
]

{ #category : #locking }
ODBFile >> unlockAt: pos length: length [
	"Unlock file at pos."

    ^stream unlockAt: pos length: length
]

{ #category : #public }
ODBFile >> waitForAddingLock [
	"Lock file for writing at the end of the file."

	^ self
		waitForLockAt: 0 
		length: 1
]

{ #category : #public }
ODBFile >> waitForLockAt: pos length: length [ 
	"Wait for lock at given position."

	^ self 
		waitForLockAt: pos
		length: length
		whileWaitingDo: [(Delay forMilliseconds: 10) wait]
]

{ #category : #locking }
ODBFile >> waitForLockAt: pos length: length whileWaitingDo: aBlock [
	| startTime currentTime |
	"Wait for lock at given position. Evaluate aBlock in 
	each iteration."

	(stream lockAt: pos length: length) ifFalse: [
		startTime := Time totalSeconds.
		[stream lockAt: pos length: length] whileFalse: [
			aBlock value.
			currentTime := Time totalSeconds.
			currentTime - startTime < self timeOutLength
				ifFalse: [
					ODBLockNotification signal
						ifTrue: [startTime := currentTime]
						ifFalse: [ ^ ODBCannotLock signal ] ] ] ]
]

{ #category : #private }
ODBFile >> writeHeader [
                "Private - Write file header to file and send #created to self."

        stream putBytesFrom: self header.
        ^self created
]
