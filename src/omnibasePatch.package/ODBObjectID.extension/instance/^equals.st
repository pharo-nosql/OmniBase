*omnibasePatch
= other

    ^ self species = other species and: [
	other index == index and: [
	other containerID == containerID]]