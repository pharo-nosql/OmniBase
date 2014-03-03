public
isLocked
	"Answer <true> if current key is locked."

	self updateCurrentKey.
	currentKeyExists ifFalse: [^false].
	^self lastPage lockID ~= 0