public
selectKeysStartingWith: aString 
	"Select all keys that start with aString."

	| toKey keys |
	keys := OrderedCollection new.
	aString size > keySize ifTrue: [^keys].
	toKey := aString , ((String new: keySize - aString size) atAllPut: 255 asCharacter).
	self 
		keysFrom: aString
		to: toKey
		do: [:key | keys add: key].
	^keys