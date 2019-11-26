The flash programmer GUI in this directory supports the MXDB as well as the MVDB.
The previous version is in the MVDB folder since it does not support the MXDB.
The interface for the MXDB version is identical, it has just been updated to support
the new hardware.

The flash programmer pof and sof files contained in this directory are for use
with the MXDB exclusively.  The sof is volatile so it is quick to program, but the pof
is non volatile.  The pof is useful since the board will revert to it upon a power cycle,
meanwhile any sof programmed thereafter will be dominant until a following power cycle.  So
using sof for user programs and pof for flash programming works quite well.

Unlike the MVDB no special interface for reading from the on-board flash is needed since there is no
longer a latched bus.  Therefore no such interface is provided.  Students just need to add pins
for the flash and assign them per the schematic.
