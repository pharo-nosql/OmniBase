public/accessing
putBytesTo: bytes at: pos

	bytes
		odbLongAt: pos put: index;
		at: pos + 3 put: containerID