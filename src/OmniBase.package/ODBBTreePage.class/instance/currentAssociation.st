public
currentAssociation
	"Answer current association or <nil> 
        if upper pages have to be loaded."

	^(indexOnPage == self numberOfItems or: [indexOnPage < 0]) ifFalse: [self association]