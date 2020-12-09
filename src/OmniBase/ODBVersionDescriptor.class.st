Class {
	#name : #ODBVersionDescriptor,
	#superclass : #Object,
	#instVars : [
		'versionNumber',
		'readVersionNumber',
		'topVersionNumber',
		'committingTransactions',
		'myCommits'
	],
	#category : 'OmniBase'
}

{ #category : #public }
ODBVersionDescriptor >> = anObject [ 
	anObject class == self class ifFalse: [^false].
	^topVersionNumber == anObject topVersionNumber 
		and: [committingTransactions size == anObject committingTransactions size]
]

{ #category : #'private/unclassified' }
ODBVersionDescriptor >> committingTransactions [

        ^committingTransactions
]

{ #category : #'public/unclassified' }
ODBVersionDescriptor >> copy [

    ^self class new
        topVersionNumber: topVersionNumber
        readVersionNumber: readVersionNumber
        committingTransactions: committingTransactions
]

{ #category : #private }
ODBVersionDescriptor >> fromVersionTable: aByteArray [ 
	"Private - Initialize receiver."

	| i vn size |
	topVersionNumber := aByteArray odbLongAt: 1.
	readVersionNumber := topVersionNumber.
	committingTransactions := OrderedCollection new.
	i := 5.
	size := aByteArray size.
	[i < size] whileTrue: 
			[(vn := aByteArray odbLongAt: i) == 0 
				ifFalse: 
					[committingTransactions add: vn.
					vn <= readVersionNumber ifTrue: [readVersionNumber := vn - 1]].
			i := i + 4]
]

{ #category : #'private/unclassified' }
ODBVersionDescriptor >> topVersionNumber [

        ^topVersionNumber
]

{ #category : #'private/unclassified' }
ODBVersionDescriptor >> topVersionNumber: tvn readVersionNumber: rvn committingTransactions: ct [
                "Private - Initialize receiver variables."

        topVersionNumber := tvn.
        readVersionNumber := rvn.
        committingTransactions := ct asArray
]

{ #category : #public }
ODBVersionDescriptor >> versionAtStartOK: aVersionNumber [ 
	"Answer true if object with aVersionNumber can be read. 
	Current transaction commits are ignored."

	aVersionNumber <= readVersionNumber ifTrue: [^true].
	aVersionNumber <= topVersionNumber ifFalse: [^false].
	^(committingTransactions includes: aVersionNumber) not
]

{ #category : #'public/unclassified' }
ODBVersionDescriptor >> versionNumber [
        "Answer version number for read-write transactions."

    ^versionNumber
]

{ #category : #private }
ODBVersionDescriptor >> versionNumber: anInteger [ 
	"Private - Set version number."

	| index |
	(versionNumber := anInteger) isNil 
		ifFalse: 
			[myCommits isNil ifTrue: [myCommits := OrderedCollection new: 4].
			(index := committingTransactions indexOf: anInteger) == 0 
				ifFalse: [committingTransactions at: index put: -1].
			myCommits add: anInteger]
]

{ #category : #public }
ODBVersionDescriptor >> versionOK: aVersionNumber [ 
	"Answer true if object with aVersionNumber can be read."

	aVersionNumber <= readVersionNumber ifTrue: [^true].
	aVersionNumber <= topVersionNumber 
		ifTrue: [^(committingTransactions includes: aVersionNumber) not].
	myCommits isNil ifTrue: [^false].
	^myCommits includes: aVersionNumber
]
