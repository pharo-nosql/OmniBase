private
newObjectOldClass

	| classInfo |
	^(classInfo := classes at: stream getPositiveInteger) realClass
		odbLoadVariables: self
		classInfo: classInfo