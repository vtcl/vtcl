#!/bin/sh
# the next line restarts using wish\
exec wish "$0" "$@" 

if {![info exists vTcl(sourcing)]} {

    package require Tk
    switch $tcl_platform(platform) {
	windows {
            option add *Button.padY 0
	}
	default {
            option add *Scrollbar.width 10
            option add *Scrollbar.highlightThickness 0
            option add *Scrollbar.elementBorderWidth 2
            option add *Scrollbar.borderWidth 2
	}
    }
    
}

#############################################################################
# Visual Tcl v1.60 Project
#


#################################
# VTCL LIBRARY PROCEDURES
#

if {![info exists vTcl(sourcing)]} {
#############################################################################
## Library Procedure:  Window

proc ::Window {args} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    global vTcl
    set cmd     [lindex $args 0]
    set name    [lindex $args 1]
    set newname [lindex $args 2]
    set rest    [lrange $args 3 end]
    if {$name == "" || $cmd == ""} { return }
    if {$newname == ""} { set newname $name }
    if {$name == "."} { wm withdraw $name; return }
    set exists [winfo exists $newname]
    switch $cmd {
        show {
            if {$exists} {
                wm deiconify $newname
            } elseif {[info procs vTclWindow$name] != ""} {
                eval "vTclWindow$name $newname $rest"
            }
            if {[winfo exists $newname] && [wm state $newname] == "normal"} {
                vTcl:FireEvent $newname <<Show>>
            }
        }
        hide    {
            if {$exists} {
                wm withdraw $newname
                vTcl:FireEvent $newname <<Hide>>
                return}
        }
        iconify { if $exists {wm iconify $newname; return} }
        destroy { if $exists {destroy $newname; return} }
    }
}
#############################################################################
## Library Procedure:  vTcl:DefineAlias

proc ::vTcl:DefineAlias {target alias widgetProc top_or_alias cmdalias} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    global widget
    set widget($alias) $target
    set widget(rev,$target) $alias
    if {$cmdalias} {
        interp alias {} $alias {} $widgetProc $target
    }
    if {$top_or_alias != ""} {
        set widget($top_or_alias,$alias) $target
        if {$cmdalias} {
            interp alias {} $top_or_alias.$alias {} $widgetProc $target
        }
    }
}
#############################################################################
## Library Procedure:  vTcl:DoCmdOption

proc ::vTcl:DoCmdOption {target cmd} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    ## menus are considered toplevel windows
    set parent $target
    while {[winfo class $parent] == "Menu"} {
        set parent [winfo parent $parent]
    }

    regsub -all {\%widget} $cmd $target cmd
    regsub -all {\%top} $cmd [winfo toplevel $parent] cmd

    uplevel #0 [list eval $cmd]
}
#############################################################################
## Library Procedure:  vTcl:FireEvent

proc ::vTcl:FireEvent {target event {params {}}} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    ## The window may have disappeared
    if {![winfo exists $target]} return
    ## Process each binding tag, looking for the event
    foreach bindtag [bindtags $target] {
        set tag_events [bind $bindtag]
        set stop_processing 0
        foreach tag_event $tag_events {
            if {$tag_event == $event} {
                set bind_code [bind $bindtag $tag_event]
                foreach rep "\{%W $target\} $params" {
                    regsub -all [lindex $rep 0] $bind_code [lindex $rep 1] bind_code
                }
                set result [catch {uplevel #0 $bind_code} errortext]
                if {$result == 3} {
                    ## break exception, stop processing
                    set stop_processing 1
                } elseif {$result != 0} {
                    bgerror $errortext
                }
                break
            }
        }
        if {$stop_processing} {break}
    }
}
#############################################################################
## Library Procedure:  vTcl:Toplevel:WidgetProc

proc ::vTcl:Toplevel:WidgetProc {w args} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    if {[llength $args] == 0} {
        ## If no arguments, returns the path the alias points to
        return $w
    }
    set command [lindex $args 0]
    set args [lrange $args 1 end]
    switch -- $command {
        "setvar" {
            set varname [lindex $args 0]
            set value [lindex $args 1]
            if {$value == ""} {
                return [set ::${w}::${varname}]
            } else {
                return [set ::${w}::${varname} $value]
            }
        }
        "hide" - "Hide" - "show" - "Show" {
            Window [string tolower $command] $w
        }
        "ShowModal" {
            Window show $w
            raise $w
            grab $w
            tkwait window $w
            grab release $w
        }
        default {
            uplevel $w $command $args
        }
    }
}
#############################################################################
## Library Procedure:  vTcl:WidgetProc

