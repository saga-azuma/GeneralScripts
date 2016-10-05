proc OreNote args {
  toplevel .w
  wm attributes .w -topmost 1
  pack [text .w.t -font {{ＭＳ Ｐゴシック} 20} -width 20 -height 5]
  pack [button .w.b  -font {{MS PGothic} 20} -text "消去" -command {.w.t delete 0.0 end}]
}

OreNote
