proc main { } {
    hm_blockmessages 1;
    hm_blockerrormessages 1;
    hm_blockredraw 1;
    *entityhighlighting 0;
    hm_commandfilestate 0;
    
    set startT [ clock clicks -milliseconds ];
    set pitch 20.0;
    puts "pitch : $pitch"
    
    *createmark elems 1 displayed;
    puts "number of elements : [ hm_marklength elems 1 ]"
    set box [ hm_getboundingbox elems 1 0 0 0 ];
    lassign $box x0 y0 z0 x1 y1 z1;
    
    set lx [ expr { $x1 - $x0 } ];
    set ly [ expr { $y1 - $y0 } ];
    set lz [ expr { $z1 - $z0 } ];
    
    set l [ compareToMaxValue $lx $ly $lz ];
    
    puts "area of model : lx $lx : ly $ly : lz $lz l : $l"
    set px [ expr { int( $lx / $pitch ) } ];
    set py [ expr { int( $ly / $pitch ) } ];
    set pz [ expr { int( $lz / $pitch ) } ];
    
    set p [ expr { int( $l / $pitch ) } ];
    puts "number of partitions : px $px : py $py : pz $pz p : $p"
    
    set level [ getOrder $p ];
    puts "space level : $level"
    
    #set fp [ open $fileName w ];
    
    *createmark elems 1 displayed;
    foreach elemId [ hm_getmark elems 1 ] {
        foreach attr { centerx centery centerz } {
            set $attr [ hm_getentityvalue elems $elemId $attr 0 ];
        }
        
        set ox [ expr { int(($centerx - $x0) / $pitch) } ];
        set oy [ expr { int(($centery - $y0) / $pitch) } ];
        set oz [ expr { int(($centerz - $z0) / $pitch) } ];
        
        set bx [ formatBinary [ convert10to2 $ox ] $level ];
        set by [ formatBinary [ convert10to2 $oy ] $level ];
        set bz [ formatBinary [ convert10to2 $oz ] $level ];
        
        #set b [ format %06d [ convert2to10 "${bx}${by}" ] ];
        set b [ getMortonNumber3 $bx $by $bz $level ];
        if { $b == "" } {
            return;
            puts "error : $bx,$by,$bz";
        } else {
            set b [ format %0${level}d $b ];
        }
#comp name ni setu bi go
        set name "P12_$b";
        #puts $fp "$centerx,$centery,$centerz,$name,$bx,$by,$bz";
        lappend partitionData($name) $elemId;
    }
    #close $fp;

    #puts "export file : $fileName"
    
    foreach name [ array names partitionData ] {
        if { [ llength $partitionData($name) ] == 0 } { continue; }
        *collectorcreateonly comps $name "" 11;
        eval *createmark elems 1 $partitionData($name);
        *movemark elems 1 $name;
    }
    
    set endT [ clock clicks -milliseconds ];
    puts "finished : [ expr int($endT - $startT) / 1000 ] sec"
    *createmark elems 1 displayed;
    *autocolorwithmark comps 1;
    
    hm_blockmessages 0;
    hm_blockerrormessages 0;
    hm_blockredraw 0;
    *entityhighlighting 1;
    hm_commandfilestate 1;
}

proc convert10to2 { decimal } {
    set value $decimal;
    if { [ string is digit $value ] == 0 } { return; }
    while 1 {
        set val [ expr { int( fmod($value, 2) ) } ];
        lappend result $val;
        set value [ expr { int($value / 2) } ];
        if { $value < 1 } { break; }
    }
    set result [ lreverse $result ];
    set result [ join $result "" ];
}

proc convert2to10 { binary } {
    if { [ string is digit $binary ] == 0 } { return; }
    set value [ string reverse $binary ];
    set imax [ string length $binary ];
    
    set val 0;
    for { set i 0 } { $i <= $imax } { incr i } {
        set k [ string index $value $i ];
        if { $k == 1 } {
            set val [ expr { int($val + pow(2, $i)) } ];
        }
    }
    set val;
}

proc compareToMaxValue { args } {
    set maxVal {};
    foreach d $args {
        if { [ string is double $d ] == 0 } { continue; }
        if { $maxVal == "" || $maxVal < $d } { set maxVal $d; }
    }
    set maxVal;
}

proc getOrder { decimal } {
    if { [ string is digit $decimal ] == 0 } { return; }
    set found 0;
    for { set i 0 } { $i <= 8 } { incr i } {
        if { [ expr { pow(2, $i) } ] > $decimal } {
            set found 1;
            break;
        }
    }
    if { $found } { set i; }
}

proc formatBinary { binary level } {
    if { [ string is digit $binary ] == 0 } { return; }
    if { [ string is digit $level ] == 0 } { return; }
    set result [ format %0${level}d $binary ];
}

proc getMortonNumber2 { x y level } {
    if { [ string is digit $level ] == 0 } { return; }
    if { [ string length $x ] != [ string length $y ] } { return; }
    
    set result {};
    for { set i 0 } { $i < $level } { incr i } {
        lappend result2 [ string index $y $i ];
        lappend result2 [ string index $x $i ];
    }
    set result10 [ convert2to10 [ join $result2 "" ] ];
}

proc getMortonNumber3 { x y z level } {
    if { [ string is digit $level ] == 0 } { return; }
    if { [ string length $x ] != [ string length $y ] && [ string length $x ] != [ string length $z ] } { return; }
    
    set result {};
    for { set i 0 } { $i < $level } { incr i } {
        lappend result2 [ string index $z $i ];
        lappend result2 [ string index $y $i ];
        lappend result2 [ string index $x $i ];
    }
    set result10 [ convert2to10 [ join $result2 "" ] ];
}
main;