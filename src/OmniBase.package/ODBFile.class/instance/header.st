private
header
        "Private - Answer receiver's header."

	| header desc |
	header := String new: self headerLength.
	desc := self descriptionString.
	header replaceFrom: 1
		to: desc size
		with: desc
		startingAt: 1.
	^header