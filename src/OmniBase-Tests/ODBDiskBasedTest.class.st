Class {
	#name : #ODBDiskBasedTest,
	#superclass : #OmniBaseTest,
	#instVars : [
		'db'
	],
	#category : #'OmniBase-Tests'
}

{ #category : #accessing }
ODBDiskBasedTest class >> defaultTimeLimit [ 
	^ 5 seconds
]

{ #category : #running }
ODBDiskBasedTest >> createDatabaseOnFileSystem [
	| tmpDB |
	[ tmpDB := OmniBase createOn: self dir ] 
		ensure: [ tmpDB close ]
]

{ #category : #running }
ODBDiskBasedTest >> deleteDatabaseOnFileSystem [
	self dir asFileReference exists ifTrue: [
		self dir asFileReference deleteAll]
]

{ #category : #accessing }
ODBDiskBasedTest >> dir [

	^ (FileLocator imageDirectory  / 'OmniBaseTester') resolve pathString
]

{ #category : #running }
ODBDiskBasedTest >> setUp [
	super setUp.
	self createDatabaseOnFileSystem.
	db := OmniBase openOn: self dir.
]

{ #category : #running }
ODBDiskBasedTest >> tearDown [
	db ifNotNil: [ db close ].
	ODBLockRegistry reset.
	self deleteDatabaseOnFileSystem
]
