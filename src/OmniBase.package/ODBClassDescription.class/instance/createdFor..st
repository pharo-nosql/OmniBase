public
createdFor: aClass

	^name = aClass name asString
		and: [ variable = aClass isVariable
		and: [ bytes = aClass isBits
		and: [ instVarNames = (self allPersistentInstanceVariablesFor: aClass) ]]]