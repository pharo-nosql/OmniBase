private
searchPreviousAssociation
	"Private - Search for the previous association. Answer <nil> if none."

	| page association pagePosition |
	page := self lastPage.
	[association isNil] whileTrue: 
			[(pagePosition := page previousPage) = 0 
				ifFalse: 
					[pagePosition isNil 
						ifTrue: 
							[searchPathHeight = 1 
								ifTrue: 
									[nextKey := ByteArray new: keyLength.
									self clearSearchPath.
									^nil].
							page := self removeLastPage]
						ifFalse: 
							[
							[page := self loadPageAt: pagePosition.
							(pagePosition := page rightNext) = 0] 
									whileFalse: []]].
			association := page previousAssociation].
	nextKey := currentKey := association key.
	currentKeyExists := true.
	^association