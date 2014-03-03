*omnibase
odbAboutToCommitIn: anOmniBaseTransaction 
	"Sent before transaction writes changes to the database (right before commit).
	In this method you can use transaction the same way as usual.
	Do nothing by default."

	