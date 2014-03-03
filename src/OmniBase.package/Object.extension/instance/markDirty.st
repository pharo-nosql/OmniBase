*omnibase
markDirty
	| t |
	(t := OmniBase currentTransactionOrNil) isNil 
		ifTrue: 
			[(t := self odbGetTransaction) isNil 
				ifTrue: 
					[OmniBase signalError: 'Can not mark object as dirty. Transaction context is unknown. ']].
	t markDirty: self