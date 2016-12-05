############################################################
# Copyright (c) 2013 Altair Engineering Japan.  All Rights #
############################################################

### Initial value ###
set geom [lindex [split [split [wm geometry .] x] +] 0];
set width [lindex $geom 0];
set height [lindex $geom 1];

#set width [winfo width .mainFrame.center.f3.center_frm];
#set height [winfo height .mainFrame.center.f3.center_frm];

### Capture AVI file by specific resolution ###
proc ::CaptureAVI_SpecificResolution {args} {
	set filename [lindex [lindex [lindex $args 0] 0] 0];
	set width [lindex [lindex [lindex $args 0] 0] 1];
	set height [lindex [lindex [lindex $args 0] 0] 2];
	#tk_messageBox -message "$filename , $width , $height";

	### Hide Tab, Panel, CommandWindow and Toolbar(upper panels) ###
	foreach barname [list "Left" "Right" "Panels" "Command Window" "Status Bar" "Title"] {
		set id [::hw::p_FindViewMenuItemByText $barname];
		set hwid [set ::hw::menuItem$id];
		if {$hwid == "1"} {
			::hw::ExecuteMenuItem $id;
			set ::hw::menuItem$id "0";
		}
	}

	### Hide HyperWorks Toolbars ###
	set Sid [::hw::p_FindViewMenuItemByText Standard];
	if {$Sid == "0"} {
		set Sid [expr [::hw::p_FindViewMenuItemByText "Client Selector"] -1];
	}
	for {set id $Sid} {$id <= [expr $Sid + 10]} {incr id} {
		set hwid [set ::hw::menuItem$id];
		if {$hwid == "1"} {
			::hw::ExecuteMenuItem $id;
			set ::hw::menuItem$id "0";
		}
	}

	### Hide HyperView Toolbars ###
	set Sid [::hw::p_FindViewMenuItemByText Display];
	if {$Sid == "0"} {
		set Sid [expr [::hw::p_FindViewMenuItemByText Visualization] -1];
	}
	for {set id $Sid} {$id <= [expr $Sid + 4]} {incr id} {
		set hwid [set ::hw::menuItem$id];
		if {$hwid == "1"} {
			::hw::ExecuteMenuItem $id;
			set ::hw::menuItem$id "0";
		}
	}

	### Set new window size ###
	if {[wm state .] == "normal"} {
		wm state . zoomed;
		update
	}
	if {[wm state .] == "zoomed"} {
		wm state . normal;
		update;
	}

	wm geometry . "799x799+0+0"
	update

	wm maxsize . [expr $width + 300] [expr $height + 300];
	set width [expr $width + "20"];
	set height [expr $height + "42"];
	wm geometry . "$width\x$height\+0+0";
	update;

	### Capture AVI Animation ###
	set t [::post::GetT];
	hwi GetSessionHandle sess$t;
	sess$t CaptureAnimation avi $filename;

	### Reset window zoomed ###
	wm state . zoomed;

	### Show Tabs ###
	foreach barname [list "Left" "Panels" "Status Bar"] {
		set id [::hw::p_FindViewMenuItemByText $barname];
		set hwid [set ::hw::menuItem$id];
		if {$hwid == "0"} {
			::hw::ExecuteMenuItem $id;
			set ::hw::menuItem$id "1";
		}
	}

	### Show HyperWorks Toolbars ###
	set Sid [::hw::p_FindViewMenuItemByText Standard];
	if {$Sid == "0"} {
		set Sid [expr [::hw::p_FindViewMenuItemByText "Client Selector"] -1];
	}
	for {set id $Sid} {$id <= [expr $Sid + 10]} {incr id} {
		set hwid [set ::hw::menuItem$id];
		if {$hwid == "0"} {
			::hw::ExecuteMenuItem $id;
			set ::hw::menuItem$id "1";
		}
	}
	## Hide Scripting Toolbar ###
	set id [::hw::p_FindViewMenuItemByText Scripting];
	set hwid [set ::hw::menuItem$id];
	if {$hwid == "1"} {
		::hw::ExecuteMenuItem $id;
		set ::hw::menuItem$id "0";
	}

	### Show HyperView Toolbars ###
	set Sid [::hw::p_FindViewMenuItemByText Display];
	if {$Sid == "0"} {
		set Sid [expr [::hw::p_FindViewMenuItemByText Visualization] -1];
	}
	for {set id $Sid} {$id < [expr $Sid + 4]} {incr id} {
		set hwid [set ::hw::menuItem$id];
		if {$hwid == "0"} {
			::hw::ExecuteMenuItem $id;
			set ::hw::menuItem$id "1";
		}
	}
}

############################################## GUI Start ##############################################

############################################## File Selector ##############################################
proc ::FileSelector { args } {
	variable filename "";
	set AVI_FILE "";

	set x [expr [winfo screenwidth  .] / 2]
	set y [expr [winfo screenheight .] / 2]

	set ftype { {"AVI"  {*.avi}}  {"All Files" {*.*}} }
	set filename [tk_getSaveFile	-filetypes $ftype \
					-parent .top \
					-x $x	-y $y \
					-title "Capture AVI file" \
					-defaultextension "avi" ];

	if {$filename == ""} {
		return
	}
}

############################################## File and width height GUI ##############################################
proc ::CreateAVI_GUI { args } {
	variable filename;
	variable width;
	variable height;
	toplevel .top
	wm title .top "AVI Resolution"
	wm geometry .top "250x130";
	wm protocol .top WM_DELETE_WINDOW {destroy .top;}

	label	.top.lb1 -text	"AVI File Name";
	entry	.top.ent1	-width 34 -state disabled\
				-textvariable filename;

	set t [::post::GetT];
	hwi OpenStack;
	hwi GetSessionHandle sess$t;
	set altairhome [sess$t GetSystemVariable "ALTAIR_HOME"]
	image create photo FileOpenIcon -file "$altairhome\/hw/images/fileOpen-16.png";
	button	.top.selph1	-image FileOpenIcon \
				-command {::FileSelector}

	label	.top.lb2	-text "Width";
	entry	.top.ent2	-width 18 \
				-textvariable width;

	label	.top.lb3	-text "Height";
	entry	.top.ent3	-width 18 \
				-textvariable height;

	button	.top.button	-text "Apply" \
				-width  14 -bg yellow \
				-command { ::CaptureAVI_SpecificResolution [list "$filename $width $height"] };

	place	.top.lb1	-relx 0.02	-y 15 -anchor w;
	place	.top.ent1	-relx 0.02	-y 35 -anchor w;
	place	.top.selph1	-relx 0.88	-y 35 -anchor w;

	place	.top.lb2	-relx 0.02	-y 55 -anchor w;
	place	.top.ent2	-relx 0.02	-y 75 -anchor w;

	place	.top.lb3	-relx 0.5	-y 55 -anchor w;
	place	.top.ent3	-relx 0.5	-y 75 -anchor w;
	place	.top.button	-relx 0.6	-y 105 -anchor w;
}

::CreateAVI_GUI
