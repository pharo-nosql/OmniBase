Class {
	#name : #ODBLockRegistryTest,
	#superclass : #ODBDiskBasedTest,
	#category : #'OmniBase-Tests'
}

{ #category : #tests }
ODBLockRegistryTest >> testRegisterByOpeningDatabase [ 
	self assert: ODBLockRegistry registeredPaths size equals: 1
]
