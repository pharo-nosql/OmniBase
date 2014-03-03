public
positionToCachedKey: aKey 
	"Search for aKey on page. Answer <true> if found. 
        If not answer position of child page where aKey could 
        be located. Answer 0 if this is a leaf page. Answer 
        <nil> if position can not be determined (i.e. indexOnPage 
        is at the start or at the end of this page)."

	| n min max result flag |
	min := 0.
	max := n := (flag := contents at: 1) bitAnd: 127.
	indexOnPage := max bitShift: -1.
	n == 0 ifTrue: [^nil].
	
	[(result := iterator 
				isKey: contents
				at: indexOnPage * itemLength + 1
				lessThan: aKey) isNil 
		ifTrue: [^true].
	result ifTrue: [min := indexOnPage + 1] ifFalse: [max := indexOnPage].
	min == max] 
			whileFalse: [indexOnPage := min + max bitShift: -1].
	(indexOnPage := min) == n ifTrue: [^nil].
	indexOnPage == 0 ifTrue: [^nil].
	"Optimization for: ^self nextAt: indexOnPage"
	flag > 127 ifTrue: [^0].
	"PAGE SIZE=32 (bitShift: 5)"
	^self uLongAtOffset: (itemLength bitShift: 5) + 1 + (indexOnPage bitShift: 2)