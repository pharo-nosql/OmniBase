Class {
	#name : #ODBClassInfoFile,
	#superclass : #ODBBTreeIterator,
	#category : 'OmniBase'
}

{ #category : #'private/initialization' }
ODBClassInfoFile >> created [
                "Private - File has just been created."

        (self pageClass createOnFile: self
                                        position: rootPagePosition
                                        keyLength: keyLength
                                        valueLength: valueLength) store.
        currentKey := ByteArray new: keyLength.
        stream flush
]

{ #category : #'private/initialization' }
ODBClassInfoFile >> descriptionString [

    ^'Class Info File
OmniBase 1.0, David Gorisek (c) 1998

'
]

{ #category : #public }
ODBClassInfoFile >> initialize [
	"Private - Initialize receiver."

	super initialize.
	keyLength := 128.
	valueLength := 4.
	rootPagePosition := self headerLength
]

{ #category : #'private/initialization' }
ODBClassInfoFile >> opened [
]
