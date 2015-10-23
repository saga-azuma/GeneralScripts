### Show Hide Settings ###
set dispdomains [dict create];
dict set dispdomains 1 "show";	#1 = 1D domains#
dict set dispdomains 2 "show";	#2 = 2D domains#
dict set dispdomains 3 "show";	#3 = 3D domains#
dict set dispdomains 4 "hide";	#4 = Global domains#
dict set dispdomains 5 "hide";	#5 = Edge domains#
dict set dispdomains 7 "hide";	#7 = General domains#

### Hide ###
set hidelist "";
*createmark domains 1 displayed
foreach domainid [hm_getmark domains 1] {
	set type [hm_getentityvalue domains $domainid type 0];
	if {[dict get $dispdomains $type] == "hide"} {
		lappend hidelist $domainid;
	}
}
if {$hidelist != ""} {
	eval *createmark domains 1 $hidelist;
	*maskentitymark domains 1 0;
}
hm_markclearall 1;
