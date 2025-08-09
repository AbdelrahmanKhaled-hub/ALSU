vlib work
vlog -f src_files.list.txt +cover -covercells
vsim -voptargs=+acc work.ALSU_top -classdebug -uvmcontrol=all -cover
add wave /ALSU_top/ALSUif/*
run -all
coverage save ALSU_top.ucdb -onexit 
coverage exclude -src ALSU.sv -line 91 -code b
