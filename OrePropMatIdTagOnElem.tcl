#############################################################################
# namespace 
#############################################################################
namespace eval OrePropMaiIdTagOnElem {
  variable win;  #
  variable var;
  variable mes;
  variable env;
}

# Proc for defingin messages
proc OrePropMaiIdTagOnElem::message args {
  variable mes;
  variable var;
  # If LANG contains ja_JP, then Japanese message
  # else, English message.
  switch -g $var(lang) {
    ja_JP* {
      set mes(1) "もう起動してます"
      set mes(2) "要素選択"
      set mes(3) "要素を選択してください"
    }
    default {
      set mes(1) "This script has been running."
      set mes(2) "Select elements."
      set mes(3) "You have to select one or more elements."
    }
  }
}
#############################################################################
# main
#############################################################################
proc OrePropMaiIdTagOnElem::main args {
  variable var
  variable win;
  variable mes;
  
  #main GUI
  set win(name) "_PropMatId_on_Elem"; # toplevel name
  set win(base) ".$win(name)";

  if { [ winfo exists $win(base) ] } {
    tk_messageBox -message $mes(1) -type "ok" -icon info -title "Information";
    focus $win(base);
    return;
  }
  
  # 
  toplevel $win(base);
  # The window always stay front.
  wm attributes $win(base) -topmost 1;

  # Selection
  set var(elemid) {}
  pack [button $win(base).b01 -text $mes(2) -command OrePropMaiIdTagOnElem::select ]

  # Slect PID or MID.
  set var(type) pid
  foreach item {pid mid} {
    radiobutton $win(base).rb01$item -text $item -variable OrePropMaiIdTagOnElem::var(type) -value $item
    pack $win(base).rb01$item 
  }

  # Do, Quit
  pack [button $win(base).do -text "Do" -command OrePropMaiIdTagOnElem::do ] 
  pack [button $win(base).quit  -text "Quit" -command OrePropMaiIdTagOnElem::quit ] 
  
  # Assign X button as quit.
  wm protocol $win(base) WM_DELETE_WINDOW OrePropMaiIdTagOnElem::quit
}

#############################################################################
# Quit
#############################################################################
proc OrePropMaiIdTagOnElem::quit args {
  variable win
  variable mes;
  destroy $win(base)
  namespace delete [ namespace current ];
}
#############################################################################
# Do the process
#############################################################################
proc OrePropMaiIdTagOnElem::do args {
  variable win
  variable var
  variable mes;

  # check the name
  if { [llength $var(elemid)] == 0 } {
    tk_messageBox -type ok -title "Error" -icon error \
      -message $mes(3)
    return 
  }

  foreach i $var(elemid) {
    set pid [hm_getentityvalue elem $i propertyid 0]
    set compid [hm_getentityvalue elem $i collector 0]
    set mid [hm_getentityvalue prop $pid materialid 0]
    # In Radioss type solver, mid doesnot belong to pid but to comp id.
    if {$mid == 0} {
      set mid [hm_getentityvalue comp $compid materialid 0]
    }
    switch $var(type) {
      pid {
        catch {*tagcreate elem $i $pid "pid_$i" 1}
      }
     mid {
        catch {*tagcreate elem $i $mid "mid_$i" 7}
      }
    # skip to create a tag if the same tag is there.
    }
  }
  # clear element selection
  set var(elemid) {}
  $win(base).b01 configure -bg lightgray  -fg black
  return
}

#############################################################################
# select element
#############################################################################
proc OrePropMaiIdTagOnElem::select args {
  variable var
  variable win
  variable mes;

  # Delet the window temporary.
  wm iconify $win(base);

  *createmarkpanel elem 1 $mes(2);
  set var(elemid) [ hm_getmark elem 1 ]
  *clearmark elem 1

  if { [llength $var(elemid)] != 0  } {
    $win(base).b01 configure -bg #000080 -fg #cccccc
  } else {
    $win(base).b01 configure -bg lightgray  -fg black
  }

# 窓復活
  wm deiconify $win(base);
  focus $win(base)
}
if {[catch {set OrePropMaiIdTagOnElem::var(lang) $env(LANG)} ]} {set OrePropMaiIdTagOnElem::var(lang) C}
OrePropMaiIdTagOnElem::message
OrePropMaiIdTagOnElem::main
