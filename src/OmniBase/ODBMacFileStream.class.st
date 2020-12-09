Class {
	#name : #ODBMacFileStream,
	#superclass : #ODBFileStream,
	#category : 'OmniBase'
}

{ #category : #private }
ODBMacFileStream class >> createFileStreamForPath: pathString createMode: createMode [
	^ FileStream concreteStream
			perform: (self streamCreationSelectorForMode: createMode)
			with: pathString
]

{ #category : #'create/open' }
ODBMacFileStream class >> createOn: pathString createMode: createMode accessMode: accessMode shareMode: shareMode cacheMode: cacheMode [
	| stream needsWrite |

	stream := self createFileStreamForPath: pathString createMode: createMode.
	
	^	[self ensureAccessMode: accessMode forFileStream: stream.
		self setShareMode: shareMode forFileStream: stream.
	
		self new openOn: pathString fileHandle: stream]
			ifCurtailed: [stream close. nil]
]

{ #category : #private }
ODBMacFileStream class >> ensureAccessMode: accessMode forFileStream: aFileStream [
	"Check the special byte is appropriately set to allow the desired access mode.  Signal a locking conflict if there is a problem.
	See the class comment for more information on what's going on here."
	
	| needsWriteAccess |
	needsWriteAccess := (accessMode = self accessModeReadOnly) not.
	(OSProcess accessor
		isLockableFile: aFileStream
		from: self shareModeFlagLocation
		to: self shareModeFlagLocation
		exclusive: needsWriteAccess)
			ifFalse: [ODBLockingConflict signal].
]

{ #category : #locking }
ODBMacFileStream class >> releaseAllLocksFor: pathName fileHandle: fileHandle [
	OSProcess accessor unlockAllForFile: fileHandle
]

{ #category : #private }
ODBMacFileStream class >> setShareMode: shareMode forFileStream: aFileStream [
	"Set the special byte appropriately for the desired share mode.  Signal a locking conflict if there is a problem.
	See the class comment for more information on what's going on here."
	
	| flagState |
	flagState := shareMode caseOf: {
			[self shareModeShareAll] -> [nil].
			[self shareModeShareRead] -> [false].
			[self shareModeShareNone] -> [true].
			[self shareModeShareWrite] -> [self halt] "don't know how to implement this on unix and it is currently unused"}.

	flagState ifNotNil:
		[(OSProcess accessor
			lockFile: aFileStream
			from: self shareModeFlagLocation
			to: self shareModeFlagLocation
			exclusive: flagState)
				ifNil: [ODBLockingConflict signal]].
]

{ #category : #private }
ODBMacFileStream class >> shareModeFlagLocation [
	"This is the byte location at which the share mode lock is made (see the class comment for details).  This value should probably be less than ODBObjectHolder>>lockStartPosition to avoid conflicts, though it appears that the index file is currently always opened with #shareModeShareAll, so we are actually probably fine in practice."
	
	^ 999999999
]

{ #category : #private }
ODBMacFileStream class >> streamCreationSelectorForMode: createMode [
	^ createMode caseOf:  {
		[self createModeCreateAlways] -> [#forceNewFileNamed:].
		[self createModeCreateNew] -> [#newFileNamed:].
		[self createModeOpenAlways] -> [#fileNamed:].
		[self createModeOpenExisting] -> [#oldFileNamed:]}

]

{ #category : #public }
ODBMacFileStream >> lockAt: pos length: length [
	^ (OSProcess accessor lockFile: fileHandle from: pos to: pos + length -1) notNil
]

{ #category : #public }
ODBMacFileStream >> size [
	"the unix Squeak VM gives the wrong answer for #size"
	| file |
	fileHandle flush.
	file := fileHandle readOnlyCopy.
	^ [file size] ensure: [file close]
	


]

{ #category : #public }
ODBMacFileStream >> unlockAt: pos length: length [
	^ (OSProcess accessor unlockFile: fileHandle from: pos to: pos + length -1) notNil
]
