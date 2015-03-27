# Description:
#   Open and Save session file as CP932 file name. 
# Usage: 
#   there are two usages.
#   1. file -> run -> tcl/tk script befor open/save.
#   2. copy into or source from your hmcustom.tcl
# Limitation:
#   1. It only worked on Windows which uses CP932 for application and unicode in the kernel.
#   2. Test is only done on Japanese edition Windows7.
#   3. Session name shown at the left head corner of HM is mojibake.
#

# Launcd import/export tab to overwrite some procedures.
::HM_Framework::p_LaunchImportGUI ""
::HM_Framework::p_LaunchExportGUI ""

proc ::HmGetOpenFileWithPos {type upper_left saveinitdir_flag args} {

     #  Purpose:     Provide the Tk file open interface for HyperMesh.
     #               If <upper_left> is true, we position the dialog in the upper
     #               left area of the window.  If not, we use the lower right.
     #

     global  argv0;

     set dirName {};

     # Use the old HyperMesh file browser
     if { $::g_OverrideTclFileDialog } {

         set filePath [ string trim [ hm_getfilenamedirect [ string trim $args "\{\}" ]] "\{\}" ];

         if { [ file isdirectory $filePath ] } {
             # HyperMesh wants a NULL string back if nothing was to be done.
             set filePath {};
         }

         return $filePath;
     }

     set title ""

     switch $::Hm_FileFilterType($type) {
         "hm" {
             if { $::g_profile_name != "HyperForm" } {
                 set HmFileFilters [ list {{HyperMesh binary files} {*.hm*}} ];
             } else {
                 set HmFileFilters [ list {{HyperForm binary files} {*.hf*}} ];
             }
             set title "Model";
         }
         "results" {
             if { $::g_profile_name != "HyperForm"} {
                 set HmFileFilters [ list {{HyperMesh results files} {*.*res}} ];
             } else {
                 set HmFileFilters [ list {{HyperForm results files} {*.*res}} ];
             }
             set title "Results";
         }
         "command" {
             if { $::g_profile_name != "HyperForm" } {
                 set HmFileFilters [ list {{HyperMesh command files} {*.cmf}} ];
             } else {
                 set HmFileFilters [ list {{HyperForm command files} {*.cmf}} ];
             }
             set title "Command File";
         }
         "macro" {
             if { $::g_profile_name != "HyperForm" } {
                 set HmFileFilters [ list {{HyperMesh macro files} {*.mac}} ];
             } else {
                 set HmFileFilters [ list {{HyperForm macro files} {*.mac}} ];
             }
             set title "Macro File";
         }
         "executable" {
             if { [ OnPc ] } {
                 set HmFileFilters [ list {{Executable files} {*.exe *.dll}} ];
             }
         }
         "replay" {
             if { $::g_profile_name != "HyperForm" } {
                 set HmFileFilters [ list {{HyperMesh replay files} {*.rpl*}} ];
             } else {
                 set HmFileFilters [ list {{HyperForm replay files} {*.rpl*}} ];
             }
             set title "Replay File";
         }

 ###############################################################################
 #                           IMPORT FE TYPES
 ###############################################################################
         "optistruct" {
             set HmFileFilters [ list {{OptiStruct files} {*.fem *.parm}} ] ;
             set title "OptiStruct File";
         }
         "abaqus" {
             set HmFileFilters [ list {{Abaqus files} {*.inp}} ];
             set title "Abaqus File";
         }
         "ansys" {
             set HmFileFilters [ list {{Ansys files} {*.cdb}} ];
             set title "Ansys File";
         }
         "nastran" {
             set HmFileFilters [ list {{Nastran files} {*.bdf *.blk *.bulk *.dat *.nas *.nastran}} ];
             set title "Nastran File";
         }
         "dyna" {
             set HmFileFilters [ list {{Lsdyna files} {*.k *.key *.dat *.dyn* *.bdf *dynain}} ];
             set title "Lsdyna File";
         }
         "pamcrash" {
             set HmFileFilters [ list {{Pamcrash files} {*.pc *.dat}} ];
             set title "Pamcrash File";
         }
         "radioss" {
             # Changed by Dhananjay Ramasetty for filtering D01 files also
             set HmFileFilters [ list {{RADIOSS files} {*d00 *D00 *rad *RAD *d01 *D01 *sta *STA}} ];
             #set HmFileFilters [ list {{Radioss files} {*d00* *D00*}} ];
             set title "RADIOSS File";
         }
         "permas" {
             set HmFileFilters [ list {{Permas files} {*.dat}} ];
             set title "Permas File";
         }
         "madymo" {
             set HmFileFilters [ list {{Madymo files} {*.xml}} ];
             set title "Madymo File";
         }
 ###############################################################################
 #                           IMPORT GEOM TYPES
 ###############################################################################
         "catia" {
             set HmFileFilters [ list {{CATIA files} {*.model *.CATPart *.CATProduct *.cgr}} ];
             set title "CATIA File";
         }
         "iges" {
             set HmFileFilters [ list {{IGES files} {*.iges *.igs}} ];
             set title "IGES File";
         }
         "proe" {
             set HmFileFilters [ list {{Pro E files} {*.prt* *.asm*}} ];
             set title "Pro E File";
         }
         "step" {
             set HmFileFilters [ list {{STEP files} {*step *stp}} ];
             set title "STEP File";
         }
         "ug" {
             set HmFileFilters [ list {{UG files} {*.prt}} ];
             set title "UG File";
         }
         "acis" {
             set HmFileFilters [ list {{ACIS files} {*.sat}} ];
             set title "ACIS File";
         }
         "parasolid" {
             set HmFileFilters [ list {{Parasolid files} {*.x_t *.x_b *.xmt_txt}} ];
             set title "Parasolid File";
         }
         "solidworks" {
                set HmFileFilters [ list {{SolidWorks files} {*.sldprt *.sldasm}} ];
                set title "SolidWorks File";
         }
         "jt" {
             set HmFileFilters [ list {{JT files} {*.jt}} ];
             set title "JT File";
         }
         "hmascii" {
             set HmFileFilters [ list {{HMAscii files} {*.hmascii}} ];
             set title "HMAscii File";
         }
         "tribon" {
             set HmFileFilters [ list {{Tribon files} {*.xml}} ];
             set title "Tribon File";
         }
         "intergraph" {
             set HmFileFilters [ list {{Intergraph files} {*.xml}} ];
             set title "Intergraph File";
         }

         "connector" {
 ###############################################################################
 #                           IMPORT WELD TYPES
 ###############################################################################
             set HmFileFilters [ list {{Connector files} {*.mwf *.mcf *.xml *.vip}} ];
             set title "Connector File";
         }

         "config" {
 ###############################################################################
 #                           CONFIGURATION FILE TYPES
 ###############################################################################
             set HmFileFilters [ list {{Config files} {*.cfg}} ];
             set title "Config File";
         }

         "tcl" {
 ###############################################################################
 #                           Tcl SCRIPT FILE TYPES
 ###############################################################################
             set HmFileFilters [ list {{Tcl script files} {*.tcl *.tbc}} ];
             set title "Tcl Script";
         }

         "xml" {
 ###############################################################################
 #                           XML FILE TYPES
 ###############################################################################
             set HmFileFilters [ list {{XML files} {*.xml}} ];
             set title "XML File";
         }

         "csv" {
 ###############################################################################
 #                           CSV FILE TYPES
 ###############################################################################
             set HmFileFilters [ list {{CSV files} {*.csv}} ];
             set title "CSV File";
         }
     }

     lappend HmFileFilters {{All files} {*}};

     if { ! [ Null args ] && $args != "{}" } {
         set args [ string trim $args "{}" ];
         if { [ file isdirectory $args ] } {
             set dirName $args;
             set args "";
         } else {
             set dirName [ file dirname $args ];
             set args    [ file tail $args ];
         }
     } else {
         set args "";
     }

     if { [ OnPc ] } {
         if {$upper_left} {
             set xLoc [hm_winfo x];
             set yLoc [hm_winfo y];
         } else {
             set x1 [hm_winfo x];
             set x2 [hm_winfo graphicx];
             set w [hm_winfo graphicwidth];
             set bd  [expr {[hm_winfo borderwidth] * 2} ];
             set xLoc [expr { $x1 + $x2 + $w - 415 - $bd }];

             set y1 [hm_winfo y];
             set y2 [hm_winfo graphicy];
             set h [hm_winfo graphicheight];
             set yLoc [expr { $y1 + $y2 + $h - 290 - $bd }];
         }

         set pathName [ ::hwt::GetOpenFile  -title "Open $title"  -filetypes $HmFileFilters  -initialfile $args  -initialdir $dirName  -saveinitialdir $saveinitdir_flag  -x $xLoc  -y $yLoc ];
          
      
     } else {

         if {$upper_left} {
             set xLoc [hm_winfo x];
             set yLoc [hm_winfo y];
         } else {
             set x1 [hm_winfo x];
             set x2 [hm_winfo graphicx];
             set w [hm_winfo graphicwidth];
             set bd  [expr {[hm_winfo borderwidth] * 2} ];
             if { $bd == 0 } {
                 set bd 12;
             }
             set xLoc [expr { $x1 + $x2 + $w - 600 - $bd }];

             set y1 [hm_winfo y];
             set y2 [hm_winfo graphicy];
             set h [hm_winfo graphicheight];
             set yLoc [expr { $y1 + $y2 + $h - 290 - $bd }];
         }

         set pathName [ ::hwt::GetOpenFile  -title "Open $title"  -filetypes $HmFileFilters  -initialfile $args  -initialdir $dirName  -saveinitialdir $saveinitdir_flag  -x     $xLoc  -y     $yLoc  -width  600  -height 350 ];

         # Tk does not delete the dialog, so we do it - this enables user
         # changes in the HM font to be reflected the next time the file dialog
         # is invoked.  This hack is needed because Tk has no '-font' option for
         # the file dialog and therefore, we have to resort to using the
         # 'option' database.
         if { ([winfo exists .__tk_filedialog]) } {
             destroy .__tk_filedialog;
         }

     }

     if { $pathName != {} } {
         set pathName;
     }
 }

