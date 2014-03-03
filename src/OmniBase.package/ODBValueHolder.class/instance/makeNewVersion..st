public
makeNewVersion: oldHolders 
	"Store receiver to oldHolders and make new instance
	of receiver class that points to receiver in oldKeys."

	| position |
	self versionNumber = 0 
		ifTrue: [position := 0]
		ifFalse: [position := oldHolders store: contents].
	^(self class new)
		previousVersionPosition: position;
		updateOn: self