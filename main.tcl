##############################################################################
#
# Copyright (C) 2021 aska http://www.vtcl.org
#
# Description file for Starkit/Starpack
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
#
##############################################################################

package require starkit
starkit::startup

proc vTcl:initVTclBinary {} {
    global vTcl
    global auto_path
    global tcl_platform
    
    set vTcl(DEV) 1
    
    if {[string tolower $tcl_platform(platform)] == "windows"} {
        encoding system cp936
        lappend auto_path [file join $starkit::topdir bin windows]
    }
    
    if {[string tolower $tcl_platform(platform)] == "unix"} {
        #ttk::style theme use clam
        lappend auto_path [file join $starkit::topdir bin linux]
    }
}

vTcl:initVTclBinary
source [file join $starkit::topdir vtcl.tcl]