proc ::HmGetSaveFileWithPos {type upper_left args} {
    #  Purpose:     Provide the Tk file save interface for HyperMesh.
    #

    global  argv0;

    set dirName {};

    # Use the old HyperMesh file browser
    if { $::g_OverrideTclFileDialog } {

        set ::filePath [ string trim [ hm_getfilenamedirect [ string trim $args "\{\}" ]] "\{\}" ];

        if { [ file isdirectory $::filePath ] } {
            # HyperMesh wants a NULL string back if nothing was to be done.
            set ::filePath {};
        }

        return $::filePath;
    }

    set extension "";

    switch $::Hm_FileFilterType($type) {

        "hm" {
            if { $::g_profile_name != "HyperForm" } {
                set HmFileFilters {
                    {{HyperMesh binary files} {*.hm*}}
                    {{All files} {*}}
                };
                set extension ".hm";
            } else {
                set HmFileFilters {
                    {{HyperForm binary files} {*.hf*}}
                    {{All files} {*}}
                };
                set extension ".hf";
            }
            set title "Model";
        }
        "connector" {
            set HmFileFilters {
                {{MCF files} {*.mcf}}
            };
            set extension ".mcf";
            set title "MCF";
        }
        "xml" {
            set HmFileFilters {
                {{XML files} {*.xml}}
            };
            set extension ".xml";
            set title "XML";
        }
        default {
            set HmFileFilters {
                {{All files} {*}}
            };
            set title "";
        }

    }

    if { ! [ Null args ] && $args != "{}" } {
        set args [ string trim $args "{}" ];
        if { [ file isdirectory [ file tail $args ]] } {
            set dirName $args;
            set args "";
        } else {
            set dirName [ file dirname $args ];

            if { [ string equal [ file nativename $dirName ] [ file nativename $args ]] } {
                set args "";
            } else {
                set args    [ file tail $args ];
            }
        }
    } else {
        set args "";
    }

    if { [ OnPc ] } {

        if {$upper_left} {
            set xLoc [hm_winfo x];
            set yLoc [hm_winfo y];
        } else {
            set x1 [hm_winfo x];
            set x2 [hm_winfo graphicx];
            set w [hm_winfo graphicwidth];
            set bd  [expr {[hm_winfo borderwidth] * 2} ];
            set xLoc [expr { $x1 + $x2 + $w - 415 - $bd }];

            set y1 [hm_winfo y];
            set y2 [hm_winfo graphicy];
            set h [hm_winfo graphicheight];
            set yLoc [expr { $y1 + $y2 + $h - 290 - $bd }];
        }

        set pathName [ ::hwt::GetSaveFile  -title "Save $title As"  -initialfile $args  -initialdir $dirName  -filetypes $HmFileFilters   -defaultextension $extension  -x $xLoc  -y $yLoc ];
        set pathName [ HmFixFileExtension $pathName $extension ];

        

    } else {

        if {$upper_left} {
            set xLoc [hm_winfo x];
            set yLoc [hm_winfo y];
        } else {
            set x1 [hm_winfo x];
            set x2 [hm_winfo graphicx];
            set w [hm_winfo graphicwidth];
            set bd  [expr {[hm_winfo borderwidth] * 2} ];
            if { $bd == 0 } {
                set bd 12;
            }
            set xLoc [expr { $x1 + $x2 + $w - 600 - $bd }];

            set y1 [hm_winfo y];
            set y2 [hm_winfo graphicy];
            set h [hm_winfo graphicheight];
            set yLoc [expr { $y1 + $y2 + $h - 290 - $bd }];
        }

        set pathName [ ::hwt::GetSaveFile  -title "Save $title As"  -initialfile $args  -initialdir $dirName  -filetypes $HmFileFilters  -defaultextension $extension  -x     $xLoc  -y     $yLoc  -width  600  -height 350 ];
        set pathName [ HmFixFileExtension $pathName $extension ];
    }

    if { $pathName != {} } {
        set pathName;
    }
}

proc ::HM_Framework::p_OpenFile {file {msgTxt {}} {msgTitle {}}} {
        variable Settings::p_last_used_dir;

        if { ! [file exists $file]} {
            tk_messageBox -message "The file $file does not exist." -icon info -title "HyperMesh";
            p_RemoveFileFromPulldown "$file";
            return;
        }

        set utffile $file
        set file [ encoding convertto cp932 $file ];
        set file [ encoding convertfrom identity $file ];

        if {$msgTxt == ""} {
            set msgTxt "This operation will discard all model data.\nContinue?";
        }
        if {$msgTitle == ""} {
            set msgTitle "HyperMesh";
        }

        set ok 1;
        if {[hm_info database_modified]} {
            set ok [tk_messageBox -title ${msgTitle} -icon warning -message ${msgTxt}  -type yesno];
            if {$ok == "yes"} {
                set ok 1;
                hm_answernext "yes";
            }
        }
        if {$ok} {
            hm_setpanelproc "catch {*readfile [list $file]}"; # Note: *readfile will update file list (calls p_AddFileToPulldown)
            hm_setinputentry files [hm_getitemnumberbytag files hmfile_entry] $file;
            set p_last_used_dir [file dir "$file"];
#            ::hwt::SetInitialDirectory [file dir "$file"];
            ::hwt::SetInitialDirectory [file dir "$utffile"];
        }
    }

proc ::HM_Framework::p_SaveFile {{action save} {saveHWSession {}}} {
        #
        # This proc will save the current file.  It will
        # open a file save dialog if the option is "Save as...", or
        # for "Save" option, if there is no current file.
        #
        #variable p_last_used_dir;
        #variable Settings::p_last_used_dir;
        

        if {($action=="save") && ![hm_info database_modified]} {
            # Issue#237014 - do not write, if the file was not modified
            return;
        }        

        set invoke_dialog 0;
        set path [hm_info currentfile];
        set path [string map {\\ \/} $path];     #convert backslash to forwardslash

        # Case 1: Save with no current file
        if {$action == "save" && $path == ""} {
            #set path $p_last_used_dir/file;
            set invoke_dialog 1;
        }

        # Case 2: Saveas
        if {$action != "save"} {
            set invoke_dialog 1;
            if {$path == ""} {
                #set path $p_last_used_dir/file;
            }
        }

        if {$invoke_dialog} {
            set path [p_fileSaveDialog 1 $path];
        }

        if {$path == ""} {
            return;
        }

        set p_last_used_dir [file dir $path];
        ::hwt::SetInitialDirectory [file dir $path];

        if {[file exists $path]} {
            hm_answernext y;
        }

        set utf8path $path
        set path [ encoding convertto cp932 $path ];
        set path [ encoding convertfrom identity $path ];

        if {[::hwt::RunningHWFramework] && ($saveHWSession == "true")} {
            #This code is called when the user is saving the HW session
            set errCode [catch {*writefile "$path" 1}];
            if {$errCode != 0} {
                return -code error;
            }
        } else {
            # This code is called by HM standalone, or by HM client save model call(from fepreActivateGui.tcl file ClientCommandRouter proc)

            # Errors will be reported by *writefile.  Note that *writefile clears
            # all marks and causes problem if you are in a panel.  To work-around
            # this, use hm_setpanelproc to exit all panels first (see DEFECT000041934).
#            hm_setpanelproc "::HM_Framework::p_AfterWrite {$path} \[catch {*writefile \"$path\" 1}\]";
#           something wrong with writing it in a single line.
            set hoge [catch {*writefile "$path" 1}]
            hm_setpanelproc "::HM_Framework::p_AfterWrite {$utf8path} $hoge";
        }
    }


