private
moveToNext
	"Private - Move to next collection or
        add space on end of stream if at last collection."

	position := 0.
	(current isNil or: [current == collections last]) 
		ifTrue: 
			[collections add: (current := ByteArray new: (readLimit := 1024)).
			lastSize := 0]
		ifFalse: 
			[1 to: collections size
				do: [:i | (collections at: i) == current ifTrue: [^current := collections at: i + 1]]]