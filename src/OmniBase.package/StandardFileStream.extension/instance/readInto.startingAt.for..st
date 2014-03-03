*omnibase
readInto: aString startingAt: startIndex for: n
	"Read n bytes into the given string."
	^self primRead: fileID into: aString
				startingAt: startIndex count: n.