# When a user push the "import" button, this proc is called.
proc ::Import_GUI::FE_Accept args {
   variable ::HM_Framework::Settings::Import::FE_type
   variable ::HM_Framework::Settings::Import::FE_custTrans
   variable ::HM_Framework::Settings::Import::FE_singleFile
   variable ::HM_Framework::Settings::Import::FE_organizeVal
   variable FE_organizeMenu
   variable ::HM_Framework::Settings::Import::FE_propertyVal
   variable FE_propertyVals
   variable FE_propertyMenu
   variable ::HM_Framework::Settings::Import::FE_include
   variable ::HM_Framework::Settings::Import::FE_includeImport
   variable ::HM_Framework::Settings::Import::FE_overwriteState
   variable ::HM_Framework::Settings::Import::FE_offsetState
   variable FE_offsetVals
   variable FE_entParams
   variable FE_entDParams
   variable FE_solverParams
   variable title
   variable ::HM_Framework::Settings::Import::FE_importVal
   variable ::HM_Framework::Settings::Import::FE_displayVal
   variable FE_entExclude
   variable FE_importMenu
   variable ::HM_Framework::Settings::Import::FE_CFDtype
   variable FE_solverFlags;
   variable FE_solverInfo;
   variable FE_solverInfoTemp;
   variable ::HM_Framework::Settings::Import::FE_import_parts

   if {$FE_type == "Custom"} {
      set FE_custTrans [encoding convertfrom identity [file nativename [file normalize $FE_custTrans]]]

      if {$FE_custTrans == ""} {
         tk_messageBox -icon error -title "$title" -message "No import reader selected."
         return
      } elseif {[file isfile $FE_custTrans] == 0} {
         tk_messageBox -icon error -title "$title" -message "Invalid import reader."
         return
      }
   }

#  Comment out it because "encoding covertfrom" prevend the followin file check.
#   set FE_singleFile [encoding convertfrom [file nativename [file normalize $FE_singleFile]]]

   # Generally input type will be a file, but in some solver cases, it may be a directory also.
   set is_a_file 1;
   if {$FE_type == "CFD" && $FE_CFDtype == "OpenFOAM"} {
      set is_a_file 0
   }

   if {$FE_singleFile == ""} {
      tk_messageBox -icon error -title "$title" -message "No import file selected."
      return
    } elseif { $is_a_file == 1 &&  [file isfile $FE_singleFile] == 0} {
      tk_messageBox -icon error -title "$title" -message "$FE_singleFile is not a valid filename."
      return
    } elseif { $is_a_file == 0 &&  [file isdirectory $FE_singleFile] == 0} {
        tk_messageBox -icon error -title "$title" -message "$FE_singleFile is not a valid directory."
        return
   }

   # In case of CFD Readers. some processing is on imported parts. This processing is done at
   # tcl scripts. to use this functionality source the tcl scrip files based on solver type.
   if { $FE_type == "CFD" } {
      ::Import_GUI::FE_CFDFileImport $FE_singleFile;
      return;
   } elseif {$FE_type == "Moldflow"} {
   ::Import_GUI::FE_MPIFileImport $FE_singleFile;
   return;
   } elseif {$FE_type == "Moldex3D Solid"} {
   ::Import_GUI::FE_MPEFileImport $FE_singleFile;
   return;
   } elseif {$FE_type == "Moldex3D Shell"} {
   ::Import_GUI::FE_MSHFileImport $FE_singleFile;
   return;
   } elseif {$FE_type == "HyperXtrude"} {
   ::Import_GUI::FE_HXImport $FE_singleFile;
   return;
   } elseif {$FE_type == "RTM"} {
   ::Import_GUI::FE_RTMImport $FE_singleFile;
   return;
   }

   set feinputreader ""

   switch $FE_type {
      "OptiStruct" {
         set feinputreader #optistruct\\optistruct
      }
      "RADIOSS (Block)" {
         set feinputreader #radioss\\radiossblk
      }
      "Abaqus" {
         set feinputreader #abaqus\\abaqus
      }
      "Actran" {
         set feinputreader #actran\\actran
         set FE_entParams ""
         set FE_solverParams ""
      }
      "Ansys" {
         set feinputreader #ansys\\ansys
         set FE_solverParams ""
      }
      "LsDyna (Keyword)" {
         set feinputreader #ls-dyna\\dynakey
      }
      "Madymo" {
         set feinputreader #madymo\\madymo
         set FE_solverParams ""
      }
      "Nastran" {
         set feinputreader #nastran\\nastran
      }
      "Pamcrash2G" {
         set feinputreader #pamcrash2G\\pamcrash2G
         set FE_solverParams ""
      }
      "Permas" {
         set feinputreader #permas\\permas
         set FE_solverParams ""
      }
      "CFD" {
         set feinputreader #nastran\\nastran
         set FE_entParams ""
         set FE_solverParams "NASTRAN_CFD"
      }
      "HMASCII" {
         set feinputreader #hmascii\\hmascii
         set FE_entParams ""
         set FE_solverParams ""
      }
      "Marc" {
         set feinputreader #marc\\marc
         set FE_entParams ""
         set FE_solverParams ""
      }
      "Samcef" {
         set feinputreader #samcef\\samcef
         set FE_entParams ""
         set FE_solverParams ""
      }
      "Patran" {
         set feinputreader #patran\\patran
         set FE_entParams ""
         set FE_solverParams ""
      }
      "Movie" {
         set feinputreader #movie\\movie
         set FE_entParams ""
         set FE_solverParams ""
      }
      "Stl" {
         set feinputreader #stl\\stl
         set FE_entParams ""
         set FE_solverParams ""
      }
      "Ideas" {
         set feinputreader #ideas\\ideas
         set FE_entParams ""
         set FE_solverParams ""
      }
      "Cmold" {
         set feinputreader #cmold\\cmold
         set FE_entParams ""
         set FE_solverParams ""
      }
      "Moldflow" {
         set feinputreader #moldflow\\moldflow
         set FE_entParams ""
         set FE_solverParams ""     
      }
      "Moldex3D Solid" {
         set feinputreader #moldex3D\\moldex
         set FE_entParams ""
         set FE_solverParams ""
      }
      "Moldex3D Shell" {
         set feinputreader #moldex3D_shell\\moldex3D_shell
         set FE_entParams ""
         set FE_solverParams ""
      }
      "Pamcrash" {
         set feinputreader #pamcrash\\pamcrash
         set FE_entParams ""
         set FE_solverParams ""
      }
      "RADIOSS (Fix)" {
         set feinputreader #radioss\\radiossfix
         set FE_entParams ""
         set FE_solverParams ""
      }
      "LsDyna (Sequential)" {
         set feinputreader #ls-dyna\\dynaseq
         set FE_entParams ""
         set FE_solverParams ""
      }
      "RADIOSS (Parm)" {
         set feinputreader ""
         set FE_entParams ""
         set FE_solverParams ""
      }
      "Deform" {
         set feinputreader #deform\\deform
         set FE_entParams ""
         set FE_solverParams ""
      }
      default { #This is for 'Custom'
         set feinputreader "$FE_custTrans"
         set FE_entParams ""
         set FE_solverParams ""
      }
   }
   set FE_organizeParam ""
   set FE_propertyParam ""
   if {[::hwt::EntryState $::Import_GUI::FE_organizeMenu] != "disabled" && $FE_organizeVal == "By HM Comments"} {
      if {[::hwt::EntryState $::Import_GUI::FE_propertyMenu] != "disabled" && $FE_propertyVal == "On Element"} {
         set FE_propertyParam "ASSIGNPROP_ONELEMS"
      } elseif {[::hwt::EntryState $::Import_GUI::FE_propertyMenu] != "disabled" && $FE_propertyVal == "By HM Comments"} {
         set FE_propertyParam "ASSIGNPROP_BYHMCOMMENTS"
      }
   } elseif {[::hwt::EntryState $::Import_GUI::FE_organizeMenu] != "disabled" && $FE_organizeVal == "By Property"} {
      set FE_organizeParam "IMPORT_BYPROP"
      if {[::hwt::EntryState $::Import_GUI::FE_propertyMenu] != "disabled" && $FE_propertyVal == "On Element"} {
         set FE_propertyParam "ASSIGNPROP_ONELEMS"
      } elseif {[::hwt::EntryState $::Import_GUI::FE_propertyMenu] != "disabled" && $FE_propertyVal == "On Component"} {
         set FE_propertyParam "ASSIGNPROP_ONCOMPS"
      }
   } elseif {[::hwt::EntryState $::Import_GUI::FE_organizeMenu] != "disabled" && $FE_organizeVal == "By 1 Component"} {
      set FE_organizeParam "IMPORT_BY1COMP"
      set FE_propertyParam "ASSIGNPROP_ONELEMS"
   } elseif {[::hwt::EntryState $::Import_GUI::FE_organizeMenu] != "disabled" && $FE_organizeVal == "By Material"} {
      set FE_organizeParam "IMPORT_BYMATERIAL"
      set FE_propertyParam "ASSIGNPROP_ONELEMS"
   }
   
   if {$FE_includeImport == 0} {
        if { $FE_type == "LsDyna (Keyword)" } {
            foreach flag $FE_solverFlags {
              if {"include_stamped_part" == $flag || "include_stamped_part_set" == $flag} {
                set FE_solverFlags [lremove $FE_solverFlags $flag ]
                break;
              }
            }
        }
        ::Import_GUI::FE_advAccept
   }

   if {$FE_importVal == "All"} {
       set extra_params "\"$::g_profile_name \" \"$::g_sub_profile_name \" $FE_solverParams $FE_organizeParam $FE_propertyParam"
   } else {
       set extra_params "\"$::g_profile_name \" \"$::g_sub_profile_name \" $FE_entParams $FE_solverParams $FE_organizeParam $FE_propertyParam"
   }

   if {$FE_displayVal != "All" && $FE_entDParams != ""} {
       set extra_params "$extra_params $FE_entDParams"
   }

   if {$FE_overwriteState == 1 && [::hwt::EntryState $FE_importMenu] == "normal"&& $FE_type != "Ansys" } {
      if {[lsearch $extra_params "BEAMSECTCOLS_SKIP "] == -1 && [lsearch $FE_entExclude "Beam section collectors"] == -1} {
         lappend extra_params "BEAMSECTCOLS_SKIP "
      }
      if {[lsearch $extra_params "BEAMSECTS_SKIP "] == -1 && [lsearch $FE_entExclude "Beam sections"] == -1} {
         lappend extra_params "BEAMSECTS_SKIP "
      }
   }


    if { $FE_type == "OptiStruct" || $FE_type == "Nastran" } {
        lappend  extra_params "PATRAN"
        lappend  extra_params "ANSA" 
   }       
   if { $::HM_Framework::Settings::Import::FE_import_parts == 1 } {
      lappend extra_params "import_parts_instances"
    }  

    if { $::HM_Framework::Settings::Import::FE_import_ansa_comments == 1 } {
      lappend extra_params "import_ansa_connector_comments"
    }  
   set num_extra_params [llength "$extra_params"]

   hm_blockerrormessages 0
   hm_blockmessages 0
   hm_commandfilestate 1

   if {$FE_include == "Skip"} {
      catch {*feinputomitincludefiles};
   }

   if {$FE_include == "Preserve"} {
      catch {*feinputpreserveincludefiles};
   }

   if {$FE_offsetState == 1} {
      foreach entity [array names FE_offsetVals] {
         catch {*feinputoffsetid $entity $FE_offsetVals($entity)}
      }
   }

   if {$FE_includeImport == 1} {
#       set temp [encoding convertfrom [file normalize $FE_singleFile]]
       set temp [encoding convertfrom identity [encoding convertto cp932 [file normalize $FE_singleFile]]]
       set shortName [file tail $temp]
       set fullName  "$temp"
       set pathName  [file dirname $temp]

       set incShortNames [hm_getincludes -byshortname]
       set incFullNames  [hm_getincludes -byfullname]
       set count 0
       set temp ""
       foreach incFullName $incFullNames {
#           set temp [lreplace $incFullNames $count $count "[encoding convertfrom identity [file normalize $incFullName]]"]
           set temp [lreplace $incFullNames $count $count "[encoding convertfrom identity [encoding convertto cp932 [file normalize $incFullName]]]"]
       }
       set incFullNames "$temp"

       #Determine if include shortname and/or fullname already exist.  If so, increment numerically to get a unique shortname and fullname.
       set sn 0
       set fn 0
       set count 1
       set snt "$shortName"
#       set fnt "[encoding convertfrom identity [file normalize $fullName]]"
       set fnt "[encoding convertfrom identity [encoding convertto cp932 [file normalize $fullName]]]"

       while {$sn == 0 || $fn == 0} {
           set sn 0
           set fn 0

           if {[lsearch $incShortNames "$snt"] == -1} {
               set sn 1
           }

           if {[lsearch $incFullNames "$fnt"] == -1} {
               set fn 1
           }

           if {$sn == 1 && $fn == 1} {
               set shortName "$snt"
           } else {
               set snt "$shortName\.$count"
#               set fnt "[encoding convertfrom identity [file normalize $pathName/$snt]]"
               set fnt "[encoding convertfrom identity [encoding convertto cp932 [[file normalize $pathName/$snt]]]"
               incr count
           }
       }

       #Determine current include ID to set as parent.
       set curInclude [hm_info currentinclude]
       if {$curInclude == "\[ Master Model \] " || $curInclude == ""} {
           set parentId 0
       } else {
           set parentId [hm_getincludeid $curInclude -byshortname]
       }

$       set fullName [encoding convertfrom identity [file normalize $pathName/$shortName]]
       set fullName [encoding convertfrom identity [encoding convertto cp932 [file normalize $pathName/$shortName]]]

       set includeType 0
       if { $FE_type == "LsDyna (Keyword)" } {
           set skipIncludeFlag 0
           foreach flag $FE_solverFlags {
                if { "SKIP_INCLUDE_STAMP" == $flag } {
                    set skipIncludeFlag $FE_solverInfo($flag,state)
                }
                if { "include_stamped_part" == $flag } {
                    set includeType 7
                    set type 1
                } elseif { "include_stamped_part_set" == $flag } {
                    set includeType 8
                    set type 2
                } elseif { "compensation_blank_before_springback" == $flag } {
                    set includeType 2
                } elseif { "compensation_blank_after_springback" == $flag } {
                    set includeType 3
                } elseif { "compensation_desired_blank_shape" == $flag } {
                    set includeType 4
                } elseif { "compensation_compensated_shape" == $flag } {
                    set includeType 5
                } elseif { "compensation_current_tools" == $flag } {
                    set includeType 6
                }
           }
           if { $includeType == 7 || $includeType == 8 } {
                set systcolName [hm_getincrementalname systcols IncludeStamp_]
                *collectorcreate systcols $systcolName "" 7
                *createmark systcols 1  -1
                set systcolId [hm_getmark systcols 1 ]
                hm_markclear systcols 1
                *attributeupdateint systcols $systcolId 4324 9 1 0 1;
                *attributeupdateint systcols $systcolId 165 9 1 0 $type ;
                *attributeupdatestring systcols $systcolId 4334 9 2 0 $fullName;
            }
        }

        *createinclude 0 "$shortName" "$fullName" $parentId
        #Issue 254401
        if {$FE_type == "RADIOSS (Block)"} {
               catch {   
                       hm_createmark cards 1 -1;
                       set ID [hm_getmark cards 1]
                       set im1 [hm_getcardimagename cards $ID]
                       if { $im1 == "INCLUDEFILE_BEGIN"} {
                            hm_createmark cards 1 $ID 
                           *deletemark cards 1
                          } else {
                                   Message "'import as include' usecase Error in card creation"
                                    #Issue 254401
                                 }
                       #feinputimportasinclude
                     }
                       set num_extra_params [expr {$num_extra_params + 1}]
                       lappend  extra_params {importasinclude}
           }

        if { $FE_type == "LsDyna (Keyword)" } {
            *updateincludedata 0 "$shortName" 1 $skipIncludeFlag 1 $includeType 0 0;
        }
   }

   ::hwt::Pcursor wait
   #Message "num_extra_params = $num_extra_params"
   #Message "extra parameter = $extra_params"
   if {$FE_type == "RADIOSS (Parm)"} {
      catch {*parmtran "[file normalize $FE_singleFile]"}
   } elseif {$num_extra_params >= 1} {
      catch {eval *createstringarray $num_extra_params $extra_params}
      catch {*feinputwithdata2 "$feinputreader" "[encoding convertfrom identity [encoding convertto cp932 [file normalize $FE_singleFile]]]" $FE_overwriteState 0 0 0 $FE_offsetState 1 $num_extra_params 1 0}
   } else {
      catch {*feinputwithdata2 "$feinputreader" "[encoding convertfrom identity [encoding convertto cp932 [file normalize $FE_singleFile]]]" $FE_overwriteState 0 0 0 $FE_offsetState 1 0 1 0}
   }

   if {[string tolower $::g_profile_name] == "hyperform" && $FE_type == "RADIOSS (Block)"} {
        *hf_LevelElementsOnOff 0
   }

   if {$FE_includeImport == 1} {
       *setcurrentinclude $parentId
   }
   if {$FE_type == "RADIOSS (Block)" || $FE_type == "LsDyna (Keyword)"} {         #issue 236622
     catch {
            if {$FE_type == "LsDyna (Keyword)"} { # 251980
                set cardList [hm_entitylist cards id]
                if { $cardList != "" } {
                    foreach cardId $cardList {
                        set hmxname [hm_getvalue cards id=$cardId dataname=FileNameHmx];
                        if { $cardList != {} } {
                            break;
                        }
                    }
                }
            } else {
            set hmxname [hm_getentityvalue cards "HEADER_CARD" \$Filenamehmx 1 -byname];
            }

            set len2 [llength $hmxname]
	 	    if {$len2 !=0} {
	 		    set IncId [hm_getincludeid $hmxname -byshortname]

                #Issue 260329: hmx in filepath
                set last [string last "/" $hmxname];
                if {$last == -1} {                   
                    set path1 [hm_info -appinfo CURRENTWORKINGDIR]
	                cd "$path1"
	                set path1 [pwd]
	                append path1 "/"
	                append path1 $hmxname
                    *updateinclude $IncId 1 $hmxname 1 $path1  1 0
                    *updateincludedata $IncId  $hmxname 1 1 0 0  0 0
                  } else {
                              set shortnamehmx [string range $hmxname $last+1 end]
	 		                  *updateinclude $IncId 1 $shortnamehmx 1 $hmxname  1 0
                              *updateincludedata $IncId  $hmxname 1 1 0 0  0 0
                            #Issue 260329: hmx in filepath		   
                         }
	 		   }
            }
      }
      
   ::hwt::Pcursor
}


