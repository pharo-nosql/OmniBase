private
fromVersionTable: aByteArray 
	"Private - Initialize receiver."

	| i vn size |
	topVersionNumber := aByteArray odbLongAt: 1.
	readVersionNumber := topVersionNumber.
	committingTransactions := OrderedCollection new.
	i := 5.
	size := aByteArray size.
	[i < size] whileTrue: 
			[(vn := aByteArray odbLongAt: i) == 0 
				ifFalse: 
					[committingTransactions add: vn.
					vn <= readVersionNumber ifTrue: [readVersionNumber := vn - 1]].
			i := i + 4]