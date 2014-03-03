public
previousAssociation
	"Answer previous association or <nil> 
        if upper pages have to be loaded."

	| offset |
	(indexOnPage := indexOnPage - 1) < 0 ifTrue: [^nil].
	offset := indexOnPage * itemLength + 2.
	^Association key: (contents copyFrom: offset to: offset + keyLength - 1)
		value: (contents copyFrom: offset + keyLength to: offset + keyLength + valueLength - 1)