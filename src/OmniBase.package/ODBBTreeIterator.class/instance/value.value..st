public
value: key1 value: key2 
	"Answer <true> if key1 is less or equal to key2. 
	Receiver can be used as sortBlock for SortedCollection."

	| s1 s2 a1 a2 |
	s1 := key1 size.
	s2 := key2 size.
	1 to: keyLength
		do: 
			[:i | 
			i > s1 ifTrue: [a1 := 0] ifFalse: [a1 := key1 at: i].
			i > s2 ifTrue: [a2 := 0] ifFalse: [a2 := key2 at: i].
			a1 = a2 ifFalse: [^a1 < a2]].
	^true