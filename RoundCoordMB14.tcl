set dirname  [file dirname [info script]]
if {[info exists MacroVar]} {unset MacroVar}
dict set MacroVar 1 {HMdata.nodes..{} {} nodes}
dict set MacroVar 2 {HMdata.nodes.coordinates.{} nodes coordinates}
dict set MacroVar 3 {{user_data.Add.int.Min_Order} {} {{Min_Order} 3}}
dict set MacroVar 4 {user_data.Add.Procedure.user_proc {} {user_proc ::my_function CREATECOLUMN_1 ""}}
#dict set MacroVar 4 {user_data.Add.Procedure.user_proc {} {user_proc ::my_function CREATECOLUMN_1 C:/Users/fukuoka/AppData/Local/Temp/MatrixBrowser/MBUsersDirectory/user_proc.tcl}}
#sourcing all the procedures created in the worksheet worksheet
proc ::my_function { args } {
  set coord [::MatrixBrowser::getColumn coordinates]
  set minorder [lindex [::MatrixBrowser::getColumn Min_Order] 0]
  set fmt "%30."
  append fmt $minorder
  append fmt "f"
  puts $fmt
  set newcoord {}
  foreach xyz $coord {
    set x [lindex $xyz 0]
    set y [lindex $xyz 1]
    set z [lindex $xyz 2]
    set newx [expr [format $fmt $x]]
    set newy [expr [format $fmt $y]]
    set newz [expr [format $fmt $z]]
    lappend newcoord "$newx $newy $newz"
  }
  ::MatrixBrowser::setColumn coordinates $newcoord;
  return ;
}

set ::MatrixBrowser_BatchMode 1
SourceFile [file join [hm_info -appinfo SPECIFIEDPATH hm_scripts_dir] "EngineeringSolutions/aerospace/Matrix/init.tcl" ]
catch { ::MatrixBrowser::Manage_Selections_MacroGUI $MacroVar } 
