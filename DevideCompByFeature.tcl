#
# log:
#
namespace eval DevideCompByFeature {
#  variable file entity2dresp.fem
#  variable rtype stress
#  variable ptype elem
#  variable atta svm
#  variable entity elem
}

proc DevideCompByFeature::messages args {
  variable mes;
  variable var;
  switch -g $var(lang) {
    ja_JP* {
      set mes(1) "もう起動しています"
      set mes(2) "1. 対象の要素のみ表示してください\n2. feature を作ってください(任意)"
      set mes(3) "実行"
      set mes(4) "終了"
      set mes(5) "コンポーネント名の接頭語"
    }
    default {
      set mes(1) "The script has already been invoked."
      set mes(2) "1. Only target elements should be displayed.\n2. Feature can be created now.(optional)"
      set mes(3) "Do"
      set mes(4) "Quit"
      set mes(5) "Prefix of new component name"
    }
  }
}

proc DevideCompByFeature::main args {
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

  # メッセージ
  pack [message $win_base.m0 -justify left -text $mes(2) -width 800]

  # 接頭語
  set var(prefix) area_
  pack [entry $win_base.e1 -textvariable DevideCompByFeature::var(prefix) ]

  # 実行と終了
  pack [panedwindow $win_base.p -orient horizontal]
  pack [button $win_base.p.l1 -text $mes(3) -command "DevideCompByFeature::do $win_base "] 
  pack [button $win_base.p.l2  -text $mes(4) -command "DevideCompByFeature::quit $win_base" ] 
  $win_base.p add $win_base.p.l1 $win_base.p.l2

  # ×ボタンは Opt01::quit の動きを
  wm protocol $win_base WM_DELETE_WINDOW "DevideCompByFeature::quit $win_base"

}

proc DevideCompByFeature::quit args {
  destroy $args
  namespace delete [ namespace current ];
}


proc DevideCompByFeature::do args {
  variable var
  puts $args

  *createmark elem 1 displayed
  *createmark elem 2 "by comp" "^feature"
  *markdifference elem 1 elem 2
  set elemids [hm_getmark elem 1]
  set suffixnumber 1
  set prefix $var(prefix)
  set flag [llength [hm_getmark elem 1]]
  *clearmark elem 2
  *clearmark elem 1

  while {$flag != 0} {
    *createmark elem 1 [lindex $elemids 0]
    *appendmark elem 1 "by face"
    *createentity comps name=$prefix$suffixnumber
    *movemark elements 1 $prefix$suffixnumber

    *createmark elem 1 "by comp" "$prefix$suffixnumber"
    *maskentitymark elements 1 0
    *clearmark elem 1

    *createmark elem 1 displayed
    *createmark elem 2 "by comp" "^feature"
    *markdifference elem 1 elem 2
    set elemids [hm_getmark elem 1]
    set flag [llength [hm_getmark elem 1]]
    *clearmark elem 2
    *clearmark elem 1
    incr suffixnumber
  }
  DevideCompByFeature::quit $args

}
if {[catch {set DevideCompByFeature::var(lang) $env(LANG)} ]} {set DevideCompByFeature::var(lang) C}
DevideCompByFeature::messages
DevideCompByFeature::main

