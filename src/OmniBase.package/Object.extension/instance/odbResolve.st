*omnibase
odbResolve
	"If this were a proxy object it would resolve itself and answer a real persistent object from the database.
	Since this is not a proxy answer yourself.
	Note: This method is here because in Dolphin 5.1 sending yourself is optimized which means that there is no message
	send involved and a proxy does not fetch an object from the database, instead it answers itself a proxy."

	^self