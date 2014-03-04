private
shareModeFlagLocation
	"This is the byte location at which the share mode lock is made (see the class comment for details).  This value should probably be less than ODBObjectHolder>>lockStartPosition to avoid conflicts, though it appears that the index file is currently always opened with #shareModeShareAll, so we are actually probably fine in practice."
	
	^ 999999999