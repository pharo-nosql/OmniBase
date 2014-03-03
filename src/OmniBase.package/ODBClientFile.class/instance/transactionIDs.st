public
transactionIDs
	"Answer array of transaction IDs."

	| buf array count |
	buf := ByteArray new: 128.
	stream
		position: self headerLength + 160;
		getBytesFor: buf.
	count := buf odbLongAt: 1.
	array := Array new: count.
	1 to: (count min: 31) do: [:i | array at: i put: (buf odbLongAt: (i * 4) + 1)].
	count > 31 
		ifTrue: 
			[buf := ByteArray new: (count - 31) * 4.
			stream getBytesFor: buf.
			32 to: count do: [:i | array at: i put: (buf odbLongAt: (i * 4) - 127)]].
	^array