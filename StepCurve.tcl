#############################################################################
# namespace 
#############################################################################
namespace eval StepCurve {
  variable win;  #
  variable select;
}

#############################################################################
# main
#############################################################################
proc StepCurve::main args {
  variable select
  variable win;

  # check template
  switch [hm_getsolver] {
    radioss {}
    default {tk_messageBox -message "[hm_getsolver] is not supported"; return;}
  }


  #main GUI
  set win(name) "stepCurve"; # toplevel name
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

  # Input the name of the curve.
  set select(name) ""
  pack [labelframe $win(base).f0 -text "The name of curve" ]
  pack [entry $win(base).f0.name -textvariable StepCurve::select(name)]

  # Input the last X point.
  set select(last-x) 1.0
  pack [labelframe $win(base).f1 -text "The last X-value." ]
  pack [entry $win(base).f1.name -textvariable StepCurve::select(last-x)]

  # Input the last X point.
  set select(last-y) 1.0
  pack [labelframe $win(base).f2 -text "The last Y-value." ]
  pack [entry $win(base).f2.name -textvariable StepCurve::select(last-y)]

  # Input intervals
  set select(interval) 100
  pack [labelframe $win(base).f3 -text "Intervals" ]
  pack [entry $win(base).f3.name -textvariable StepCurve::select(interval)]

  # Do, Quit
  pack [button $win(base).do -text "Do" -command StepCurve::do ] 
  pack [button $win(base).quit  -text "Quit" -command StepCurve::quit ] 
  
  # Assign X button as quit.
  wm protocol $win(base) WM_DELETE_WINDOW StepCurve::quit
}

#############################################################################
# Quit
#############################################################################
proc StepCurve::quit args {
  variable win
  variable mes;
  destroy $win(base)
  namespace delete [ namespace current ];
}
#############################################################################
# Do the process
#############################################################################
proc StepCurve::do args {
  variable win
  variable select

  # check the name
  if { [llength $select(name)] == 0 } {
    tk_messageBox -type ok -title "Error" -icon error \
      -message "The curve name should not be blank."
    return 
  }

  *createmark curve 1 $select(name)
  if { [hm_getmark curve 1] == 1 } {
    tk_messageBox -type ok -title "Error" -icon error \
      -message "There is a curve which has same name.\nPlease try another one."
    return 
  }
  *clearmark curve 1

  # check the last X.
  if { ![string is integer $select(last-x)] && ![string is double $select(last-x)] } {
    tk_messageBox -type ok -title Error -icon error \
      -message "Tha last-X value should be numerical."
    return 
  }
  if { $select(last-x) <= 0.0 } {
    tk_messageBox -type ok -title Error -icon error \
      -message "Tha last-X value should be positive."
    return 
  }
  set select(last-x) [expr double($select(last-x)) ]

  # check the last Y.
  if { ![string is integer $select(last-y)] && ![string is double $select(last-y)] } {
    tk_messageBox -type ok -title Error -icon error \
      -message "Tha last-Y value should be numerical."
    return 
  }
  if { $select(last-x) == 0.0 } {
    tk_messageBox -type ok -title Error -icon error \
      -message "Tha last-Y value should not be zero."
    return 
  }
  set select(last-y) [expr double($select(last-y)) ]

  # check interval number.
  if { ![string is integer $select(interval)] && ![string is double $select(interval)] } {
    tk_messageBox -type ok -title Error -icon error \
      -message "Interval should be integer."
    return 
  }
  if { $select(interval) <= 2.0 } {
    tk_messageBox -type ok -title Error -icon error \
      -message "The interval should be greater than 2."
    return 
  }
  set select(interval) [expr round($select(interval)) ]

  # make the plot
  set dx  [expr $select(last-x)/$select(interval)]

  *xyplotcreate $select(name) "" 
  *xyplotsetcurrent $select(name)
  *xyplotcreatecurve "0:$select(last-x):$dx" "" "" "" 1 "$select(last-y)*(x/$select(last-x))^3*(10-15*x/$select(last-x)+6*(x/$select(last-x))^2) " "" "" "" 1 
  
  # Remain the created curve but delete the created plot.
  *createmark curve 1 -1
  *setvalue curves id=[hm_getmark curve 1] name=$select(name)
  *createmark plot 1 -1
  *deletemark plot 1

  return

}


StepCurve::main
