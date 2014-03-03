*omnibase
odbAsInteger
	| result each negative |
	result := 0.
	1 to: self size
		do: 
			[:i | 
			each := self at: i.
			i = 1 
				ifTrue: 
					[result := each bitAnd: 15.
					each > 31 ifTrue: [negative := true]]
				ifFalse: [result := result * 100 + (each bitAnd: 15) + ((each bitShift: -4) * 10)]].
	negative = true ifTrue: [^0 - result].
	^result