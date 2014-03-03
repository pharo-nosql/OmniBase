public
unlockKey: aKey with: lockID 
	| result |
	iterator critical: 
			[result := iterator
						goTo: aKey;
						unlockCurrentWith: lockID].
	^result