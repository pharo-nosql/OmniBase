public
position: anInteger 
	"Set current position on stream."

	collections last == current ifTrue: [lastSize < position ifTrue: [lastSize := position]].
	position := anInteger.
	1 to: collections size
		do: 
			[:i | 
			current := collections at: i.
			position <= (readLimit := current size) ifTrue: [^self].
			position := position - readLimit].
	^self error: 'Position outside of stream !'