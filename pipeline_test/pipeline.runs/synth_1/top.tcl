# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir D:/vivado_project/pipeline_test/pipeline/pipeline.cache/wt [current_project]
set_property parent.project_path D:/vivado_project/pipeline_test/pipeline/pipeline.xpr [current_project]
set_property XPM_LIBRARIES XPM_MEMORY [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo d:/vivado_project/pipeline_test/pipeline/pipeline.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/I_mem.coe
add_files D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/D_mem.coe
read_verilog {
  D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/pipelinecpu/PC.v
  D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/pipelinecpu/RF.v
  D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/pipelinecpu/ctrl_encode_def.v
  D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/pipelinecpu/pipeline.v
  D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/pipelinecpu/EXT.v
  D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/pipelinecpu/ctrl.v
  D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/pipelinecpu/alu.v
}
set_property file_type "Verilog Header" [get_files D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/pipelinecpu/PC.v]
set_property file_type "Verilog Header" [get_files D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/pipelinecpu/RF.v]
set_property file_type "Verilog Header" [get_files D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/pipelinecpu/ctrl_encode_def.v]
set_property file_type "Verilog Header" [get_files D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/pipelinecpu/pipeline.v]
set_property file_type "Verilog Header" [get_files D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/pipelinecpu/EXT.v]
set_property file_type "Verilog Header" [get_files D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/pipelinecpu/ctrl.v]
set_property file_type "Verilog Header" [get_files D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/pipelinecpu/alu.v]
read_verilog -library xil_defaultlib {
  D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/IO/Counter_3_IO.v
  D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/IO/Enter.v
  D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/edf_file/MIO_BUS.V
  D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/edf_file/Multi_8CH32.v
  D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/pipelinecpu/SCPU.v
  D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/edf_file/SPIO.v
  D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/edf_file/SSeg7.v
  D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/IO/clk_div.v
  D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/edf_file/dm_controller.v
  D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/new/top.v
}
read_ip -quiet D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/ip/ROM_D/ROM_D.xci
set_property used_in_implementation false [get_files -all d:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/ip/ROM_D/ROM_D_ooc.xdc]

read_ip -quiet D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/ip/RAM_B/RAM_B.xci
set_property used_in_implementation false [get_files -all d:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/ip/RAM_B/RAM_B_ooc.xdc]

read_edif D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/edf_file/SPIO.edf
read_edif D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/edf_file/SSeg7.edf
read_edif D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/edf_file/Multi_8CH32.edf
read_edif D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/edf_file/MIO_BUS.edf
read_edif D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/sources_1/edf_file/dm_controller.edf
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/constrs_1/icf.xdc
set_property used_in_implementation false [get_files D:/vivado_project/pipeline_test/pipeline/pipeline.srcs/constrs_1/icf.xdc]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top top -part xc7a100tcsg324-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef top.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file top_utilization_synth.rpt -pb top_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
