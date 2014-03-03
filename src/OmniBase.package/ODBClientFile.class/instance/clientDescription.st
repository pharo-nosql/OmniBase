public
clientDescription
	"Answer client description string."

	| str |
	str := String new: 128.
	stream atPosition: self headerLength getBytesFor: str.
	^(ReadStream on: str) upTo: 0 asCharacter