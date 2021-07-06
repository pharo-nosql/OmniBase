Class {
	#name : #ODBObjectManagerTest,
	#superclass : #ODBDiskBasedTest,
	#instVars : [
		'objectManager'
	],
	#category : #'OmniBase-Tests'
}

{ #category : #initialization }
ODBObjectManagerTest >> setUp [ 
	super setUp.
	objectManager := db objectManager.
]

{ #category : #running }
ODBObjectManagerTest >> tearDown [ 
	super tearDown.
	objectManager := nil
]

{ #category : #tests }
ODBObjectManagerTest >> testDefaultIsOneContainer [
	self assert: objectManager containers size equals: 1
]
