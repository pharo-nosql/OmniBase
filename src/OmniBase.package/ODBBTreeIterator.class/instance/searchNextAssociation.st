private
searchNextAssociation
	"Private - Search for next association. Answer <nil> if none."

	| page association nextPagePosition |
	page := self lastPage.
	currentKeyExists ifFalse: [association := page currentAssociation].
	[association isNil] whileTrue: 
			[(nextPagePosition := page nextPage) = 0 
				ifFalse: 
					[nextPagePosition isNil 
						ifTrue: 
							[searchPathHeight = 1 
								ifTrue: 
									[nextKey := (ByteArray new: keyLength) atAllPut: 255.
									self clearSearchPath.
									^nil].
							page := self removeLastPage]
						ifFalse: 
							[
							[page := self loadPageAt: nextPagePosition.
							(nextPagePosition := page leftNext) = 0] 
									whileFalse: []]].
			association := page currentAssociation].
	nextKey := currentKey := association key.
	currentKeyExists := true.
	^association