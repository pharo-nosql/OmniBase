private
newObjectNewClass
	| classInfo |
	classInfo := classManager classDescriptionAt: stream getPositiveInteger.
	classesCounter := classesCounter + 1.
	classes add: classInfo.
	^classInfo realClass odbLoadVariables: self classInfo: classInfo