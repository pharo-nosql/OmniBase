public
isRemoved
	"Answer <true> if the key has been removed 
	(there is no value associated with it)."

	removed isNil ifFalse: [^removed].
	^removed := (self uLongAtOffset: 8) = 0