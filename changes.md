Changes
=======


- a fix for Floats to be written as immediates. Solves a problem when the same floats are written

2022-01-31 - Release 0.3
------------------------

- changed readme 
- added more tests
- changed from travis to github actions

2021-10-25 - Release 0.2
------------------------

Published a second release that collects the non-backward compatible changes.

- Removed dependency to OSProcess
- Added FLock mechanism based on unified FFI to make a fcntl call available for locking
- Added BSDFlock to cope with the different setup for the same named LibC call

2021-10-25 - Release 0.1
------------------------

This is the fork from https//github.com:pharo-nosql/OmniBase Kept here for reference and history notes.
