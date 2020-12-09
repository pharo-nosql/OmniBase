Class {
	#name : #ODBContainerInfoFile,
	#superclass : #ODBBTreeIterator,
	#category : 'OmniBase'
}

{ #category : #'private/initialization' }
ODBContainerInfoFile >> created [
                "Private - File has just been created."

        stream putWord: 0.
        (self pageClass createOnFile: self
                                        position: rootPagePosition
                                        keyLength: keyLength
                                        valueLength: valueLength) store.
        currentKey := ByteArray new: keyLength.
        stream flush
]

{ #category : #'public/unclassified' }
ODBContainerInfoFile >> defaultObjectSpace [

        ^stream position: self headerLength; getByte
]

{ #category : #'public/unclassified' }
ODBContainerInfoFile >> defaultObjectSpace: anInteger [

	stream position: self headerLength; putByte: anInteger
]

{ #category : #'private/initialization' }
ODBContainerInfoFile >> descriptionString [

    ^'Container Info File
OmniBase 1.0, David Gorisek (c) 1998

'
]

{ #category : #'private/initialization' }
ODBContainerInfoFile >> initialize [
        "Private - Initialize receiver."

    super initialize.
    keyLength := 20.
    valueLength := 4.
    rootPagePosition := self headerLength + 2
]

{ #category : #'public/unclassified' }
ODBContainerInfoFile >> isLocked [

        ^(stream position: self headerLength + 1; getByte) == 1
]

{ #category : #public }
ODBContainerInfoFile >> lock [
	| pos |
	pos := self headerLength + 1.
	self waitForLockAt: pos length: 1.
	
	[(stream
		position: pos;
		getByte) == 0 
		ifFalse: [^false]
		ifTrue: 
			[stream
				position: pos;
				putByte: 1.
			^true]] 
			ensure: [self unlockAt: pos length: 1]
]

{ #category : #'private/initialization' }
ODBContainerInfoFile >> opened [
]

{ #category : #public }
ODBContainerInfoFile >> unlock [
	| pos |
	pos := self headerLength + 1.
	self waitForLockAt: pos length: 1.
	
	[(stream
		position: pos;
		getByte) == 1 
		ifFalse: [^false]
		ifTrue: 
			[stream
				position: pos;
				putByte: 0.
			^true]] 
			ensure: [self unlockAt: pos length: 1]
]
