public
createMax65536From: bytes 
	"Update receiver from bytes. Answer number of bytes used."

	| pos oidSize refsSize |
	references := Array new: (refsSize := ((bytes at: 2) bitShift: 8) + (bytes at: 1) + 1).
	pos := 3.
	oidSize := ODBObjectID sizeInBytes.
	1 to: refsSize
		do: 
			[:i | 
			references at: i put: (ODBObjectID new fromBytes: bytes at: pos).
			pos := pos + oidSize].
	^pos - 1