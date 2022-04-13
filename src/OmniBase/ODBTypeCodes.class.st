Class {
	#name : #ODBTypeCodes,
	#superclass : #SharedPool,
	#classVars : [
		'ODBArrayCode',
		'ODBAssociationCode',
		'ODBByteArrayCode',
		'ODBCharacterCode',
		'ODBClassCode',
		'ODBDateCode',
		'ODBDictionaryCode',
		'ODBDoubleByteCharacterCode',
		'ODBExternalReferenceCode',
		'ODBFalseCode',
		'ODBFloatAs100IntegerCode',
		'ODBFloatAsIntegerCode',
		'ODBFloatCode',
		'ODBFloatValue0',
		'ODBFloatValue1',
		'ODBFractionCode',
		'ODBIdentityDictionaryCode',
		'ODBInternalReference',
		'ODBLargeNegativeIntegerCode',
		'ODBLargePositiveIntegerCode',
		'ODBMessageCode',
		'ODBMessageSendCode',
		'ODBMinusOne',
		'ODBMinusThreeCode',
		'ODBMinusTwo',
		'ODBNilCode',
		'ODBODBIdentityDictionaryCode',
		'ODBOrderedCollectionCode',
		'ODBPersistentDictionaryCode',
		'ODBProcessSchedulerCode',
		'ODBScaledDecimalCode',
		'ODBSmallFloat64Code',
		'ODBSmallPositiveIntegerBaseCode',
		'ODBSmallStringBaseCode',
		'ODBStringCode',
		'ODBSymbolCode',
		'ODBSystemDictionaryCode',
		'ODBTimeCode',
		'ODBTransactionCode',
		'ODBTrueCode',
		'ODBUndefinedObjectCode',
		'ODBWideStringCode'
	],
	#category : #'OmniBase-Base'
}

{ #category : #initialization }
ODBTypeCodes class >> initialize [ 
	self initializeTypeCodes.
	ODBEncodingStream initializeTypeCodeMapping 

]

{ #category : #initialization }
ODBTypeCodes class >> initializeTypeCodes [
	<script>
	"1 .. 3" 
	ODBInternalReference := 4.
	ODBExternalReferenceCode := 5.
	"6 .. 10"
	ODBNilCode := 10.
	ODBLargePositiveIntegerCode := 11.
	ODBLargeNegativeIntegerCode := 12.
	ODBCharacterCode := 13.
	ODBUndefinedObjectCode := 14.
	ODBTrueCode := 15.
	ODBFalseCode := 16.
	ODBMessageCode := 17.
	ODBSymbolCode := 18.
	ODBSystemDictionaryCode := 19.
	ODBMessageSendCode := 20.
	"21"
	ODBProcessSchedulerCode := 22.
	"23 .. 25"
	ODBClassCode := 26.
	"27 .. 28"
	ODBDoubleByteCharacterCode := 29.
	"30"
	ODBAssociationCode := 31.
	ODBDateCode := 32.
	ODBTimeCode := 33.
	ODBStringCode := 34.
	ODBArrayCode := 35.
	ODBWideStringCode := 36.
	ODBDictionaryCode := 37.
	ODBIdentityDictionaryCode := 38.
	ODBFractionCode := 39.
	ODBFloatCode := 40.
	ODBFloatValue0 := 41.
	ODBFloatValue1 := 42.
	ODBFloatAsIntegerCode := 43.
	ODBFloatAs100IntegerCode := 44.
	ODBScaledDecimalCode := 45.
	"legacy ?"
	"ODBFloatCode := 46."
	ODBSmallFloat64Code := 47.
	"integers <= 16 are stored with code 50 + number"
	ODBSmallPositiveIntegerBaseCode := 50. 
	"50 .. 64 integers 0 .. 16"
	ODBMinusThreeCode := 67.
	ODBMinusTwo := 68.
	ODBMinusOne := 69.
	"small strings of size small than 10 bytes are written with type 70 + size of string"
	ODBSmallStringBaseCode := 70.
	"70 .. 79 small strings"
	ODBByteArrayCode := 80.
	ODBOrderedCollectionCode := 81.
	ODBODBIdentityDictionaryCode := 82.
	ODBPersistentDictionaryCode := 83.
	ODBTransactionCode := 84.
]
