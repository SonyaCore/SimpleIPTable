# SimpleIPTable
**IPTABLE Service (SimpleIPTable)**

example: 
> sudo iptables.sh -b -a 5000 -a 443


Usage:


**Policy:**

[ -default | --defaultiptable ]&emsp;&emsp;&emsp;&emsp;&emsp;Add Default ports Without Blocking all policy

[ -b | --blockall ]&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Block All Policy and add Default Ports

[  -f | --flushall ]&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&ensp;Flush All Polciy and set All Policy to ACCEPT

[ -finput | --flushinputchain]&emsp;&emsp;&emsp;&emsp;&emsp;Flush INPUT Chain

[ -foutput | --flushoutputchain]&emsp;&emsp;&emsp;&nbsp;&ensp;Flush OUTPUT Chain


**Filter:**

[-a | --accept]&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&ensp;&ensp;&nbsp;&nbsp;Add Port with ACCEPT target

[-d | --delaccept]&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;Delete Port with ACCEPT target

[-afilter | --addportfilter]&emsp;&emsp;&ensp;&emsp;&emsp;&emsp;&ensp;&ensp;Add Port With DROP target

[-dfilter | --delportfilter]&emsp;&emsp;&ensp;&emsp;&emsp;&emsp;&ensp;&ensp;&nbsp;Delete Port With DROP target

[-s | --save]&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&ensp;&nbsp;&ensp;&nbsp;Save Rules for Restoring on Startup

