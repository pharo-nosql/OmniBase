Class {
	#name : #ODBGarbageCollectorRequest,
	#superclass : #ODBByteStorageRequest,
	#category : #'OmniBase-Storage'
}

{ #category : #'public/unclassified' }
ODBGarbageCollectorRequest >> bytesStored [
	objectHolder container indexFile at: objectHolder objectID index
		put: objectHolder contents
]
