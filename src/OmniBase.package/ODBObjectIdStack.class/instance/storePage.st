public
storePage
	| count buf pos subCache |
	count := self cacheSize.
	buf := ByteArray new: count * valueSize.
	pos := 1.
	subCache := cache at: 1.
	1 to: count
		do: 
			[:i | 
			(subCache at: i) putBytesTo: buf at: pos.
			subCache at: i put: nil.
			pos := pos + valueSize].
	stream
		position: filePos;
		putBytesFrom: buf.
	filePos := filePos + buf size.
	cache
		at: 1 put: (cache at: 2);
		at: 2 put: subCache.	"swap halves"
	top := count + 1.
	bottom := 1