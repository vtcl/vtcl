##############################################################################
#
# Copyright (C) 2007 Tristan  http://www.tcltk.cn
#
# Description file for TkVideo Widget
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

catch { package require tkvideo }

proc vTcl:lib_tkvideo:init {} {
    global vTcl

    lappend vTcl(libNames) "Visual Tcl TkVideo Widget Library"

    return 1
}

proc vTcl:widget:lib:lib_tkvideo {args} {
    global vTcl

    set order {
    Video
    }

    vTcl:lib:add_widgets_to_toolbar $order tkvideo "TkVideo widget"

    append vTcl(head,tkvideo,importheader) {
    package require tkvideo
    }
}
