Class {
	#name : #ODBStream,
	#superclass : #Object,
	#instVars : [
		'stream'
	],
	#category : #'OmniBase-Streams'
}

{ #category : #public }
ODBStream >> size [
	^ stream size
]
