##############################################################################
# $Id: toolbar.tcl,v 1.17 2005/12/05 06:53:15 kenparkerjr Exp $
#
# toolbar.tcl - widget toolbar
#
# Copyright (C) 1996-1998 Stewart Allen
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

##############################################################################
#
proc vTcl:toolbar_create {args} {
    global vTcl
    set base .vTcl.toolbar
    if {[winfo exists $base]} {return}
    vTcl:toplevel $base -width 237 -height 110 -class vTcl
    wm transient $base .vTcl
    wm withdraw $base
    wm title $base "Widget Toolbar"
    wm geometry $base +110+110
    wm minsize $base 237 40
    wm overrideredirect $base 0
    catch {wm geometry .vTcl.toolbar $vTcl(geometry,.vTcl.toolbar)}
    wm deiconify $base
    update
    wm protocol .vTcl.toolbar WM_DELETE_WINDOW {
        vTcl:error "You cannot remove the toolbar"
    }
    
    set sbands [kpwidgets::SBands .vTcl.toolbar.sbands]
    
    ttk::frame $base.tframe
    
    image create photo pointer \
        -file [file join $vTcl(VTCL_HOME) images icon_pointer.gif]
    ttk::button $base.tframe.b -image pointer -command "
    	$base.tframe.b configure -relief flat
    	vTcl:raise_last_button $base.tframe.b
        vTcl:rebind_button_1
        vTcl:status Status
    	set vTcl(x,lastButton) $base.tframe.b
    "
    
    pack $base.tframe -side top -fill x 
    
    lappend vTcl(tool,list) $base.tframe.b
    set vTcl(x,lastButton) $base.tframe.b
    
    pack $base.tframe.b -side left
    ttk::label $base.tframe.l -text "Pointer" 
    pack $base.tframe.l -side left
    pack $sbands -fill both -expand yes -side bottom

}

proc vTcl:toolbar_add {band_name class name image cmd_add } {
    global vTcl
    if {![winfo exists $.vTcl.toolbar]} { vTcl:toolbar_create }
    
    set base [.vTcl.toolbar.sbands childsite $band_name]
    set f [vTcl:new_widget_name tb $base]
    ensureImage $image
    ttk::frame $f
    pack $f -side top -fill x
    button $f.b -bd 1 -image $image -padx 0 -pady 0 -highlightthickness 0

    bind $f.b <ButtonRelease-1> \
       "vTcl:new_widget \$vTcl(pr,autoplace) $class $f.b \"$cmd_add\""

    bind $f.b <Shift-ButtonRelease-1> \
        "vTcl:new_widget 1 $class $f.b \"$cmd_add\""

    vTcl:set_balloon $f.b $name
    lappend vTcl(tool,list) $f.b
    pack $f.b -side left
    ttk::label $f.l -text $class
    vTcl:set_balloon $f.l $name
    pack $f.l -side left
}

namespace eval ::vTcl {
    proc toolbar_header { band_name title } {
    	
        if {![winfo exists $.vTcl.toolbar]} { vTcl:toolbar_create }
        set base .vTcl.toolbar.sbands
        $base new_frame $band_name $title 
    }
}

proc vTclWindow.vTcl.toolbar {args} {
    vTcl:toolbar_reflow
}

proc vTcl:toolbar_reflow {{base .vTcl.toolbar}} {
    global vTcl
    set existed [winfo exists $base]
    if {!$existed} { vTcl:toolbar_create }
    wm resizable $base 1 1
    update

    vTcl:setup_vTcl:bind $base
}


