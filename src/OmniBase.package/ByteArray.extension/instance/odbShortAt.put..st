*omnibase
odbShortAt: index put: longValue

	self
		at: index put: (longValue bitAnd: 16rFF);
		at: index + 1 put: ((longValue bitShift: -8 ) bitAnd: 16rFF)