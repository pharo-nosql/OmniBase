public
writeOn: aStream 
	"Write receivers contents on aStream."

	| count |
	aStream putLong: self size.
	(count := collections size) == 0 
		ifFalse: 
			[1 to: count - 1 do: [:i | aStream putBytesFrom: (collections at: i)].
			aStream putBytesFrom: (collections at: count) len: lastSize]