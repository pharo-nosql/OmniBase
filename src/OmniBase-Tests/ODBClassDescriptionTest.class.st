Class {
	#name : #ODBClassDescriptionTest,
	#superclass : #OmniBaseTest,
	#category : #'OmniBase-Tests'
}

{ #category : #tests }
ODBClassDescriptionTest >> testReshape [

	| tmpClass obj1 obj2 transaction2 transaction info1 info2 desc1 desc2 |
	tmpClass := ODBTestClass1 copy.
	self halt.
	desc1 := ODBClassDescription new createFor: tmpClass. 
	
	self assertCollection: tmpClass instVarNames hasSameElements: #( one two three).
	tmpClass 
		removeInstVarNamed: 'two';
		"addInstVarNamed: 'four';"
		addInstVarNamed: 'two'.
	self assertCollection: tmpClass instVarNames hasSameElements: #( one three two).
	self halt.
	desc2 := ODBClassDescription new createFor: tmpClass. 

		
]
