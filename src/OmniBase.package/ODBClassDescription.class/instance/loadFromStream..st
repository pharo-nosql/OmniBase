public
loadFromStream: aStream

	name := aStream getString.
	bytes := aStream getBoolean.
	variable := aStream getBoolean.
	instSize := aStream getPositiveInteger.
	instVarNames := Array new: instSize.
	1 to: instSize do: [:i | instVarNames at: i put: aStream getString].
	self updateVariableOrder.