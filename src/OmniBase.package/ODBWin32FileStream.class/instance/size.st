public
size
	"Answer the size of the file in bytes or
	signal a FileException if the operation fails."

	| result |
	result := self getFileSize: fileHandle lpFileSizeHigh: nil.
	^16rFFFFFFFF = result ifFalse: [result] ifTrue: [self fileIOError]