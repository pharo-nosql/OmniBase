"
This class implements an ODBFileStream for *nix filesystems using the locking mechanism provided in the OSProcess package.

The main thing it needs to do is map the various windows-like mode flags to Unix equivalents.  The ugliest ones to map (aside from FILE_FLAG_ATOMIC_WRITE and FILE_FLAG_SEQUENTIAL_SCAN, which we ignore) are the share mode flags.

In Windows, when you open a file you can specify what read modes will succeed on future calls to open the same file.  So, if you specify FILE_SHARE_READ but not FILE_SHARE_WRITE, another application would be able to open the file in read mode but not in read-write mode. Unix does not support this concept since locks are advisory and have no effect on an whether another application can open a file for reading or writing later.
	
The best approximation I can come up with is to lock a special byte.  If you want to write to the file you need to able to get a write-lock on that byte.  If you only want to read the file, you only need to be able to read-lock that byte.  Note that you don't actually perform this lock, you just test for it.  Then you lock the byte based on what you want to allow other applications to do.
"
Class {
	#name : #ODBUnixFileStream,
	#superclass : #ODBFileStream,
	#category : #'OmniBase-Streams'
}

{ #category : #private }
ODBUnixFileStream class >> createFileStreamForPath: pathString createMode: createMode [

	^ File
		perform: (self streamCreationSelectorForMode: createMode)
		with: pathString
]

{ #category : #'create/open' }
ODBUnixFileStream class >> createOn: pathString createMode: createMode accessMode: accessMode shareMode: shareMode cacheMode: cacheMode [
	| stream |

	stream := self createFileStreamForPath: pathString createMode: createMode.
	
	^	[self ensureAccessMode: accessMode forFileStream: stream.
		self setShareMode: shareMode forFileStream: stream.
	
		self new openOn: pathString fileHandle: stream]
			ifCurtailed: [stream close. nil]
]

{ #category : #private }
ODBUnixFileStream class >> ensureAccessMode: accessMode forFileStream: aFileStream [
	"Check the special byte is appropriately set to allow the desired access mode.  Signal a locking conflict if there is a problem.
	See the class comment for more information on what's going on here."
	| needsWriteAccess |
	
	needsWriteAccess := accessMode ~= self accessModeReadOnly.
	(FLock
		canLock: aFileStream fileHandle
			from: self shareModeFlagLocation
			to: self shareModeFlagLocation
			exclusive: needsWriteAccess)
		ifFalse: [ ODBLockingConflict signal ]
]

{ #category : #private }
ODBUnixFileStream class >> setShareMode: shareMode forFileStream: aFileStream [
	"Set the special byte appropriately for the desired share mode.  Signal a locking conflict if there is a problem.
	See the class comment for more information on what's going on here."
	| flagState |

	flagState := shareMode caseOf: {
			[self shareModeShareAll] -> [nil].
			[self shareModeShareRead] -> [false].
			[self shareModeShareNone] -> [true].
			[self shareModeShareWrite] -> [self error: 'not supported'] "don't know how to implement this on unix and it is currently unused"}.

	flagState ifNotNil: [
		(FLock
			lock: aFileStream fileHandle
				from: self shareModeFlagLocation
				to: self shareModeFlagLocation
				exclusive: flagState)
			ifNil: [ ODBLockingConflict signal ] ]
]

{ #category : #private }
ODBUnixFileStream class >> shareModeFlagLocation [
	"This is the byte location at which the share mode lock is made (see the class comment for details).  This value should probably be less than ODBObjectHolder>>lockStartPosition to avoid conflicts, though it appears that the index file is currently always opened with #shareModeShareAll, so we are actually probably fine in practice."
	
	^ 999999999
]

{ #category : #private }
ODBUnixFileStream class >> streamCreationSelectorForMode: createMode [
	^ createMode caseOf:  {
		[self createModeCreateAlways] -> [#openAndTruncateForWriteFileNamed:].
		[self createModeCreateNew] -> [#openForWriteFileNamed:].
		[self createModeOpenAlways] -> [#openForWriteFileNamed:].
		[self createModeOpenExisting] -> [#openForWriteFileNamed:]}

]

{ #category : #public }
ODBUnixFileStream >> close [
	"Close file associatied with receiver."

	fileHandle notNil ifTrue: [
		FLock 
			unlock: fileHandle fileHandle 
			from: 0 
			to: self size.
		fileHandle closed ifFalse: [ fileHandle close ] ].
	fileHandle := nil.
]

{ #category : #public }
ODBUnixFileStream >> lockAt: pos length: length [
	
	^ FLock 
		lock: fileHandle fileHandle
		from: pos 
		to: pos + length - 1
]

{ #category : #public }
ODBUnixFileStream >> unlockAt: pos length: length [

	^ FLock 
		unlock: fileHandle fileHandle
		from: pos 
		to: pos + length -1
]
