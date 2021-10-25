Class {
	#name : #ODBIDTableTest,
	#superclass : #ODBDiskBasedTest,
	#category : #'OmniBase-Tests'
}

{ #category : #tests }
ODBIDTableTest >> testAfterCreation [ 
	| idTable rawIndex |
	idTable := db classManager instVarNamed: #idTable.
	self assert: idTable getLastID equals: 0.
	rawIndex := idTable stream 
		position: 128;
		getLong.
	self assert: rawIndex equals: 0
]

{ #category : #tests }
ODBIDTableTest >> testIndexUpdateAfterAdding [
	| idTable rawIndex rawData |
	idTable := db classManager instVarNamed: #idTable.
	idTable add: 15.
	rawIndex := idTable stream 
		position: 128;
		getLong.
	rawData := idTable stream 
		position: 132;
		getLong.
	self assert: idTable getLastID equals: 1.
	self assert: rawIndex equals: 1.
	self assert: rawData equals: 15.
]
