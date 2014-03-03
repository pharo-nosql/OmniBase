private
transactionReferenceAt: objectIDindex 
	"Private - Answer object at objectID index."

	objectIDindex == 1000 ifTrue: [^self].
	^transactionManager transactionReferenceAt: objectIDindex