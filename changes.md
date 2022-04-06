Changes
=======

2022-04-06 - Release 0.6
------------------------

- removal of double stream position handling. Started to use pharo file streams instead of omnibase streams
- removed unusued classes and instVars. 

2022-03-09 - Release 0.5
------------------------

- added in-image locking facility to complement fnctl style locking on unix/linux systems.

2022-03-01 - Release 0.4
------------------------

- introduced unicode serialization/deserialization with new type code 36
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
