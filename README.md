HAMNET DB Zonefile Fixer

This script deletes illegal records such as

* CNAME records, which are present at all if `A` or `AAAA` records exist (CNAME is not needed in such a case).
* CNAME records for multiple A records (there can be only one)


It also fixes other stuff like
* line endings (`\r` in some parts of the file)
* remove empty lines out of the list

