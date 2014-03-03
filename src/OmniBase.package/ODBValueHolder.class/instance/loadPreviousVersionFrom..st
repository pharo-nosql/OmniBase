public
loadPreviousVersionFrom: oldHolders 
	| previousVersionPosition |
	previousVersionPosition := self previousVersionPosition.
	previousVersionPosition = 0 
		ifTrue: [contents := ByteArray new: contents size]
		ifFalse: [oldHolders loadAt: previousVersionPosition for: contents]