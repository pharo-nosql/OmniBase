private
objectStored
	"Sent to transaction object when it is stored for the first time."

	| container |
	changed notNil 
		ifTrue: 
			[container := holder container.
			changed do: 
					[:eachValue | 
					eachValue isRemoved ifFalse: [transaction makePersistent: eachValue object in: container]]]