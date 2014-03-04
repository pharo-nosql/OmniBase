private
ensureAccessMode: accessMode forFileStream: aFileStream
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