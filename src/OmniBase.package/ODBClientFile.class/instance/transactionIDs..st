public
transactionIDs: anArray 
	"Set array of transaction IDs."

	| buf count |
	count := anArray size.
	buf := ByteArray new: count * 4 + 4.
	buf odbLongAt: 1 put: count.
	1 to: count do: [:i | buf odbLongAt: (i * 4) + 1 put: (anArray at: i)].
	stream
		position: self headerLength + 160;
		putBytesFrom: buf;
		flush