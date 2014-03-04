private
setShareMode: shareMode forFileStream: aFileStream
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