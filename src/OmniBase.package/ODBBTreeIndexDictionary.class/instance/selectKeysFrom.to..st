public
selectKeysFrom: prefix1 to: prefix2 
	"Select all keys between prefix1 and prefix2."

	| toKey keys |
	keys := OrderedCollection new.
	prefix1 size > keySize ifTrue: [^keys].
	toKey := prefix2 , ((String new: keySize - prefix2 size) atAllPut: 255 asCharacter).
	self 
		keysFrom: prefix1
		to: toKey
		do: [:key | keys add: key].
	^keys