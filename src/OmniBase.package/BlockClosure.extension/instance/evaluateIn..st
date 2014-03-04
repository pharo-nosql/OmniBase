*omnibase
evaluateIn: anOmniBaseTransaction
		"Evaluate the receiver block while setting the current transaction 
		to anOmniBaseTransaction. If an error occurs during execution of
		this block the transaction will be rolled back. Answer the result of
		the block."

	| activeProcess previousTxn |
	activeProcess := Processor activeProcess.
	previousTxn := OmniBase getCurrentAndSet: anOmniBaseTransaction for: activeProcess.
	^[self ifCurtailed: [anOmniBaseTransaction abort]]
		ensure: [
			previousTxn isNil
				ifTrue: [OmniBase removeFor: activeProcess]
				ifFalse: [OmniBase setTransaction: previousTxn for: activeProcess]]