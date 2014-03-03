public
size
	"Answer stream size."

	| size count |
	current isNil ifTrue: [^0].
	size := 0.
	count := collections size.
	1 to: count - 1 do: [:i | size := size + (collections at: i) size].
	current == (collections at: count) 
		ifTrue: [lastSize < position ifTrue: [lastSize := position]].
	^size + lastSize