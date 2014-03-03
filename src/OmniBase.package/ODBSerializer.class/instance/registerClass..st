private
registerClass: class 
	| index classInfo |
	(index := classes at: class) isNil 
		ifTrue: 
			[classInfo := classManager register: class.
			stream
				putByte: 2;
				putPositiveInteger: classInfo classID.
			classCollection add: classInfo.
			classes at: class put: (classesCounter := classesCounter + 1).
			^classInfo].
	stream
		putByte: 3;
		putPositiveInteger: index.
	classInfo := classCollection at: index.
	^classInfo