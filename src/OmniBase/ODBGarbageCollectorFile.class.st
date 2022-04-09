Class {
	#name : #ODBGarbageCollectorFile,
	#superclass : #ODBFile,
	#instVars : [
		'status'
	],
	#category : #'OmniBase-GC'
}

{ #category : #public }
ODBGarbageCollectorFile >> createOn: aFileReference [ 
	"Create garbage collector file. Answer <nil> if failed."
	stream := self 
		newCodecStreamOn: aFileReference 
		using: [ :s | 
			s 
				truncate: 0;
				shareModeRead ].
	^ self writeHeader
]

{ #category : #public }
ODBGarbageCollectorFile >> created [
	"status=1 byte"

	"new object space=1 byte"

	stream
		putBytesFrom: (ByteArray new: 4);
		flush
]

{ #category : #public }
ODBGarbageCollectorFile >> newObjectSpace [
	"Answer garbage collector new object space."

	^stream
		position: self headerLength + 1;
		getByte
]

{ #category : #public }
ODBGarbageCollectorFile >> newObjectSpace: anInteger [ 
	"Set garbage collector new object space."

	stream
		position: self headerLength + 1;
		putByte: anInteger;
		flush
]

{ #category : #public }
ODBGarbageCollectorFile >> openOn: aFileReference [ 
	"Open garbage collector file. Signal an error if failed."
	
	stream := self 
		newCodecStreamOn: aFileReference  
		using: [ :s | s shareModeRead ].
	^ self compareHeader
]

{ #category : #public }
ODBGarbageCollectorFile >> status [
	"Answer garbage collector status."

	status isNil 
		ifTrue: 
			[status := stream
						position: self headerLength;
						getByte].
	^status
]

{ #category : #public }
ODBGarbageCollectorFile >> status: anInteger [ 
	"Set garbage collector status."

	status := anInteger.
	stream
		position: self headerLength;
		putByte: anInteger;
		flush
]
