namespace eval RoundCoordBulk {
  variable win;  
  variable var;
  variable mes;
  variable env;
}

proc RoundCoordBulk::message args {
  variable win;  
  variable var;
  variable mes;
  variable env;
  # If LANG contains ja_JP, then Japanese message
  # else, English message.
  switch -g $var(lang) {
    ja_JP* {
      set mes(1) "Optistruct か Nastran にだけ対応してます"
      set mes(2) "どうしたわけだかバルクファイルが開けません。"
      set mes(3) "少数点以下桁数の指定。初期値=3. 中止=99. zero=100"
      set mes(4) "操作を中止しました"
      set mes(5) "新しい座標で RoundCoordBulkjkt3pd5g9zt8l924fg3.fem ができました。読み込みますか？読み込む(初期値) = y, 終わる = n"
      set mes(6) "終了しました。RoundCoordBulkjkt3pd5g9zt8l924fg3.fem は自由に利用してください"
    }
    default {
      set mes(1) "Optistruct and Nastran are only supported."
      set mes(2) "The bulk file cannot be opend anyway."
      set mes(3) "The order after decimal point. Default = 3. Cancel = 99. zero = 100"
      set mes(4) "The operation is canceled."
      set mes(5) "A new file, RoundCoordBulkjkt3pd5g9zt8l924fg3.fem, include new grid data. Do you include it? answer y(default) or n."
      set mes(6) "The operation is canceled. You can use RoundCoordBulkjkt3pd5g9zt8l924fg3.fem by yourself."
    }
  }
}
##################################################################################################
#メイン関数
##################################################################################################
proc RoundCoordBulk::main args {
  variable win;  
  variable var;
  variable mes;
  variable env;

  # このファイルのある場所
  set var(srcdir)  [file dirname [info script]]
  puts $var(srcdir)

  # テンプレ確認
  # bulk 系のみ通す
  switch [hm_getsolver] {
    nastran {}
    optistruct {}
    default {tk_messageBox -message $mes(1); return;}
  }

  # 桁数を決める
  set var(order) [  hm_getint "Order after the decimal point = " $mes(3) ] 
  if {$var(order) == 0} { set var(order) 3}
  if {$var(order) == 100} { set var(order) 0}
  if {$var(order) == 99} {tk_messageBox -message $mes(4); return;}

  # export して新しいファイルを作る
  *retainmarkselections 0
  *createstringarray 0
  hm_answernext yes
  set var(file1) "$var(srcdir)/RoundCoordBulk57hpo1751x8o17o975u.fem"
    *feoutputwithdata "[hm_info templatefilename]" $var(file1) 0 0 2 1 0

  if [catch {open $var(file1) r} var(fd)] {
    tk_messageBox -message $mes(2);
    return;
  }

  # これは新しいファイル
  set var(file2) "$var(srcdir)/RoundCoordBulkjkt3pd5g9zt8l924fg3.fem"
  if [catch {open $var(file2) w} var(fd2)] {
    tk_messageBox -message $mes(2);
    close $var(fd);
    return;
  }
  puts $var(fd2) "begin bulk"

  set var(grid1) ""
  set var(grid2) ""
  set var(grid3) ""
  set var(grid4) ""
  set var(grid5) ""
  set var(grid6) ""
  set var(grid7) ""
  set var(grid8) ""
  while {[gets $var(fd) line] >= 0} {
    if {[regexp -- {(^GRID....)(........)(........)(........)(........)(........)(........)(........)} $line hoge var(grid1) var(grid2) var(grid3) var(grid4) var(grid5) var(grid6) var(grid7) var(grid8)] ==1} {
      puts "$var(grid4),$var(grid5),$var(grid6)"
      regsub -all -- {(^[0123456789.-]+)([-+])} [string trim $var(grid4)] {\1e\2} x
      regsub -all -- {(^[0123456789.-]+)([-+])} [string trim $var(grid5)] {\1e\2} y
      regsub -all -- {(^[0123456789.-]+)([-+])} [string trim $var(grid6)] {\1e\2} z

      set newx  [string trim [format %30.${var(order)}f $x]  ]
      set newy  [string trim [format %30.${var(order)}f $y]] 
      set newz  [string trim [format %30.${var(order)}f $z] ]
    
      puts $var(fd2) "$var(grid1),$var(grid2),$var(grid3),$newx,$newy,$newz,$var(grid7),$var(grid8)"
      }
  }

  close $var(fd)
  
  puts $var(fd2) "enddata"
  close $var(fd2)

  # include する
  switch [ hm_getstring "y or n" $mes(5) ] {
    n {    tk_messageBox -message $mes(6); return;}
    default {}
  }
  *feinputpreserveincludefiles 
  *createstringarray 12 "OptiStruct " " " "ANSA " "PATRAN " "ASSIGNPROP_BYHMCOMMENTS" \
    "LOADCOLS_DISPLAY_SKIP " "SYSTCOLS_DISPLAY_SKIP " "CONTACTSURF_DISPLAY_SKIP " \
    "BEAMSECTCOLS_SKIP " "BEAMSECTS_SKIP " "PATRAN" "ANSA"
  *feinputwithdata2 "#optistruct\\optistruct" $var(file2) 1 0 0 0 0 1 12 1 0
}

if {[catch {set RoundCoordBulk::var(lang) $env(LANG)} ]} {set RoundCoordBulk::var(lang) C}
RoundCoordBulk::message
RoundCoordBulk::main


