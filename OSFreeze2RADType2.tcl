#
# log:
#   - *createmark comp 1 $id ==> *createmark comp 1 "by id only" $id。名前が数字のときに、名前で選択してしまうのを防ぐ
#
namespace eval OSFreeze2RADType2 {
#  variable file entity2dresp.fem
#  variable rtype stress
#  variable ptype elem
#  variable atta svm
#  variable entity elem
}

proc OSFreeze2RADType2::main args {
  set altairhome [hm_info -appinfo ALTAIR_HOME]
  set currenttemplate [hm_info templatefilename];

  *createmark group 1 all
  foreach groupid [hm_getmark group 1] {

    # delete non-freeze contact and get serchdis
    *templatefileset "[hm_info -appinfo SPECIFIEDPATH TEMPLATES_DIR]/feoutput/optistruct/optistruct";
    set srchdis [hm_getentityvalue groups $groupid \$CONTACT_SRCHDIS 0]
    *templatefileset $currenttemplate;
    

    # Get group name
    set InterName [hm_entityinfo name group $groupid]
  
    # Get master surface and slave one.
    hm_getreferencedentities group  $groupid 7 1 0 0 -byid
    set MasterCsurf [lindex [hm_getmark contactsurf 1] 0]
    set SlaveCsurf [lindex [hm_getmark contactsurf 1] 1]
  
    # Get master component
    hm_getreferencedentities contactsurf $MasterCsurf 7 1 0 0 -byid
    set MasterElem [lindex [hm_getmark elem 1] 0]
    hm_getcrossreferencedentities elem $MasterElem 7 1 0 0 -byid
    set MasterComp [hm_getmark comp 1]
  
    # Get slave component
    hm_getreferencedentities contactsurf $SlaveCsurf 7 1 0 0 -byid
    *findmark elem 1 1 1 node 1
  
    # make slave /GRNOD
    *entitysetcreate "slave-$groupid" nodes 1
    *createmark sets 2 -1 
    *dictionaryload sets 2 "$altairhome/templates/feoutput/radioss/radioss120.blk" "GRNOD" 
    *attributeupdateint sets 1 7951 20 2 0 1)
    *attributeupdateint sets 1 7041 20 2 0 0)
    *attributeupdateint sets 1 810 20 2 0 0)
    *attributeupdateint sets 1 7950 20 2 0 0)
  
    # make master /SURF/PART/EXT
    *createmark comp 1 $MasterComp
    *entitysetcreate "Master-$groupid" components 1 
    *createmark sets 2  -1
    *dictionaryload sets 2 "$altairhome/templates/feoutput/radioss/radioss120.blk" "SURF_EXT"
    *attributeupdateint sets 2 7951 20 2 0 1 
    *attributeupdateint sets 2 7950 20 2 0 0 
  
    # delete current group
    *createmark group 1 $groupid
    *deletemark group 1
  
    # make /INTER/TYPE2
    *interfacecreate "$InterName" 2 2 11 
    *createmark groups 2  "$InterName"
    set gid [hm_getmark group 2]
    *dictionaryload groups 2 "$altairhome/templates/feoutput/radioss/radioss120.blk" "TYPE2" 
    *attributeupdateint groups $gid 7951 20 2 0 1 
    *attributeupdateint groups $gid 7950 20 2 0 0 
    *attributeupdateint groups $gid 7018 20 0 0 0 
    *attributeupdateint groups $gid 5169 20 0 0 0 
    *attributeupdateint groups $gid 8041 20 0 0 0 
    *attributeupdateint groups $gid 8042 20 0 0 2 
    *attributeupdateint groups $gid 4012 20 0 0 0 
    *attributeupdatedouble groups $gid 8043 20 0 0 0 
    *interfacedefinition "$InterName" 1 "sets" 
    *createmark sets 1  "Master-$groupid"
    *interfacesets "$InterName" 1 1 
    *interfacedefinition "$InterName" 0 "sets" 
    *createmark sets 2  "slave-$groupid"
    *interfacesets "$InterName" 0 2 
    # ignore = 1, Sportflag=25
    *setvalue groups id=$gid STATUS=1 7018=1 
    *setvalue groups id=$gid STATUS=1 5169=25 
    *setvalue groups id=$gid STATUS=1 8043=$srchdis

  }

}


OSFreeze2RADType2::main
