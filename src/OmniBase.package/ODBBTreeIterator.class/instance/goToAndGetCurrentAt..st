public
goToAndGetCurrentAt: aKey 
	| result |
	mutex critical: 
			[result := self
						goTo: aKey;
						getCurrent].
	^result