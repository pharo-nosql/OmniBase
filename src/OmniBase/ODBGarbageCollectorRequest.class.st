Class {
	#name : #ODBGarbageCollectorRequest,
	#superclass : #ODBByteStorageRequest,
	#category : 'OmniBase'
}

{ #category : #public }
ODBGarbageCollectorRequest >> bytesStored [
	objectHolder container indexFile at: objectHolder objectID index
		put: objectHolder contents
]