# When the "import" button is clicked, this procedure is called.
proc ::Import_GUI::Geometry_Accept args {
   variable ::HM_Framework::Settings::Import::Geom_typeVal
   variable Geom_import
   variable Geom_singleFile
   variable Geom_filesListbox
   variable Geom_featuresImportCheck
   variable ::HM_Framework::Settings::Import::Geom_scaleVal
   variable ::HM_Framework::Settings::Import::Geom_cleanup
   variable ::HM_Framework::Settings::Import::Geom_cleanupVal
   variable Geom_offsetState
   variable Geom_offsetVals
   variable ::HM_Framework::Settings::Import::Geom_importBlank
   variable ::HM_Framework::Settings::Import::Geom_nameComps
   variable ::HM_Framework::Settings::Import::Geom_importComposite
   variable ::HM_Framework::Settings::Import::Geom_compositeReadHiddenPlySurfaces
   variable ::HM_Framework::Settings::Import::Geom_compositeTrimPlySurfaces
   variable ::HM_Framework::Settings::Import::Geom_splitComponentsByBody
   variable ::HM_Framework::Settings::Import::Geom_splitComponentsByPart
   variable ::HM_Framework::Settings::Import::Geom_importPublication
   variable ::HM_Framework::Settings::Import::Geom_avoidLineMerging
   variable ::HM_Framework::Settings::Import::Geom_createFibersim
   variable ::HM_Framework::Settings::Import::Geom_featuresImport
   variable ::HM_Framework::Settings::Import::Geom_useDependentTrans
   variable ::HM_Framework::Settings::Import::Geom_stiffenerJustCurves
   variable title
   variable import_suffix
   variable Geom_importPublicationCheck

   set import_suffix "_reader"
   set Geom_importFiles ""
   if {[$::Import_GUI::Geom_filesListbox index end] == 0} {
      tk_messageBox -icon error -title "$title" -message "No import files selected."
      return
   } else {
      set invalid ""
      foreach file1 [$::Import_GUI::Geom_filesListbox get 0 end] {
         if {[file isfile $file1] == 0} {
            lappend invalid $file1
         } else {
            lappend Geom_importFiles "$file1"
         }
      }

      if {$invalid != ""} {
         set temp [join $invalid \n]
         tk_messageBox -icon error -title "$title" -message "Invalid filenames:\n$temp"
         return
      }
   }

   if {$Geom_cleanup == "Manual" && $Geom_cleanupVal == ""} {
      tk_messageBox -icon error -title "$title" -message "Cleanup tol not specified."
      return
   }

   switch $Geom_typeVal {
      "Auto Detect" {
         set type "#Detect"
      }
      "Pro E" {
         if {$Geom_useDependentTrans == 0} {
            set type "#ct\\proe_reader"
         } else {
            set type "#proe\\proe_reader"
         }
      }
      "STEP" {
         set type "#ct\\step_reader"
      }
      "ACIS" {
         set type "#ct\\acis_reader"
      }
      "Parasolid" {
         if {$Geom_useDependentTrans == 0} {
            set type "#ct\\parasolid_reader"
         } else {
            set type "#[string tolower $Geom_typeVal]\\[string tolower $Geom_typeVal][string tolower $import_suffix]"
         }
      }
      "CATIA" {
         if {$Geom_useDependentTrans == 0} {
            set type "#ct\\catia_reader"
         } else {
            set type "#[string tolower $Geom_typeVal]\\[string tolower $Geom_typeVal][string tolower $import_suffix]"
         }
      }
      "SolidWorks" {
         set type "#ct\\solidworks_reader"
      }
      "FiberSim" -
      "CATIA Composites Link" {
         set type "#fibersim\\fibersim_reader"
      }
      "UG" {
         if {$Geom_useDependentTrans == 0} {
            set type "#ct\\ug_reader"
         } else {
            set type "#[string tolower $Geom_typeVal]\\[string tolower $Geom_typeVal][string tolower $import_suffix]"
         }
      }
      default {
         set type "#[string tolower $Geom_typeVal]\\[string tolower $Geom_typeVal][string tolower $import_suffix]"
      }
   }

   if {$Geom_cleanup == "Automatic"} {
      set cleanup "-0.01"
   } else {
      set cleanup "$Geom_cleanupVal"
   }

   hm_blockerrormessages 0
   hm_blockmessages 0
   hm_commandfilestate 1

   if {$Geom_offsetState == 1} {
      foreach entity [array names Geom_offsetVals] {
         catch {*feinputoffsetid $entity $Geom_offsetVals($entity)}
      }
   }

   ::hwt::Pcursor wait
   set h5Flag 0
   set fileList {}
   set h5List {}
   if {$Geom_typeVal == "Auto Detect"} {	
		foreach tmpFile $Geom_importFiles {
			if { [file extension $tmpFile] == ".h5" } {
				set h5Flag 1
				lappend h5List $tmpFile
			} else {
				lappend fileList $tmpFile
			}
		}		
   } elseif { $Geom_typeVal == "FiberSim" || $Geom_typeVal == "CATIA Composites Link" } {
		set h5List $Geom_importFiles
   }
   if {$Geom_typeVal == "FiberSim" || $Geom_typeVal == "CATIA Composites Link" || $h5Flag == 1} {
     set nStr [expr {[llength $h5List] + 2}]
	 eval *createstringarray $nStr {$Geom_typeVal} $Geom_createFibersim $h5List 
	 catch {*feinputwithdata2 "#fibersim\\fibersim_reader" "[lindex $h5List 0]" 0 0 $cleanup $Geom_importBlank $Geom_offsetState 1 $nStr $Geom_scaleVal $Geom_importComposite}
     set Geom_importFiles $fileList
   }
   foreach file1 $Geom_importFiles {
      set ls_data_strings ""
      if {$Geom_typeVal == "CATIA"} {
         if {$Geom_importComposite} {
           lappend ls_data_strings "CADIO_IMPORT_COMPOSITE_DATA"
           if {$Geom_compositeReadHiddenPlySurfaces} {
             lappend ls_data_strings "CADIO_IMPORT_HIDDEN_PLY_SURFACES" 
           }
           if {$Geom_compositeTrimPlySurfaces} {
             lappend ls_data_strings "CADIO_TRIM_PLY_SURFACES" 
           }
         }
      }

     if {$Geom_typeVal == "CATIA" || $Geom_typeVal == "Parasolid" || $Geom_typeVal == "Pro E" || $Geom_typeVal == "STEP"} {
       if {$Geom_splitComponentsByBody} {
             lappend ls_data_strings "CADIO_SPLIT_COMPONENTS_BY_BODY"
       }
     }

     if {$Geom_typeVal == "CATIA"} {
        if { $Geom_importPublication} {
           lappend ls_data_strings "CADIO_IMPORT_PUBLICATION_DATA"
       }
     }

     if {$Geom_typeVal == "CATIA"} {
       if {$Geom_splitComponentsByPart} {
           lappend ls_data_strings "CADIO_SPLIT_COMPONENTS_BY_PART"
       }
     }

     if {$Geom_avoidLineMerging} {
        lappend ls_data_strings "CADIO_AVOID_EDGES_MERGING"
     }

     if {$Geom_typeVal == "Intergraph"} {
         if {$Geom_stiffenerJustCurves} {
           lappend ls_data_strings "CADIO_STIFFENER_JUST_CURVES"
         }
      }

     if { [hm_getshowfeaturestatus] == 1 && [$Geom_featuresImportCheck cget -state] != "disabled" && $Geom_featuresImport == 1 } {
        lappend ls_data_strings "CADIO_IMPORT_FEATURE_DATA"
     }

      set num_strings [llength $ls_data_strings]
      if {$num_strings} {
        eval *createstringarray $num_strings $ls_data_strings
      }

      if { [hm_getshowfeaturestatus] == 1 && [$Geom_featuresImportCheck cget -state] != "disabled" && $Geom_featuresImport == 1 } {
        set designTableFile $::HM_Framework::Settings::Import::Geom_singleFile
# Win7 need "convertto cp932" before "convertfrom identity"
#        catch {*importcadfilewithfeatures "$type" "[encoding convertfrom identity [file normalize $file1]]" "$designTableFile" $cleanup $Geom_importBlank $Geom_scaleVal 1 $num_strings}
        catch {*importcadfilewithfeatures "$type" "[encoding convertfrom identity [encoding convertto cp932 [file normalize $file1] ] ]" "$designTableFile" $cleanup $Geom_importBlank $Geom_scaleVal 1 $num_strings}
      } else {
        catch {*feinputinteractive2 "$type" "[encoding convertfrom identity [encoding convertto cp932 [file normalize $file1]]]" 1 0 $cleanup $Geom_importBlank $Geom_offsetState 1 $num_strings 1 $Geom_scaleVal $Geom_nameComps}
      }
   }

   ::hwt::Pcursor
}

