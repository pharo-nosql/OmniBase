public
loadPage
	| count buf pos subCache |
	count := self cacheSize.
	buf := ByteArray new: count * valueSize.
	stream
		position: filePos - buf size;
		getBytesFor: buf.
	pos := 1.
	subCache := cache at: 1.
	1 to: count
		do: 
			[:i | 
			subCache at: i put: (ODBObjectID new fromBytes: buf at: pos).
			pos := pos + valueSize].
	filePos := filePos - buf size.
	top := count + 1.
	bottom := 1