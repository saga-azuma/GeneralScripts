#
# log:
#
namespace eval DevideCompByAdjacent {
}

proc DevideCompByAdjacent::messages args {
  variable mes;
  variable var;
  switch -g $var(lang) {
    ja_JP* {
      set mes(1) "もう起動しています"
      set mes(2) "1. 対象の要素のみ表示してください\n\n\n"
      set mes(3) "実行"
      set mes(4) "終了"
      set mes(5) "1コンポーネント当たりの要素数（目安）:\n"
      set mes(6) "接頭語:\n"
    }
    default {
      set mes(1) "The script has already been invoked."
      set mes(2) "1. Only target elements should be displayed.\n\n\n"
      set mes(3) "Do"
      set mes(4) "Quit"
      set mes(5) "Number of element for each component(rough):\n"
      set mes(6) "Prefix:\n"
    }
  }
}

proc DevideCompByAdjacent::main args {
  variable mes;
  variable var;
  set win_name "devideCompByFeature";
  set win_base ".$win_name";

  if { [ winfo exists $win_base ] } {
    tk_messageBox -message $mes(1) -type "ok" -icon info -title "Information";
    focus $win_base;
    return;
  }
  
  # トップレベル
  toplevel $win_base;
  # 窓はいつでも前にある
  wm attributes $win_base -topmost 1;
  pack [message $win_base.m0 -justify left -text $mes(2) -width 800]


  # adjacent 要素数の目安
  pack [message $win_base.m1 -justify left -text $mes(5) -width 800]
  set var(elemsize) 10000
  pack [entry $win_base.e1 -textvariable DevideCompByAdjacent::var(elemsize) ]

  # 接頭語
  pack [message $win_base.m2 -justify left -text $mes(6) -width 800]
  set var(prefix) area_
  pack [entry $win_base.e2 -textvariable DevideCompByAdjacent::var(prefix) ]

  # 実行と終了
  pack [panedwindow $win_base.p -orient horizontal]
  pack [button $win_base.p.l1 -text $mes(3) -command "DevideCompByAdjacent::do $win_base "] 
  pack [button $win_base.p.l2  -text $mes(4) -command "DevideCompByAdjacent::quit $win_base" ] 
  $win_base.p add $win_base.p.l1 $win_base.p.l2

  # ×ボタンは Opt01::quit の動きを
  wm protocol $win_base WM_DELETE_WINDOW "DevideCompByAdjacent::quit $win_base"

}

proc DevideCompByAdjacent::quit args {
  destroy $args
  namespace delete [ namespace current ];
}


proc DevideCompByAdjacent::do args {
  variable var

  *createmark elem 1 displayed
  set elemids [hm_getmark elem 1]
  set flag [llength $elemids]
  *clearmark elem 1

  set suffixnumber 1

  while {$flag != 0} {
    *createmark elem 1 [lindex $elemids 0]
    set elemsize_current [llength [hm_getmark elem 1]]
    while {$elemsize_current < $var(elemsize)} {
      *appendmark elem 1 "by adjacent"
      set new_elemsize [ llength [hm_getmark elem 1]]
      if {$new_elemsize == $elemsize_current} {
        set elemsize_current [expr $var(elemsize) +1]
      } else {
        set elemsize_current $new_elemsize
      }
    }
#
    *createentity comps name=$var(prefix)$suffixnumber
    *movemark elements 1 $var(prefix)$suffixnumber

    *createmark elem 1 "by comp" "$var(prefix)$suffixnumber"
    *maskentitymark elements 1 0
    *clearmark elem 1

    *createmark elem 1 displayed
    set elemids [hm_getmark elem 1]
    set flag [llength $elemids]
    *clearmark elem 1
    incr suffixnumber
  }
  DevideCompByAdjacent::quit $args

}

if {[catch {set DevideCompByAdjacent::var(lang) $env(LANG)} ]} {set DevideCompByAdjacent::var(lang) C}
DevideCompByAdjacent::messages
DevideCompByAdjacent::main

