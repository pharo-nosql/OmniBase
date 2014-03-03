public
position
	"Answer current position on stream."

	| i size coll |
	current isNil ifTrue: [^0].
	i := 1.
	size := 0.
	[(coll := collections at: i) == current] whileFalse: 
			[i := i + 1.
			size := size + coll size].
	^size + position