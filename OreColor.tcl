#
# log:
#   - *createmark comp 1 $id ==> *createmark comp 1 "by id only" $id。名前が数字のときに、名前で選択してしまうのを防ぐ
#
namespace eval OreColor {
#  variable file entity2dresp.fem
#  variable rtype stress
#  variable ptype elem
#  variable atta svm
#  variable entity elem
}

proc OreColor::main args {
  set colors {23 39 55 31 47 63 27 51 22 32 38 48 56 64}
  set colors_num [ llength $colors]

  set auto_noexec 1

# solver check
#  set solver [hm_getsolver]
#  if { $solver != "nastran"} {
#    tk_messageBox -message "Optistruct にのみ対応してます"
#    return
#  }
  
  *createmarkpanel comp 1 "select comps"
  set selcomps [hm_getmark comp 1]
  *clearmark comps 1


  set i 0
  foreach compid $selcomps {
    *createmark comp 1 "by id only" $compid
    *colormark comp 1 [lindex $colors $i]
#    puts [lindex $colors $i]
    set i [ expr $i + 1]
    if { $i == $colors_num } {
      set i 0
    }
    *clearmark comp 1
#  puts $i
  }


}


