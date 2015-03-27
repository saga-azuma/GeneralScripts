# Apply button in the load panel
proc ::post::panel_fileload::Apply args {
        set t [::post::GetT];
        hwi OpenStack;
        
        set err [::post::GetPostHandle p$t];
        if { $err != "success" } { hwi OpenStack; return }
        
        if { [.postPanel.fileload.f1.bApply cget -state] == "disabled" } { hwi OpenStack; return; }

        variable overlay;
        variable modelName;
        variable resultName;
        variable loadModel;
        variable loadResult;
        variable modelReader;
        variable resultReader;
        
        variable regPath
        variable regModelVar
        variable regResultVar

        variable regModelReaderVar


        # close entity editor (issue 306307)
        ::post::browser10::DataItemDeselect PO_ViewModel
        
        hwt::DisableCanvasButton .postPanel.fileload.f1.bApply;
        update;

        # make sure file names are valid
        if { ![ValidFileNames] } {
            hwi CloseStack;
            hwt::EnableCanvasButton .postPanel.fileload.f1.bApply;
            return;
        }
        
        # check the overlay option
        if { ![CanProceed] } {
            hwi CloseStack;
            hwt::EnableCanvasButton .postPanel.fileload.f1.bApply;
            return;
        }        
        
        # clear query panel
        catch { ::post::panel_queryControl::OnClearTable }
            
        if { !$overlay && $loadModel == "normal" } {
            p$t Clear;
            ::post::ResetUndeformedShape;
        }        
        
        
        # Check if we have result math enabled        
        # Call the SetResultMathTemplateFunction        
        SetResultMathTemplate        
        
        hwi GetSessionHandle s$t;
        s$t GetClientManagerHandle pmgr$t animation;
        set rmstate [pmgr$t GetResultMathState];        

        if {$rmstate ==  "true" && $loadModel == "normal" && $loadResult == "normal"} {
            
# encode file name before CreateResultMathAnalysys
            set utf8modelName $modelName
            set utf8resultName $resultName
            set modelName [encoding convertfrom identity [encoding convertto cp932 $modelName]]
            set resultName [encoding convertfrom identity [encoding convertto cp932 $resultName]]

            set curr_tmpl [pmgr$t GetResultMathTemplate];            
            set retcode [CreateResultMathAnalysis $curr_tmpl]
            # need encoding 
#            SetReaderFilter model $modelName;
#            SetReaderFilter result $resultName;
            SetReaderFilter model $utf8modelName;
            SetReaderFilter result $utf8resultName;

# reset modelName and resultName 
            set modelName $utf8modelName
            set resultName $utf8resultName

            hwt::EnableCanvasButton .postPanel.fileload.f1.bApply;
            
            hwi CloseStack;
            
            #Begin of Calculation of % Thinning for solids - tkn
            if {$::post::panel_fileload::rm_curr_template == "Advanced"} {
              hwi OpenStack
              hwi GetSessionHandle session$t
              set path [session$t GetSystemVariable ALTAIR_HOME]
              set filepath [file join $path utility hyperform thinning_solids thinning.tcl]
              catch {hwt::SourceFile $filepath}
              hwi CloseStack
            }
            #End of Calculation of % Thinning for solids - tkn
            
            return;           
        }
        
        set loadStateResult [set loadStateModel 0]
        
        set shouldDraw 0;

        if { $loadModel == "normal" } {

            set id 0;            
            # We decided that file load panel will not pass a reader name            
            # AddModel needs the next complex encoded string.
            set cp932modelName [encoding convertfrom identity [encoding convertto cp932 $modelName]]
#            set loadStateModel [set id [p$t AddModel $modelName]]; 
            set loadStateModel [set id [p$t AddModel $cp932modelName]]; 
            
            if {[info exists ::env(HYPERWORKS_EDU_EDITION)] && !$id} {
                ::hw::PostMessage "Unable to load model.";
                ::hw::ShowMessageLog true;
                set modelReader "";
                hwi CloseStack;
                hwt::EnableCanvasButton .postPanel.fileload.f1.bApply;
                return;
            }
            
            if { !$id } {

                # If we could not find a reader to match the file extension?
                # popup the dialog for user to pick a valid reader.
                set allReaders [lsort -ascii [pmgr$t GetModelReaderList]];
                
                if { [llength $allReaders ] == 0 } {
                    ::hw::PostMessage "No readers available to load model.";
                    ::hw::ShowMessageLog true;

                    set modelReader "";
                    hwi CloseStack;
                    hwt::EnableCanvasButton .postPanel.fileload.f1.bApply;
                    return;
                }
                
                # allow user to choose a reader.                
                ShowReadersDialog model $allReaders;
                
                if { $modelReader != "" } {
                    set loadStateModel [set id [p$t AddModel $modelName $modelReader]];
                } else {
                    
                    hwi CloseStack;
                    hwt::EnableCanvasButton .postPanel.fileload.f1.bApply;
                    return; 
                }
            }
            
            set shouldDraw 1;
            
            
            if { !$id } {
            
                # Removed the tk message box and used the message log to display the error
                # condition (Defect D54725) 
                ::hw::PostMessage "Reader: $modelReader.\nError loading model.";
                ::hw::ShowMessageLog true;

                set modelReader "";
                hwi CloseStack;
                hwt::EnableCanvasButton .postPanel.fileload.f1.bApply;
                return;
            } else {
            
                #memorize the model reader filter
                SetReaderFilter model $modelName;
                p$t GetModelHandle mo$t $id
                set modelReader [mo$t GetReaderName];
                mo$t ReleaseHandle
                
                # Call the utility "Create Component Groups By Dimension" at the end of the apply procedure
                # Many users want this functionality. Refer to [RFE 8967]
                catch {::post::CreateGroupsByDimension part true}
            }
        }
        
        set id [p$t GetActiveModel];     
        
        set ret 0;
        set loadStateResult 1;

        if { $loadResult == "normal" && $id > 0 } {
            p$t GetModelHandle m$t $id;

            if { [::post::HasResultFileChanged $resultName] } {
                ::post::UpdateResultFileRefs $resultName
                
                # Result file time stamp management. This code is needed if we have multiple windows
                # and if we try to reload model& result
                if { [m$t GetResultFileName] == ""} {
                    set loadStateResult [set ret [m$t SetResult $resultName]];
                }                
                
            } else {
                set loadStateResult [set ret [m$t SetResult $resultName]];
            }
            
            set shouldDraw 1;
        }
        if { $ret != 0 } {

            # If we could not find a reader to match the file extension?
            # popup the dialog for user to pick a valid reader.
        
            set allReaders [lsort -ascii [pmgr$t GetResultReaderList]];

            # allow user to choose a reader.
            ShowReadersDialog result $allReaders;
            variable selectionMade;
    
            if { $selectionMade == 0 } {
                hwi CloseStack;
                hwt::EnableCanvasButton .postPanel.fileload.f1.bApply;
                
            } else {
                
                set loadStateResult [set ret [m$t SetResult $resultName $resultReader]];
                
                if { $ret != 0 } {
            
                    # Removed the tk message box and used the message log to display the error
                    # condition (Defect D54725)            
                    ::hw::PostMessage "Reader: $resultReader.\nNo results found.";
                    ::hw::ShowMessageLog true;
                    hwi CloseStack;
                    hwt::EnableCanvasButton .postPanel.fileload.f1.bApply;
                   
                } else {
            
                    #memorize the model reader filter
                    SetReaderFilter result $resultName
                    set resultReader [m$t GetResultReaderName];
                }
            }
  
        } else {
        
            if { $loadStateResult == 0 && $ret == 0 } {
                #memorize the model reader filter
                SetReaderFilter result $resultName
                set resultReader [m$t GetResultReaderName];
            }
        } 
        
        
        if { $shouldDraw } {
            
            ::post::Draw $overlay;

            # update the status bar
            catch { ::hw::UpdateStatusBar; }
        }
        
        hwi CloseStack;
        
        # enable and unckeck the overlay option after loading the model
        .postPanel.fileload.f1.cbOverlay configure -state normal;
        set overlay 0;
        
        hwt::EnableCanvasButton .postPanel.fileload.f1.bApply;        
       

        # write last loaded files to registry 
        if { $loadStateModel > 0 } {

            if { $loadResult == "normal" && $loadStateResult==0 } {
                WriteFilePathToRegistry "$regPath$regModelVar" $modelName;
                WriteFilePathToRegistry "$regPath$regResultVar" $resultName;
                
                
            } elseif { $loadResult != "normal" } {
                WriteFilePathToRegistry "$regPath$regModelVar" $modelName;
                WriteFilePathToRegistry "$regPath$regResultVar" "";
            }
            
            # write the model/result readers used.
            
            WriteToRegistry "$regPath$regModelReaderVar" $modelReader;
        }
        
        WriteToRegistry "FILE_PANEL_CBSTATE" "$loadModel $loadResult"

        set modelReader "";
        set resultReader "";
        
        #Begin of Calculation of % Thinning for solids - tkn
        if {$::post::panel_fileload::rm_curr_template == "Advanced"} {
          hwi OpenStack
          hwi GetSessionHandle session$t
          set path [session$t GetSystemVariable ALTAIR_HOME]
          set filepath [file join $path utility hyperform thinning_solids thinning.tcl]
          catch {hwt::SourceFile $filepath}
          hwi CloseStack
        }
        #End of Calculation of % Thinning for solids - tkn
    }