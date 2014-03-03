private
initialize
	"Private - Initialize ClassIDs array used to convert classID to appropriate class."

	| dict maxID |
	dict := IdentityDictionary new.
	maxID := self addClassIDsTo: dict.
	ClassIDs := Array new: maxID.
	dict keysAndValuesDo: [:key :value | ClassIDs at: key put: value]