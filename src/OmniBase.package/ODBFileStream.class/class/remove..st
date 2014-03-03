directory operations
remove: fileName
	"Remove file named fileName. Answer <true> if successful, <false> if failed."

	[ fileName asFileReference delete.
		^true ]
			on: Error
			do: [:ex | ^false ]