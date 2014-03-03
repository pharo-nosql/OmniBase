private
odbAboutToCommitIn: anOmniBaseTransaction 
	"Sent before transaction writes changes to the database (right before commit).
	In this method you can use transaction the same way as usual."

	| container |
	container := holder container.
	newKeys keysAndValuesDo: 
			[:eachKey :eachValue | 
			transaction
				makePersistent: eachKey in: container;
				makePersistent: eachValue in: container]