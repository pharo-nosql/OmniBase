public
unlock: index 
	"Unlock  <value> at index."

	self unlockAt: (index - 1) * valueLength + start length: valueLength