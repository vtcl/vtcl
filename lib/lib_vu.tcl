##############################################################################
#
# Copyright (C) 2007 Tristan  http://www.tcltk.cn
#
# Description file for Tile Widget
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

catch { package require vu }

proc vTcl:lib_vu:init {} {
    global vTcl

    lappend vTcl(libNames) "Visual Tcl VU Widget Library"

    return 1
}

proc vTcl:widget:lib:lib_vu {args} {
    global vTcl

    set order {
    Dial
    Pie
    Bargraph
    }

    vTcl:lib:add_widgets_to_toolbar $order vu "VU widgets"

    append vTcl(head,vu,importheader) {
    package require vu
    }
}
