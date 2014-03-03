private
nextAt: index 
	(contents at: 1) > 127 ifTrue: [^0].
	^self uLongAtOffset: itemLength * self pageSize + 1 + (index * 4)