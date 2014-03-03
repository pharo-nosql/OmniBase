public
created
	"Create version table for maximum 255 clients."

	stream
		putBytesFrom: (ByteArray new: (255 + 1) * 4);
		flush