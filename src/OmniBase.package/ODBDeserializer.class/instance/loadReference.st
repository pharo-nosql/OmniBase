private
loadReference

	^self register: (referenceManager referenceAt: stream getPositiveInteger)