# this proc is called when "export" button in FE export tab is pushed.
proc ::Export_GUI::FE_Accept {{toHC 0} args} {
    variable ::HM_Framework::Settings::Export::FE_singleFile
    variable ::HM_Framework::Settings::Export::FE_templateFile
    variable ::HM_Framework::Settings::Export::FE_outputVal
    variable ::HM_Framework::Settings::Export::FE_mergeStarterEngine
    variable ::HM_Framework::Settings::Export::FE_failedState
    variable ::HM_Framework::Settings::Export::FE_connectorsState
    variable ::HM_Framework::Settings::Export::FE_commentsState
    variable ::HM_Framework::Settings::Export::FE_engineState
    variable ::HM_Framework::Settings::Export::FE_includeVal
    variable ::HM_Framework::Settings::Export::overwritePrompt
    variable ::HM_Framework::Settings::Export::FE_subtype
    variable ::HM_Framework::Settings::Export::FE_type
    variable ::HM_Framework::Settings::Export::fluent_model
    variable ::HM_Framework::Settings::Export::cgns_elem_by_conf
     variable ::HM_Framework::Settings::Export::FE_exportenginekeysalone
    variable FE_solverInfo
    variable FE_solverFlags
    variable FE_solverParams
    variable FE_num_solverParams
    variable FE_fileMenu
    variable title
    
    #below line is for check box of entity export info, right now deactivated will be activated on demand
    #variable ::HM_Framework::Settings::Export::FE_exportTimeInfo

# do not "encoding" here because file check is coming later.
#    set FE_singleFile [encoding convertfrom identity [file nativename [file normalize $FE_singleFile]]]
    set FE_singleFile [file nativename [file normalize $FE_singleFile]]

    # Code added to deactivate transformation cards in radioss (block90) lsdyna (Keyword970, Keyword971, Keyword971_R6.1 and Keyword971_R7.0) and pamcrash2g user profiles.
    # Transformation cards need to be deactivated before deck is exported
    if {($FE_type == "RADIOSS" && ($FE_subtype == "Block90" || $FE_subtype == "Block100" || $FE_subtype == "Block110" || $FE_subtype == "Block120" || $FE_subtype == "Block130")) || ($FE_type== "LsDyna" && ($FE_subtype == "Keyword970" || $FE_subtype == "Keyword971" || $FE_subtype == "Keyword971_R6.1" || $FE_subtype == "Keyword971_R7.0")) || $FE_type == "Pamcrash"} {
        source "[file join [hm_info -appinfo SPECIFIEDPATH hm_scripts_dir] browser transformation_manager main_transformation.tcl]";
        hm_setpanelproc [::hm::view::transmngr::ActivateNone];
    }

    set radioss_block_condt 0
    set radioss_block_ver 44
    if {$FE_type == "RADIOSS" && ($FE_subtype == "Block51" || $FE_subtype == "Block90" || $FE_subtype == "Block100" || $FE_subtype == "Block110" || $FE_subtype == "Block120" || $FE_subtype == "Block44" || $FE_subtype == "Block42" || $FE_subtype == "Block130")} {
        *setcurrentinclude 0 "";
        if { [hm_controlcardattributedefined "HEADER_CARD" "HEADER_CARD"] != 1 } {
            *cardcreate HEADER_CARD;

			if { $::g_profile_name == "HyperForm" } {
				# units: mg, mm, s
				set id [hm_getentityvalue cards "HEADER_CARD" id 0 -byname];
				foreach {d u} [list mass mg length mm time s] {
						*setvalue cards id=$id ${d}_inp_opt=2 STATUS=2            
						*setvalue cards id=$id ${d}_inputunit_code=$u STATUS=2
            
						*setvalue cards id=$id ${d}_out_opt=2 STATUS=2
						*setvalue cards id=$id ${d}_workunit_code=$u STATUS=2
				}
			}
        }
        set d_headercard [hm_getentityvalue cards "HEADER_CARD" id 0 -byname];

        if {$FE_includeVal == "Merge" } {
            *attributeupdateint cards $d_headercard 233 20 1 1 1;
        } else {
            *attributeupdateint cards $d_headercard 233 20 1 1 2;
        }

        set ids [hm_getincludes]
        set names [hm_getincludes -byshortname];
        foreach n_include $ids {
            set n_index [lsearch -exact -integer $ids $n_include];

            if {$n_index != -1} {
                set includename [lindex $names $n_index];
                *setcurrentinclude 0 $includename;

                if {[info exist ::UserProfiles::RadiossBlock::arr_beginIdForInclude($n_include)]} {
                    set d_begincard [set ::UserProfiles::RadiossBlock::arr_beginIdForInclude($n_include)];
                    if {$d_begincard != 0 } {
                       hm_blockerrormessages 1
                       #mismatch can occur incase of 'import as include',so catch it.
                       catch { *attributeupdatestring cards $d_begincard 4600 20 1 0 $includename;}
                       hm_blockerrormessages 0
                        set ::UserProfiles::RadiossBlock::arr_beginIdForInclude($n_include) 0;
                    }
                }
            }
        }
       set radioss_block_condt [string match "Block*" $FE_subtype]
       set str1 ""
       if {$radioss_block_condt ==1} {
            set str1 [split $FE_subtype "Block"]
          }
              
            foreach item $str1 {
               if {$item != {}} {
                    set radioss_block_ver $item
                  }
            }
              
    }

    if {$FE_singleFile == ""} {
        tk_messageBox -icon error -title "$title" -message "No export filename specified."
        return
    } elseif {[file isdirectory [file dirname $FE_singleFile]] == 0} {
        tk_messageBox -icon error -title "$title" -message "[file nativename [file normalize [file dirname $FE_singleFile]]] is not a valid path."
        return
    } elseif {[file nativename [file normalize [file dirname $FE_singleFile]]] == $FE_singleFile} {
        tk_messageBox -icon error -title "$title" -message "$FE_singleFile is not a valid filename."
        return
    } elseif {[file writable [file dirname $FE_singleFile]] == 0} {
        #tk_messageBox -icon error -title "$title" -message "[file nativename [file normalize [file dirname $FE_singleFile]]] is read-only."
        #return
    } elseif {[file exists $FE_singleFile] == 1 && [file writable $FE_singleFile] == 0} {
        #tk_messageBox -icon error -title "$title" -message "$FE_singleFile is read-only."
        #return
    } else {
        set FE_singleFile [::Export_GUI::checkFileExtension $FE_type $FE_subtype $FE_singleFile]
        catch {::hwt::SetCursorHelp $::Export_GUI::FE_fileMenu $::HM_Framework::Settings::Export::FE_singleFile}
        catch {$::Export_GUI::FE_fileMenu.frame.entFrame.entry xview end}
        update
    }

    if {$FE_templateFile != "dummy"} {
    set FE_templateFile [encoding convertfrom identity [file nativename [file normalize $FE_templateFile]]]
    }

    if {$FE_templateFile == ""} {
        tk_messageBox -icon error -title "$title" -message "No template specified."
        return
    } elseif {$FE_templateFile != "dummy" && [file isfile $FE_templateFile] == 0} {
        tk_messageBox -icon error -title "$title" -message "Invalid template specified."
        return
    }

    if {$FE_outputVal == "All"} {
        set all 1
    } elseif {$FE_outputVal == "Displayed"} {
        set all 0
    } else {
        set all 2
    }

    if { $FE_type == "Abaqus" && [info exist ::HM_Framework::Settings::Export::FE_ExportIdState]} {
        if { $::HM_Framework::Settings::Export::FE_ExportIdState == 1 } {
            ::Export_GUI::MapEntityRecord;
            ::Export_GUI::UpdateEntityWithPrefixId;
        }
    }
	 if { $FE_type == "Abaqus" } {
		set group_names ""
		set elem_id ""
		set surface_nameList ""
		set elemTypeList ""
		set new_surf_nam ""
		*clearmark elems 1 all
		eval { *createmark elems 1 "by config type" 9 55 } 
		eval { *appendmark elems 1 "by config type" 2 56 }
		
		if { [hm_marklength elems 1] } {
		    set surface_nameList [hm_getvalue elems mark=1 dataname=3528];
			set elemTypeList [hm_getmarkvalue elems 1 typename 1];
			set elem_id [hm_getmark elems 1];
			set searchList {COUP_KIN COUP_DIS}   
			*clearmark groups 1
			*createmark groups 1 all
			if { [hm_marklength groups 1 ] } {
				set group_names [hm_getvalue groups markid=1 dataname=name]
			}
			set var {};
			set surface_nam "";
			set indx 0;
			foreach id $elem_id { 
				if { [lindex $elemTypeList $indx] in $searchList } {
					set surface_nam [lindex $surface_nameList $indx];
					if {$surface_nam == ""} {continue;}

					if { $surface_nam ni $var  && $surface_nam ni $group_names } {  
						lappend var $surface_nam
					} else {
						set new_surf_nam [::hwat::utils::GetUniqueName groups $surface_nam$id]
						*attributeupdatestring elements $id 3528 2 2 0 "$new_surf_nam"
						lappend var $new_surf_nam
					}
				}
				incr indx;
			}
		}
	}
    hm_blockerrormessages 0
    hm_blockmessages 0
    *retainmarkselections 0
    *entityhighlighting 1
    hm_commandfilestate 1

    # In case of CFD Writers, All CFD writers are not implementaed using templates.
    # So A check is made for the CFD and then then respective TCL methods are called.
    if {$FE_type == "CFD" } {
        ::Export_GUI::FE_CFDFileExport $FE_singleFile
        return ;
    }

    set answer1 "yes"
    if {$overwritePrompt == 1} {
        set exp 0
        #Check for the existence of any include files and prompt accordingly
        if {$FE_includeVal == "Preserve" && [hm_getincludes] != ""} {
            foreach includePair [hm_getincludes -byshortnameexportpair] FE_includeFile [hm_getincludes -byfullname] includeMergePair [hm_getincludes -byshortnamealwaysmergeflagpair] {
                if {[lindex $includePair 1] == 0 && [lindex $includeMergePair 1] == 0} {
                    if {([file pathtype $FE_includeFile] == "relative" && [file isfile "[file dirname $FE_singleFile]/$FE_includeFile"] == 1) || [file isfile $FE_includeFile] == 1} {
                        set exp 1
                        break
                    }
                }
            }
        }

        if {$exp == 1 && [file isfile $FE_singleFile] == 0} {
            set answer1 [tk_messageBox -icon question -type yesno -title "$title" -message "One or more include files exist.\nOverwrite?"]
        } elseif {$exp == 1 && [file isfile $FE_singleFile] == 1} {
            set answer1 [tk_messageBox -icon question -type yesno -title "$title" -message "Master file and one or more include files exist.\nOverwrite?"]
        } elseif {[file isfile $FE_singleFile] == 1} {
            set answer1 [tk_messageBox -icon question -type yesno -title "$title" -message "$FE_singleFile exists.\nOverwrite?"]
        }
    }

    if {$answer1 == "yes"} {
        ::hwt::Pcursor wait
        if {$FE_type == "RADIOSS" && ($FE_subtype == "Block51" || $FE_subtype == "Block90" || $FE_subtype == "Block100" || $FE_subtype == "Block110" || $FE_subtype == "Block120" || $FE_subtype == "Block130") } {
             if {$FE_exportenginekeysalone ==1} {
#                    set argFilename1  "[list [encoding convertfrom identity [file normalize $FE_singleFile]]]"  
                    set argFilename1  "[list [encoding convertfrom identity [encoding convertto cp932 [file normalize $FE_singleFile]]]]"  
                    set argTemplate1  "[encoding convertfrom identity [file normalize $FE_templateFile]]"
                    ::hwt::Source [hm_info -appinfo SPECIFIEDPATH hm_scripts_dir ]//radioss//D01//radiossblock_enginefile_export_batch_mode.tcl
                    ::UserProfiles::RadiossBlock::GetRunNameandUpdateCompulsoryEngineCards $argFilename1
                    ::UserProfiles::RadiossBlock::unset_batch_variables; 
                    hm_batchexportenginefile 1 $argFilename1  $argTemplate1
                   ::hwt::Pcursor
                   return;
             }
             
            ::hwt::Source [hm_info -appinfo SPECIFIEDPATH hm_scripts_dir ]//radioss//D01//radiossblock_enginefile_export_batch_mode.tcl
            if {$FE_mergeStarterEngine ==1} {
                      ::UserProfiles::RadiossBlock::set_batch_variables;
            } else {
                     ::UserProfiles::RadiossBlock::unset_batch_variables;
                }
            }

        if {$FE_type == "RADIOSS" && $radioss_block_condt == 1 && $radioss_block_ver <=44} {
            catch {
                if {$FE_mergeStarterEngine ==1} {
#                    ::Export_GUI::FE_RadiossEngine "[list [encoding convertfrom identity [file normalize $FE_singleFile]]]"
                    ::Export_GUI::FE_RadiossEngine "[list [encoding convertfrom identity [encoding convertto cp932 [file normalize $FE_singleFile]]]]"
                }
            }
        }
        
         if {$FE_type == "Marc"} {
            ::Export_GUI::OnChkBtnMarcExtendedFrmtClick
         }
        
        if {$FE_includeVal == "Preserve"} {
            *feoutputmergeincludefiles 0
        }

        set extra_params {}
        set num_extra_params 0

        if {[info exist FE_solverInfo] == 1} {
            if {$FE_num_solverParams > 0} {
                set num_extra_params $FE_num_solverParams;
                set extra_params $FE_solverParams
            }
        }

        if {$FE_connectorsState == 0} {
            lappend extra_params "CONNECTORS_SKIP"
            incr num_extra_params
        }

        if {$FE_commentsState == 0} {
            lappend extra_params "HMCOMMENTS_SKIP"
           incr num_extra_params
        }
		
		if { $FE_type == "Abaqus" && [info exist ::HM_Framework::Settings::Export::FE_ExportIdState]} {
			if { $::HM_Framework::Settings::Export::FE_ExportIdState == 0 } {
				lappend extra_params "EXPORTIDS_SKIP"
				incr num_extra_params
			}
		}
		
        if {$num_extra_params > 0} {
           catch {eval *createstringarray $num_extra_params $extra_params}
        }

         set argFilename ""
         set argTemplate ""
        
        if {$FE_type == "RADIOSS" && $radioss_block_condt == 1 && $radioss_block_ver >=51} {
#                    set argFilename  "[list [encoding convertfrom identity [file normalize $FE_singleFile]]]"  
                    set argFilename  "[list [encoding convertfrom identity [encoding convertto cp932 [file normalize $FE_singleFile]]]]"  
                    set argTemplate  "[encoding convertfrom identity [file normalize $FE_templateFile]]"
                    set ::UserProfiles::RadiossBlock::templatewithPath $argTemplate

                if {$FE_mergeStarterEngine ==1} {
                     ::UserProfiles::RadiossBlock::GetBatchEngineTemplateinfo 3
                      set FE_templateFile $::UserProfiles::RadiossBlock::templatewithPath
                       ::UserProfiles::RadiossBlock::GetRunNameandUpdateCompulsoryEngineCards $argFilename
                   }           
        }

        if {$FE_type == "Medina" } {
#            catch { set ret_value [*exportbif "[encoding convertfrom identity [file normalize $FE_singleFile]]"] }
            catch { set ret_value [*exportbif "[encoding convertfrom identity [encoding convertto cp932 [file normalize $FE_singleFile]]]"] }
        } else {
            hm_answernext "yes"
#            set val [catch {*feoutputwithdata "[encoding convertfrom identity [file normalize $FE_templateFile]]" "[encoding convertfrom identity [file normalize $FE_singleFile]]" 0 0 $all 1 $num_extra_params}];
            set val [catch {*feoutputwithdata "[encoding convertfrom identity [file normalize $FE_templateFile]]" \
              "[encoding convertfrom identity [encoding convertto cp932 [file normalize $FE_singleFile]]]" 0 0 $all 1 $num_extra_params}];

            ::HM_Framework::SetExport_Error $val;
            #If there is an error in the above *command, then don't go further in the code
            if {$val != 0} {
            	return;
            }        
        }

        if {$FE_failedState == 1 && [hm_getmark elems 1] != ""} {
            set answer1 [tk_messageBox -icon question -type yesno -title "$title" -message "Save invalid elements to user mark?"]
            if {$answer1 == "yes"} {
                hm_saveusermark elems 1 0
                hm_markclear elems 1
                hm_errormessage ""
                hm_usermessage "The invalid elements have been saved to the user mark."
            } else {
                hm_markclear elems 1
                hm_errormessage ""
                hm_errormessage ""
            }
        }

        if {$FE_type == "RADIOSS" && $radioss_block_condt == 1 && $radioss_block_ver <=44} {
            if {$FE_mergeStarterEngine ==0} {
#                ::Export_GUI::FE_RadiossEngine "[list [encoding convertfrom identity [file normalize $FE_singleFile]]]"
                ::Export_GUI::FE_RadiossEngine "[list [encoding convertfrom identity [encoding convertto cp932 [file normalize $FE_singleFile]]]]"
            }
            }
                
        if {$FE_type == "RADIOSS" && $radioss_block_condt == 1 && $radioss_block_ver >=51} {
            if {$FE_mergeStarterEngine ==1} {
                      set FE_templateFile $argTemplate
                      set  ::UserProfiles::RadiossBlock::templatewithPath $argTemplate
               }   
            if {$FE_engineState == 1 && $FE_mergeStarterEngine ==0} {
                ::UserProfiles::RadiossBlock::GetRunNameandUpdateCompulsoryEngineCards $argFilename
                hm_batchexportenginefile 1 $argFilename  $argTemplate
        }
        }
        
        if { $FE_type == "Abaqus" && [info exist ::HM_Framework::Settings::Export::FE_ExportIdState] } {
            if { $::HM_Framework::Settings::Export::FE_ExportIdState == 1 } {
                ::Export_GUI::RenameEntity;
            }
        }

        if {($FE_type== "LsDyna" && ($FE_subtype == "Keyword970" || $FE_subtype == "Keyword971" || $FE_subtype == "Keyword971_R6.1" || $FE_subtype == "Keyword971_R7.0"))} {
            if { [info exists ::Export_GUI::FE_solverInfo(ACTIVATE_TRANSFORMATIONS_AFTER_EXPORT,state)] == 1 } {
                if { $::Export_GUI::FE_solverInfo(ACTIVATE_TRANSFORMATIONS_AFTER_EXPORT,state) == 1 } {
                    source "[file join [hm_info -appinfo SPECIFIEDPATH hm_scripts_dir] browser transformation_manager main_transformation.tcl]";
                    ::hm::view::transmngr::ActivateDeactiveAllIncludes 1;
                }
            }
        }

        ::hwt::Pcursor

        if {$toHC == 1} {
            ::hwt::Source HMtoHC.tcl; ::HMtoHC::LaunchHyperCrash
        }
} else {
	if { $FE_type == "Abaqus" && [info exist ::HM_Framework::Settings::Export::FE_ExportIdState]} {
		if { $::HM_Framework::Settings::Export::FE_ExportIdState == 1 } {
			::Export_GUI::RenameEntity;
        }
}
}

    #below for check box of entity export info, right now deactivated will be activated on demand
    #if {$FE_exportTimeInfo == 1} {
    #  *feoutputtimeinfo 1
    #} else {
    #  *feoutputtimeinfo 0
    #}
    #above for check box of entity export info, right now deactivated will be activated on demand

    if {[hm_getoption outputtimeinfo] == 1} {
    source "[file join [hm_info -appinfo SPECIFIEDPATH hm_scripts_dir] dynakey utils.tcl]"
    set expTimeFileName "_timing.txt"
    set expTimeFileName "$FE_singleFile$expTimeFileName"
    show_file $expTimeFileName "Entity Export Time"
    }
}

