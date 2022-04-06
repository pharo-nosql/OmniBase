Extension { #name : #WideSymbol }

{ #category : #'*OmniBase' }
WideSymbol >> asBtreeKeyOfSize: keySize [
	"workaround to the missing #asByteArray, see pharo issue #11015"
	^self asString asByteArray asBtreeKeyOfSize: keySize
]
