public
isKey: keyBytes at: startPos lessThan: key2 
	"Private - Answer <true> if key located at keyBytes from startPos + 1 
        is less than key2. Answer <nil> if keys are equal."

	| b1 b2 |
	1 to: keyLength
		do: [:i | (b1 := keyBytes at: startPos + i) == (b2 := key2 at: i) ifFalse: [^b1 < b2]].
	^nil