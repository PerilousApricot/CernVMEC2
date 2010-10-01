#!/bin/bash

if  [ "$CMS_CERNVM_PROXY_HOST" = "NOPROXY" ]; then
    awk '/INSERTEC2HEADNODE/ {} !/INSERTEC2HEADNODE/ {print $0}' site-local-config.xml.BASE > site-local-config.xml
else
    # split up (possibly multiple) proxies
    arr=$(echo $CMS_CERNVM_PROXY_HOST | tr ";" "\n")
	output="\n"
	for x in $arr
	do
        output="$output\n<proxy url=\\\"$x\\\" />"
	done
	echo "output is $output"
    awk "/INSERTEC2HEADNODE/ {print \"$output\" } 
        !/INSERTEC2HEADNODE/ {print \$0}" site-local-config.xml.BASE > site-local-config.xml
fi
