*omnibase
odbLongAt: index

	^(self at: index) +
		((self at: index + 1) bitShift: 8) +
		((self at: index + 2) bitShift: 16) +
		((self at: index + 3) bitShift: 24)