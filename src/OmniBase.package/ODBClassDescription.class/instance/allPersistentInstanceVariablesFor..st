private
allPersistentInstanceVariablesFor: aClass 
	^(aClass allInstVarNames 
		reject: [:each | aClass odbTransientInstanceVariables includes: each]) asArray