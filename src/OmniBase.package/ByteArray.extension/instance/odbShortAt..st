*omnibase
odbShortAt: index

	^(self at: index) + ((self at: index + 1) bitShift: 8)