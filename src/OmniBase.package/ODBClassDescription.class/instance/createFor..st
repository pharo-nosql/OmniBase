public
createFor: aClass

	class := aClass.
	name := aClass name.
	instVarNames := self allPersistentInstanceVariablesFor: aClass.
	instSize := instVarNames size.
	bytes := aClass isBits.
	variable := aClass isVariable.
	self updateVariableOrder