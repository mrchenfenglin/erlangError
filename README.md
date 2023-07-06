# erlangError
Current system information picture of this bug.         ----> bug_system_top_info.png 
#
Current report of this bug.                             ----> report_bug_high_load.txt
#

Normal operating system information.                    ----> normal_system_top_info.png
#
Report of normal operation.                             ----> report_nomarl_low_load.txt
#

code                                                    ----> processTest.erl
#
run：
root$ erl -jperf
1>processTest:testProcess(10000).