proc ::vTcl:WidgetProc {w args} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    if {[llength $args] == 0} {
        ## If no arguments, returns the path the alias points to
        return $w
    }
    ## The first argument is a switch, they must be doing a configure.
    if {[string index $args 0] == "-"} {
        set command configure
        ## There's only one argument, must be a cget.
        if {[llength $args] == 1} {
            set command cget
        }
    } else {
        set command [lindex $args 0]
        set args [lrange $args 1 end]
    }
    uplevel $w $command $args
}
#############################################################################
## Library Procedure:  vTcl:toplevel

proc ::vTcl:toplevel {args} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    uplevel #0 eval toplevel $args
    set target [lindex $args 0]
    namespace eval ::$target {}
}
}


if {[info exists vTcl(sourcing)]} {

proc vTcl:project:info {} {
    set base .top72
    namespace eval ::widgets::$base {
        set set,origin 1
        set set,size 0
        set runvisible 1
    }
    namespace eval ::widgets::$base.lab74 {
        array set save {-anchor 1 -background 1 -justify 1 -text 1}
    }
    namespace eval ::widgets::$base.spi75 {
        array set save {-increment 1 -textvariable 1 -to 1}
    }
    namespace eval ::widgets::$base.fra76 {
        array set save {-borderwidth 1 -height 1 -width 1}
    }
    set site_3_0 $base.fra76
    namespace eval ::widgets::$site_3_0.lab78 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$site_3_0.ent79 {
        array set save {-background 1 -textvariable 1}
    }
    namespace eval ::widgets::$site_3_0.but80 {
        array set save {-command 1 -pady 1 -text 1}
    }
    namespace eval ::widgets::$site_3_0.lab81 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$site_3_0.ent82 {
        array set save {-background 1 -textvariable 1}
    }
    namespace eval ::widgets::$site_3_0.but83 {
        array set save {-command 1 -pady 1 -text 1}
    }
    namespace eval ::widgets::$site_3_0.lab84 {
        array set save {-justify 1 -text 1}
    }
    namespace eval ::widgets::$site_3_0.ent85 {
        array set save {-background 1 -textvariable 1}
    }
    namespace eval ::widgets::$site_3_0.but86 {
        array set save {-command 1 -pady 1 -text 1}
    }
    namespace eval ::widgets_bindings {
        set tagslist _TopLevel
    }
    namespace eval ::vTcl::modules::main {
        set procs {
            init
            main
        }
        set compounds {
        }
    }
}
}

#################################
# USER DEFINED PROCEDURES
#
#############################################################################
## Procedure:  main

proc ::main {argc argv} {
# the initial value
Toplevel1 setvar spinValue 1

Toplevel1 setvar from      0
Toplevel1 setvar to        100
Toplevel1 setvar increment 1
}

#############################################################################
## Initialization Procedure:  init

proc ::init {argc argv} {}

init $argc $argv

#################################
# VTCL GENERATED GUI PROCEDURES
#

proc vTclWindow. {base} {
    if {$base == ""} {
        set base .
    }
    ###################
    # CREATING WIDGETS
    ###################
    wm focusmodel $top passive
    wm geometry $top 200x200+66+75; update
    wm maxsize $top 1284 1006
    wm minsize $top 111 1
    wm overrideredirect $top 0
    wm resizable $top 1 1
    wm withdraw $top
    wm title $top "vtcl"
    bindtags $top "$top Vtcl all"
    vTcl:FireEvent $top <<Create>>
    wm protocol $top WM_DELETE_WINDOW "vTcl:FireEvent $top <<DeleteWindow>>"

    ###################
    # SETTING GEOMETRY
    ###################

    vTcl:FireEvent $base <<Ready>>
}

