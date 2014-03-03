public
asStringObject
	"Answer receiver as string
        (selector #asString is not used because of printing on screen)."

	| i string pos len coll bytesSize |
	string := String new: (bytesSize := self size).
	pos := 0.
	i := 1.
	
	[coll := collections at: i.
	len := coll size.
	pos + len < bytesSize] whileTrue: 
				[string 
					replaceFrom: pos + 1
					to: (pos := pos + len)
					with: coll
					startingAt: 1.
				i := i + 1].
	string 
		replaceFrom: pos + 1
		to: bytesSize
		with: coll
		startingAt: 1.
	^string