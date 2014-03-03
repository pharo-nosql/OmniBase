private
updateVariableOrder
	| realNames |
	class := Smalltalk at: name asSymbol ifAbsent: [].
	varOrder := Array new: instVarNames size.
	class isNil 
		ifTrue: [varOrder atAllPut: 1]
		ifFalse: 
			[realNames := class allInstVarNames.
			1 to: varOrder size
				do: 
					[:i | 
					(varOrder at: i put: (realNames indexOf: (instVarNames at: i))) = 0 
						ifTrue: [varOrder at: i put: realNames size + 1]].
			instVarIndexes := Array new: instVarNames size.
			1 to: instVarNames size
				do: [:i | instVarIndexes at: i put: (class allInstVarNames indexOf: (instVarNames at: i))]]