proc ::Export_GUI::Geometry_Accept args {
   variable Geom_typeVals
   variable ::HM_Framework::Settings::Export::Geom_typeVal
   variable ::HM_Framework::Settings::Export::Geom_singleFile
   variable Geom_igs_outputVals
   variable ::HM_Framework::Settings::Export::Geom_igs_outputVal
   variable Geom_cad_outputVals
   variable ::HM_Framework::Settings::Export::Geom_cad_outputVal
   variable Geom_igs_unitVals
   variable ::HM_Framework::Settings::Export::Geom_igs_unitVal
   variable Geom_cad_unitVals
   variable ::HM_Framework::Settings::Export::Geom_cad_unitVal
   variable ::HM_Framework::Settings::Export::Geom_unitUser
   variable Geom_planeVals
   variable ::HM_Framework::Settings::Export::Geom_planeVal
   variable Geom_loopVals
   variable ::HM_Framework::Settings::Export::Geom_loopVal
   variable Geom_layerVals
   variable ::HM_Framework::Settings::Export::Geom_layerVal
   variable Geom_enttypeVals
   variable ::HM_Framework::Settings::Export::Geom_enttypeVal
   variable Geom_repmodVals
   variable ::HM_Framework::Settings::Export::Geom_repmodVal
   variable Geom_assemblyVals
   variable ::HM_Framework::Settings::Export::Geom_assemblyVal

   variable Geom_cadoptimize
   variable ::HM_Framework::Settings::Export::Geom_cadoptimizeopt

   variable ::HM_Framework::Settings::Export::overwritePrompt
   variable title

# Do not encode now. Encoding prevend file check.
#   set Geom_singleFile [encoding convertfrom identity [file nativename [file normalize $Geom_singleFile]]]

   if {$Geom_singleFile == ""} {
      tk_messageBox -icon error -title "$title" -message "No export filename specified."
      return
   } elseif {[file isdirectory [file dirname $Geom_singleFile]] == 0} {
      tk_messageBox -icon error -title "$title" -message "[file nativename [file normalize [file dirname $Geom_singleFile]]] is not a valid path."
      return
   } elseif {[file nativename [file normalize [file dirname $Geom_singleFile]]] == $Geom_singleFile} {
      tk_messageBox -icon error -title "$title" -message "$Geom_singleFile is not a valid filename."
      return
   } elseif {[file writable [file dirname $Geom_singleFile]] == 0} {
      #tk_messageBox -icon error -title "$title" -message "[file nativename [file normalize [file dirname $Geom_singleFile]]] is read-only."
      #return
   } elseif {[file exists $Geom_singleFile] == 1 && [file writable $Geom_singleFile] == 0} {
      #tk_messageBox -icon error -title "$title" -message "$Geom_singleFile is read-only."
      #return
   }

   if {$Geom_typeVal == "PARASOLID" || $Geom_typeVal == "STEP"} {
      if {[file extension $Geom_singleFile] == ""} {
         if {$Geom_typeVal == "PARASOLID"} {
            set Geom_singleFile "$Geom_singleFile.x_t"
         } else {
            set Geom_singleFile "$Geom_singleFile.stp"
         }
      }
      if {[file isdirectory $Geom_singleFile] == 1} {
         tk_messageBox -icon error -title "$title" -message "$Geom_singleFile is not a valid filename."
         return
      }
   }

   if {$Geom_cadoptimizeopt == 1} {
      set selcadoptimize 1
   } else {
      set selcadoptimize 0
   }

   if {$Geom_typeVal == "IGES" || $Geom_typeVal == "FiberSim" || $Geom_typeVal == "CATIA Composites Link" } {
      # Getting Export Visible/All Entities
      set allent [lsearch $Geom_igs_outputVals $Geom_igs_outputVal]
      if {$allent == 0} {
         set allent 1
      } elseif {$allent == 1} {
         set allent 0
      }
      set type "#iges\\iges_writer"
      set planemode [lsearch $Geom_planeVals $Geom_planeVal]
      set outerloopmode [lsearch $Geom_loopVals $Geom_loopVal]
      set compsmode [lsearch $Geom_layerVals $Geom_layerVal]
      if {$Geom_igs_unitVal == "User"} {
          if {$Geom_unitUser == ""} {
              set Geom_unitUser "MM"
              set unit "MM"
          } else {
              set unit "$Geom_unitUser"
          }
      } else {
          switch $Geom_igs_unitVal {
            "Microns" {
               set unit "UM"
            }
            "Millimeters" {
               set unit "MM"
            }
            "Centimeters" {
               set unit "CM"
            }
            "Meters" {
               set unit "M"
            }
            "Kilometers" {
               set unit "KM"
            }
            "Microinches" {
               set unit "UIN"
            }
            "Mils" {
               set unit "MIL"
            }
            "Inches" {
               set unit "IN"
            }
            "Feet" {
               set unit "FT"
            }
            "Miles" {
               set unit "MI"
            }
            default {
               set unit "MM"
            }
          }
      }
   } else {
      # Getting Export Visible/All Entities
      set allent [lsearch $Geom_cad_outputVals $Geom_cad_outputVal]
      if {$allent == 0} {
         set allent 1
      } elseif {$allent == 1} {
         set allent 0
      }
      set sel_unit $Geom_cad_unitVal
      set sel_geommode [lsearch $Geom_enttypeVals $Geom_enttypeVal]
      set sel_topomode [lsearch $Geom_repmodVals $Geom_repmodVal]
      set sel_assemode [lsearch $Geom_assemblyVals $Geom_assemblyVal]

      if {$Geom_typeVal == "STEP"} {
        set type "#ct\\step_writer"
      } elseif {$Geom_typeVal == "PARASOLID"} {
        set type "#ct\\parasolid_writer"
      } elseif {$Geom_typeVal == "FiberSim" || $Geom_typeVal == "CATIA Composites Link" } {
        set type "#fibersim\\fibersim_writer"
	  } elseif {$Geom_typeVal == "JT"} {
        set type "#jt\\jt_writer"
      }

   }

   hm_blockerrormessages 0
   hm_blockmessages 0
   hm_commandfilestate 1

   set answer1 "yes"
   if {$overwritePrompt == 1} {
      if {[file isfile $Geom_singleFile] == 1} {
         set answer1 [tk_messageBox -icon question -type yesno -title "$title" -message "$Geom_singleFile exists.\nOverwrite?"]
      }
   }

   if {$answer1 == "yes"} {
      ::hwt::Pcursor wait
      hm_answernext "yes"
      if {$Geom_typeVal == "IGES"} {
#         set val [catch {*iges_write_units "[encoding convertfrom identity [file normalize $Geom_singleFile]]" $planemode $outerloopmode $compsmode "$unit" $allent $selcadoptimize}];
         set val [catch {*iges_write_units "[encoding convertfrom identity [encoding convertto cp932 [file normalize $Geom_singleFile]]]" $planemode $outerloopmode $compsmode "$unit" $allent $selcadoptimize}];
         ::HM_Framework::SetExport_Error $val;
      } elseif { $Geom_typeVal == "FiberSim" || $Geom_typeVal == "CATIA Composites Link" } {
		set io_path [file tail [ hm_info -appinfo HMBIN_DIR]]
		set home [ hm_info -appinfo ALTAIR_HOME]
		set fe_path ""
		if { [ OnPc ] } {
			set fe_path [file join $home "io" "model_writers" "bin" "$io_path" "FibersimExporter.dll"]
		} else {
			if {$::tcl_platform(os) == "Darwin"} {
				set fe_path [file join $home "io" "model_writers" "bin" "$io_path" "FibersimExporter.dylib"]
			} else {
				set fe_path [file join $home "io" "model_writers" "bin" "$io_path" "FibersimExporter.so"]
			}
		}
		set num_strings 2
		eval *createstringarray $num_strings "$unit" {$Geom_typeVal}
#		*feoutputwithdata "[encoding convertfrom identity [file normalize $fe_path]]" "[encoding convertfrom identity [file normalize $Geom_singleFile]]" 0 0 1 1 $num_strings
		*feoutputwithdata "[encoding convertfrom identity [file normalize $fe_path]]" "[encoding convertfrom identity [encoding convertto cp932 [file normalize $Geom_singleFile]]]" 0 0 1 1 $num_strings
	  } else {
#         set val [catch {*geomoutputdata "$type" "[encoding convertfrom identity [file normalize $Geom_singleFile]]" "$sel_unit" $allent $sel_geommode $sel_topomode $sel_assemode $selcadoptimize}];
         set val [catch {*geomoutputdata "$type" "[encoding convertfrom identity [encoding convertto cp932 [file normalize $Geom_singleFile]]]" "$sel_unit" $allent $sel_geommode $sel_topomode $sel_assemode $selcadoptimize}];
         ::HM_Framework::SetExport_Error $val;
      }

      ::hwt::Pcursor
   }
}