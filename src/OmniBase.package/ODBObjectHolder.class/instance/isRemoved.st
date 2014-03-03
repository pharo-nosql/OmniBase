public
isRemoved
	1 to: contents size do: [:i | (contents at: i) == 0 ifFalse: [^false]].
	^true