*omnibase
odbGetOID
	"Answer persistent object's OID."

	| t oid |
	(oid := self odbObjectID) isNil ifFalse: [^oid].
	(t := OmniBase currentTransactionOrNil) isNil 
		ifFalse: [(oid := t getObjectIDOrNil: self) isNil ifFalse: [^oid]].

	"sas: declared that bug when trying #odbGetTransaction on some odb reference that's a subinstance
	of this persistent and fails due to strangeness in instVars is an irrelevant, inconsequent mistery that
	only complicates one case that isn't that important after all. So I'm commenting the following lines:
	
	t isAborted ifTrue:[^ nil]."
	"(t := self odbGetTransaction) isNil ifFalse: [^t getObjectIDOrNil: self]."
	^nil