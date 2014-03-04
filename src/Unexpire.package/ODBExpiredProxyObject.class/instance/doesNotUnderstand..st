public
doesNotUnderstand: aMessage
	
	| currentTransaction freshTarget |

	[currentTransaction := OmniBase currentTransaction] 
		on: ODBNoActiveTransaction
		do:[:x| ODBMessageSentToAnExpiredObject signal].
		
	^ currentTransaction isAborted
		ifTrue: [ODBMessageSentToAnExpiredObject signal]
		ifFalse:[ 
			freshTarget := currentTransaction objectAt: oid.
			self becomeForward: freshTarget.
			freshTarget 
				perform: aMessage selector
				withArguments: aMessage arguments]. 
