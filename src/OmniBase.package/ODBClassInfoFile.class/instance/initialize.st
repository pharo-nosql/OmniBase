public
initialize
	"Private - Initialize receiver."

	super initialize.
	keyLength := 128.
	valueLength := 4.
	rootPagePosition := self headerLength