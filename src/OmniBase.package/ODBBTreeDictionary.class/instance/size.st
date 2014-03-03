public
size
	"Answer number of keys in receiver.
	(metodo je treba spremeniti, ce so reference na objekte iz 
	transakcije weak -> sizeHolder mora biti iz verzije pred startom transakcije)"

	^initialSize + deltaSize