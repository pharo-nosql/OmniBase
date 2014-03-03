private
initialize: anInteger

	elementCount := 0.
	keys := Array new: anInteger.
	values := WeakArray new: anInteger.
	sizeLimit := anInteger - 2 * 11 // 23