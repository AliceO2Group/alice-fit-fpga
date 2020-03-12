namespace eval fit {
    proc update_ip_properties {} {
	foreach p [get_ips] {
	    puts "INFO: updating ./ipcore_properties/${p}.txt"
	    report_property -quiet -regexp -file [file normalize "./ipcore_properties/${p}.txt"] [get_ips $p] "(CONFIG.*|IPDEF)"
	}
    }

    ## makes ipcores with properties taken from txt files in the directory "./ipcore_properties"
    proc make_ipcores {targetDir} {
	proc generate_ipcore {targetDir ps} {
	    set module_name [dict get $ps "CONFIG.Component_Name"]
	    set ps [dict remove $ps CONFIG.Component_Name]

	    file mkdir ${targetDir}
	    set module_xcix "${targetDir}/${module_name}.xcix"
	    file delete -force ${module_xcix}

	    set module_xci "${targetDir}/${module_name}/${module_name}.xci"
	    set ipdef [split [dict get $ps "IPDEF"] ":"]
	    create_ip \
		-vendor  [lindex $ipdef 0] \
		-library [lindex $ipdef 1] \
		-name    [lindex $ipdef 2] \
		-module_name ${module_name} \
		-dir ${targetDir}
	    set ps [dict remove $ps IPDEF]

	    set_property -dict $ps [get_ips ${module_name}]

	    generate_target {instantiation_template} [get_files ${module_xci}]
	    generate_target all [get_files  ${module_xci}]
	    catch {
		config_ip_cache -export [get_ips -all ${module_name}]
	    }
	    export_ip_user_files -of_objects [get_files ${module_xci}] -no_script -sync -force -quiet
	}

	proc ipcore_property_file_to_dict fn {
	    set fp [open $fn]
	    set headers {Property Type Read-only Value}
	    array set idx {}
	    foreach h $headers {
		set idx($h) -1
	    }
	    set ps [dict create]
	    while {-1 != [gets $fp line]} {
		##puts "The current line is '$line'."
		if {$idx(Property) == -1} {
		    foreach h $headers {
			set idx($h) [string first $h $line]
		    }
		} else {
		    set key [string trim [string range $line $idx(Property) \
					      [expr $idx(Type) - 1]]]
		    set val [string trim [string range $line $idx(Value) \
					      [expr [string length $line] - 1]]]
		    dict set ps $key $val
		}
	    }
	    close $fp
	    return $ps
	}

	foreach f [glob ipcore_properties/*.txt] {
	    puts "INFO: generating IP core from ${f}"
	    generate_ipcore ${targetDir} [ipcore_property_file_to_dict $f]
	}
    }
}
