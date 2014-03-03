public
getCurrent
	"Answer association at current key or <nil> if none."

	self updateCurrentKey.
	currentKeyExists ifFalse: [^nil].
	^self lastPage association