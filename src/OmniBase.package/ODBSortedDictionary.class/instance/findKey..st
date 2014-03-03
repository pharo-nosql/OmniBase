private
findKey: aKey 
	"Private - Answer index of aKey. If aKey does not 
        exist answer its index as negative integer."

	| a b key i |
	elementCount == 0 ifTrue: [^-1].
	a := 1.
	b := elementCount + 1.
	
	[key := keys at: (i := (a + b) // 2).
	(aKey odbIsLessOrEqualTo: key) 
		ifTrue: 
			[key = aKey ifTrue: [^i].
			b := i]
		ifFalse: [a := i + 1].
	a == b] 
			whileFalse: [].
	^0 - a