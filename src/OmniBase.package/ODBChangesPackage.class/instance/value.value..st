private
value: change1 value: change2 
	"Private - Answer <true> if change1 is to be committed before change2.
	Disk access optimization so that files are updated sequentialy."

	| oid1 oid2 cid1 cid2 |
	(oid1 := change1 objectID) isNil ifTrue: [^true].
	(oid2 := change2 objectID) isNil ifTrue: [^false].
	(cid1 := oid1 containerID) == (cid2 := oid2 containerID) 
		ifTrue: [^oid1 index < oid2 index].
	^cid1 < cid2