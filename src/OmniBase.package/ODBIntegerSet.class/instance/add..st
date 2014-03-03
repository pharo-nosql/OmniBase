public
add: anInteger 
	| pageNumber i j |
	pageNumber := anInteger bitShift: -15.	"-12-3=-15"
	i := ((anInteger bitAnd: 32767) bitShift: -3) + 1.	"8*4096=32768"
	j := 1 bitShift: (anInteger bitAnd: 7).
	self loadPage: pageNumber.
	((bitField at: i) bitAnd: j) == 0 
		ifTrue: 
			[changed := true.
			bitField at: i put: ((bitField at: i) bitOr: j)]