namespace eval DispedAttachedSurf {
}

##########################################
# make a unit-length vector by using 2 vectors of coordinates.
# return (vect2 - vect1)/|vect2 - vect1|
# vect1 and vect2 is like {1 2 3}
##########################################
proc DispedAttachedSurf::main args  {
  *createmarkpanel surf 1 "select surf."
  set surfs [hm_getmark surf 1]
  set length [llength $surfs]
  set newlength 0
  while { $length != $newlength} {
    set length [llength $surfs]
    *appendmark surf 1 "by adjacent"
    set surfs [hm_getmark surf 1]
    set newlength [llength $surfs]
  }

  *marktousermark surf 1
  *clearmark surf 1
  hm_usermessage "$length  surfs are now in the user mark."
}


DispedAttachedSurf::main