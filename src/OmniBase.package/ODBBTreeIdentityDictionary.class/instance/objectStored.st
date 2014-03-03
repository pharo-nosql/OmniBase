private
objectStored
	"Sent to transaction object when it is stored for the first time.
	Remove all persistent objects which were put into dictionary before itself was persistent."

	| oid |
	super objectStored.
	newKeys copy keysAndValuesDo: 
			[:eachKey :eachValue | 
			(oid := transaction getObjectIDOrNil: eachKey) isNil 
				ifFalse: 
					[super 
						at: oid
						put: eachValue
						ifLocked: [ODBCannotLockKey signal].
					newKeys removeKey: eachKey]]