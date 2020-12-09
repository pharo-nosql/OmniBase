Class {
	#name : #ODBObjectHolder,
	#superclass : #ODBExternalBuffer,
	#instVars : [
		'container',
		'objectID',
		'oldVersion'
	],
	#category : 'OmniBase'
}

{ #category : #private }
ODBObjectHolder class >> createOn: aByteArray [

    ^self basicNew createOn: aByteArray
]

{ #category : #private }
ODBObjectHolder class >> new [

    ^super new initialize
]

{ #category : #private }
ODBObjectHolder class >> sizeInBytes [
        "Private - Answer number of bytes required to store receiver into a file."

    ^16
]

{ #category : #accessing }
ODBObjectHolder >> container [

    ^container
]

{ #category : #initialization }
ODBObjectHolder >> createOn: aByteArray [
        "Private - Create and initialize receiver."

    contents := aByteArray.
    oldVersion := false
]

{ #category : #accessing }
ODBObjectHolder >> fileID [

    ^self uLongAtOffset: 9
]

{ #category : #accessing }
ODBObjectHolder >> fileID: anInteger [

    self uLongAtOffset: 9 put: anInteger
]

{ #category : #'load/store' }
ODBObjectHolder >> getObject [
        "Answer database object."

    ^(ODBDatabaseObject persistentClassAt: self persistentClassID) new openOn: self
]

{ #category : #initialization }
ODBObjectHolder >> initialize [
        "Private - Initialize receiver."

    oldVersion := false
]

{ #category : #public }
ODBObjectHolder >> isRemoved [
	1 to: contents size do: [:i | (contents at: i) == 0 ifFalse: [^false]].
	^true
]

{ #category : #'load/store' }
ODBObjectHolder >> loadBytes [
        "Load bytes at object position and answer a byte array."

    ^container loadBytesAt: self objectPosition length: self objectLength
]

{ #category : #'load/store' }
ODBObjectHolder >> loadPreviousVersionFrom: oldHolders [
        "Load previous version holder from oldHolders."

    oldVersion := true.
    oldHolders loadAt: self previousVersionPosition for: contents
]

{ #category : #private }
ODBObjectHolder >> lockStartPosition [
        "Answer start position at which object ID locks are set."

		"If using the ODBUnixFileStream, make sure to change #shareModeFlagLocation if you change this value"
    ^1000000000
]

{ #category : #public }
ODBObjectHolder >> lockWith: lockID [ 
	| indexFile |
	oldVersion ifTrue: [^false].
	indexFile := container indexFile.
	
	[(indexFile
		lock: objectID index;
		at: objectID index) = contents 
		ifTrue: [^indexFile stream lockAt: self lockStartPosition + objectID index length: 1].
	oldVersion := true] 
			ensure: [container indexFile unlock: objectID index].
	^false
]

{ #category : #'load/store' }
ODBObjectHolder >> makeNewVersion: oldHolders [

        | position |
        self versionNumber = 0 "new object"
                ifTrue: [ position := 0]
                ifFalse: [ position := oldHolders store: contents ].
        ^(self class createOn: contents shallowCopy)
                setContainer: container objectID: objectID;
                previousVersionPosition: position
]

{ #category : #accessing }
ODBObjectHolder >> objectID [

    ^objectID
]

{ #category : #accessing }
ODBObjectHolder >> objectLength [

    ^((contents at: 10) bitOr: ((contents at: 11) bitShift: 8)) bitOr: ((contents at: 12) bitShift: 16)
]

{ #category : #accessing }
ODBObjectHolder >> objectLength: anInteger [

    contents
        at: 10 put: (anInteger bitAnd: 255);
        at: 11 put: ((anInteger bitShift: -8) bitAnd: 255);
        at: 12 put: (anInteger bitShift: -16)
]

{ #category : #accessing }
ODBObjectHolder >> objectPosition [

    ^self uLongAtOffset: 12
]

{ #category : #accessing }
ODBObjectHolder >> objectPosition: anInteger [

    self uLongAtOffset: 12 put: anInteger
]

{ #category : #accessing }
ODBObjectHolder >> oldVersion [

    ^oldVersion
]

{ #category : #accessing }
ODBObjectHolder >> persistentClassID [

    ^contents at: 9
]

{ #category : #accessing }
ODBObjectHolder >> persistentClassID: anInteger [

    contents at: 9 put: anInteger
]

{ #category : #accessing }
ODBObjectHolder >> previousVersionPosition [

    ^self uLongAtOffset: 4
]

{ #category : #accessing }
ODBObjectHolder >> previousVersionPosition: anInteger [

    self uLongAtOffset: 4 put: anInteger
]

{ #category : #public }
ODBObjectHolder >> printOn: aStream [ 
	super printOn: aStream.
	aStream nextPut: $(.
	objectID printOn: aStream.
	aStream nextPutAll: ';version='.
	self versionNumber printOn: aStream.
	aStream nextPutAll: ';pid='.
	self persistentClassID printOn: aStream.
	aStream nextPut: $)
]

{ #category : #accessing }
ODBObjectHolder >> rootObjectID [
        "Answer root object ID for root object holder."

    ^ODBObjectID new fromBytes: contents at: 10
]

{ #category : #accessing }
ODBObjectHolder >> rootObjectID: anObjectID [
        "Set root object ID for root object holder."

    anObjectID putBytesTo: contents at: 10
]

{ #category : #private }
ODBObjectHolder >> setContainer: aContainer [ 
	container := aContainer
]

{ #category : #initialization }
ODBObjectHolder >> setContainer: aContainer objectID: anObjectID [

    objectID := anObjectID.
    container := aContainer
]

{ #category : #public }
ODBObjectHolder >> store [
	"Store contents to indexFile."

	| indexFile index |
	
	[(indexFile := container indexFile)
		lock: (index := objectID index);
		at: index put: contents] 
			ensure: [indexFile unlock: index]
]

{ #category : #'load/store' }
ODBObjectHolder >> storeBytes: aByteArray [

    self objectLength: aByteArray size.
    container addByteStorageRequest: (ODBByteStorageRequest new
                                        objectHolder: self bytes: aByteArray)
]

{ #category : #public }
ODBObjectHolder >> unlockWith: lockID [ 
	oldVersion ifTrue: [^false].
	^container indexFile stream unlockAt: self lockStartPosition + objectID index length: 1
]

{ #category : #accessing }
ODBObjectHolder >> versionNumber [

    ^self uLongAtOffset: 0
]

{ #category : #accessing }
ODBObjectHolder >> versionNumber: anInteger [

    self uLongAtOffset: 0 put: anInteger
]
