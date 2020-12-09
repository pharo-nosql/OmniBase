Class {
	#name : #ODBIDTable,
	#superclass : #ODBFile,
	#instVars : [
		'lastID'
	],
	#category : 'OmniBase'
}

{ #category : #public }
ODBIDTable >> add: anInteger [ 
	"Store anInteger and answer its ID."

	lastID := self getLastID + 1.
	stream
		atPosition: lastID * 4 + self headerLength putLong: anInteger;
		atPosition: self headerLength putLong: lastID.
	^lastID
]

{ #category : #public }
ODBIDTable >> at: anInteger [ 
	"Answer <position> at anInteger or <nil> if absent."

	anInteger > lastID ifTrue: [anInteger > self getLastID ifTrue: [^nil]].
	^stream atPositionGetLong: anInteger * 4 + self headerLength
]

{ #category : #public }
ODBIDTable >> at: anInteger ifAbsent: aBlock [ 
	"Answer <position> at anInteger. Evaluate aBlock if absent."

	anInteger > lastID ifTrue: [anInteger > self getLastID ifTrue: [^aBlock value]].
	^stream atPositionGetLong: anInteger * 4 + self headerLength
]

{ #category : #public }
ODBIDTable >> at: anInteger put: aPosition [ 
	"Put aPosition at anInteger."

	^stream atPosition: anInteger * 4 + self headerLength putLong: aPosition
]

{ #category : #'private/unclassified' }
ODBIDTable >> created [
                "Private - Initialize lastID count."

        stream putLong: 0; flush
]

{ #category : #'private/initialization' }
ODBIDTable >> descriptionString [

    ^'OmniBase ID Table
OmniBase 1.0, David Gorisek (c) 1998

'
]

{ #category : #public }
ODBIDTable >> getLastID [
	"Answer value of last ID in file."

	^lastID := stream atPositionGetLong: self headerLength
]

{ #category : #public }
ODBIDTable >> indexesAndValuesDo: aBlock [ 
	1 to: self getLastID do: [:index | aBlock value: index value: (self at: index)]
]

{ #category : #'private/initialization' }
ODBIDTable >> initialize [

    lastID := 0
]
