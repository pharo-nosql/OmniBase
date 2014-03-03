public
nextPage
	"Increase indexOnPage and answer pointer to nextPage. 
        Answer <nil> if indexOnPage equals numberOfItems."

	indexOnPage < self numberOfItems ifFalse: [^nil].
	indexOnPage := indexOnPage + 1.
	^self nextAt: indexOnPage