proc vTclWindow.top72 {base} {
    if {$base == ""} {
        set base .top72
    }
    if {[winfo exists $base]} {
        wm deiconify $base; return
    }
    set top $base
    ###################
    # CREATING WIDGETS
    ###################
    vTcl:toplevel $top -class Toplevel
    wm focusmodel $top passive
    wm geometry $top +294+428; update
    wm maxsize $top 1284 1006
    wm minsize $top 111 1
    wm overrideredirect $top 0
    wm resizable $top 1 1
    wm deiconify $top
    wm title $top "Spinbox"
    vTcl:DefineAlias "$top" "Toplevel1" vTcl:Toplevel:WidgetProc "" 1
    bindtags $top "$top Toplevel all _TopLevel"
    vTcl:FireEvent $top <<Create>>
    wm protocol $top WM_DELETE_WINDOW "vTcl:FireEvent $top <<DeleteWindow>>"

    label $top.lab74 \
        -anchor w -background #ececebf98e27 -justify left \
        -text {Spinboxes allow to set a number either by typing it in an entry box,
or by using up/down arrows to adjust the value.} 
    vTcl:DefineAlias "$top.lab74" "Label1" vTcl:WidgetProc "Toplevel1" 1
    spinbox $top.spi75 \
        -increment 1.0 -textvariable "$top\::spinValue" -to 100.0 
    vTcl:DefineAlias "$top.spi75" "Spinbox1" vTcl:WidgetProc "Toplevel1" 1
    frame $top.fra76 \
        -borderwidth 2 -height 75 -width 125 
    vTcl:DefineAlias "$top.fra76" "Frame1" vTcl:WidgetProc "Toplevel1" 1
    set site_3_0 $top.fra76
    label $site_3_0.lab78 \
        -text {The "-from" option is the minimum value:} 
    vTcl:DefineAlias "$site_3_0.lab78" "Label2" vTcl:WidgetProc "Toplevel1" 1
    entry $site_3_0.ent79 \
        -background white -textvariable "$top\::from" 
    vTcl:DefineAlias "$site_3_0.ent79" "Entry1" vTcl:WidgetProc "Toplevel1" 1
    button $site_3_0.but80 \
        -command {Spinbox1 configure -from [Toplevel1 setvar from]} -pady 0 \
        -text Set 
    vTcl:DefineAlias "$site_3_0.but80" "Button1" vTcl:WidgetProc "Toplevel1" 1
    label $site_3_0.lab81 \
        -text {The "-to" option is the maximum value:} 
    vTcl:DefineAlias "$site_3_0.lab81" "Label3" vTcl:WidgetProc "Toplevel1" 1
    entry $site_3_0.ent82 \
        -background white -textvariable "$top\::to" 
    vTcl:DefineAlias "$site_3_0.ent82" "Entry2" vTcl:WidgetProc "Toplevel1" 1
    button $site_3_0.but83 \
        -command {Spinbox1 configure -to [Toplevel1 setvar to]} -pady 0 \
        -text Set 
    vTcl:DefineAlias "$site_3_0.but83" "Button2" vTcl:WidgetProc "Toplevel1" 1
    label $site_3_0.lab84 \
        -justify right \
        -text {The "-increment" option is how much the value changes
when you click the up or down arrow:} 
    vTcl:DefineAlias "$site_3_0.lab84" "Label4" vTcl:WidgetProc "Toplevel1" 1
    entry $site_3_0.ent85 \
        -background white -textvariable "$top\::increment" 
    vTcl:DefineAlias "$site_3_0.ent85" "Entry3" vTcl:WidgetProc "Toplevel1" 1
    button $site_3_0.but86 \
        -command {Spinbox1 configure -increment [Toplevel1 setvar increment]} \
        -pady 0 -text Set 
    vTcl:DefineAlias "$site_3_0.but86" "Button3" vTcl:WidgetProc "Toplevel1" 1
    grid $site_3_0.lab78 \
        -in $site_3_0 -column 0 -row 0 -columnspan 1 -rowspan 1 -padx 5 \
        -pady 5 -sticky e 
    grid $site_3_0.ent79 \
        -in $site_3_0 -column 1 -row 0 -columnspan 1 -rowspan 1 
    grid $site_3_0.but80 \
        -in $site_3_0 -column 2 -row 0 -columnspan 1 -rowspan 1 -padx 5 \
        -pady 5 
    grid $site_3_0.lab81 \
        -in $site_3_0 -column 0 -row 1 -columnspan 1 -rowspan 1 -padx 5 \
        -pady 5 -sticky e 
    grid $site_3_0.ent82 \
        -in $site_3_0 -column 1 -row 1 -columnspan 1 -rowspan 1 
    grid $site_3_0.but83 \
        -in $site_3_0 -column 2 -row 1 -columnspan 1 -rowspan 1 -padx 5 \
        -pady 5 
    grid $site_3_0.lab84 \
        -in $site_3_0 -column 0 -row 2 -columnspan 1 -rowspan 1 -padx 5 \
        -pady 5 -sticky e 
    grid $site_3_0.ent85 \
        -in $site_3_0 -column 1 -row 2 -columnspan 1 -rowspan 1 
    grid $site_3_0.but86 \
        -in $site_3_0 -column 2 -row 2 -columnspan 1 -rowspan 1 -padx 5 \
        -pady 5 
    ###################
    # SETTING GEOMETRY
    ###################
    pack $top.lab74 \
        -in $top -anchor center -expand 0 -fill x -padx 5 -pady 5 -side top 
    pack $top.spi75 \
        -in $top -anchor center -expand 0 -fill none -padx 5 -pady 5 \
        -side top 
    pack $top.fra76 \
        -in $top -anchor center -expand 0 -fill both -side top 

    vTcl:FireEvent $base <<Ready>>
}

#############################################################################
## Binding tag:  _TopLevel

bind "_TopLevel" <<Create>> {
    if {![info exists _topcount]} {set _topcount 0}; incr _topcount
}
bind "_TopLevel" <<DeleteWindow>> {
    destroy %W; if {$_topcount == 0} {exit}
}
bind "_TopLevel" <Destroy> {
    if {[winfo toplevel %W] == "%W"} {incr _topcount -1}
}

Window show .
Window show .top72

main $argc $argv
