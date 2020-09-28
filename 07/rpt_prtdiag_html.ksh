#!/bin/ksh

REPORT_FILE=prtdiag.txt
HTML_OUTFILE=prtdiag.html

CURR_SECT=START
PREV_SECT=START
CURR_FORMAT=NORMAL

# Print out the HTML headers.
echo "<html>
<head>
<style type="text/css">
<!-- 
table { border-collapse:collapse; border:1px solid light-gray;}
body { font-family:Arial,Tahoma,Verdana; font-size:10pt; }
td { font-family:Tahoma,Arial,Verdana; font-size:9pt; padding:2px 10px 2px 10px; border:1px solid light-gray; } 
th { font-family:Tahoma,Arial,Verdana; font-size:10pt; font-weight: bold; background-color: light-cyan; padding:2px 10px 2px 10px; border:1px solid light-gray; } 
h3 { font-family:Tahoma,Arial,Verdana; font-size:9pt; font-weight:bold; } 
h2 { font-family:Arial,Tahoma,Verdana; font-size:12pt; font-weight:bold; color:navy; padding: 0px; margin: 0px 0px 15px 0px; } 
hr { color:#69c; height: 1px; margin: 10px 0px 10px 0px; }
-->
</style>
</head>
<body>
<a name=\"Top\"></a><h1>[prodsvr1] Output of prtdiag -v</h1>"


# Process each line in the report.
#
# Here the use of the sed command is an additional tweak - it increases
# the spaces for some fields to allow the code to detect them as separate
# table cells.
cat ${REPORT_FILE} | egrep -v "^$" | sed 's/Status Set Device/Status   Set   Device/;s/in use /in use   /;s/available PCI/available   PCI/' | while read i; do
  # Check if the current line is a heading.
  if [ `echo $i | egrep "^====" | wc -l | tr -d ' '` -gt 0 ]; then
    # Extract the heading from the separators.
    HEADING=`echo $i | sed 's/=* \(.*\) =*/\1/g'`
    PREV_SECT=${CURR_SECT}
    
    HTML_LINKBACK="<p><a href=\"#Top\">Back to Top</a></p>"
    HTML_HEADING="<h2>${HEADING}</h2>"

    # Determine the new section and format.
    # By setting CURR_SECT we know which is the current section as we process each line the report.
    # By setting CURR_FORMAT we know what format to use for the current line in the report.
    case "${HEADING}" in 
      "Processor Sockets")
        CURR_SECT=PROCSOC
        CURR_FORMAT=TABLEHDR

        echo ${HTML_HEADING}
        echo "<table>"
        ;;
      "Memory Device Sockets")
        CURR_SECT=MEMDEV
        CURR_FORMAT=TABLEHDR

        # End the previous section.
        echo "</table>"
        echo ${HTML_LINKBACK}

        # Begin current section.
        echo ${HTML_HEADING}
        echo "<table>"
        ;;
      "On-Board Devices")
        CURR_SECT=ONBOARDDEV
        CURR_FORMAT=NORMAL

        # End the previous section.
        echo "</table>"
        echo ${HTML_LINKBACK}

        # Begin current section.
        echo ${HTML_HEADING}
        ;;
      "Upgradeable Slots")
        CURR_SECT=UPGSLOT
        CURR_FORMAT=TABLEHDR

        # End the previous section.
        echo ${HTML_LINKBACK}

        # Begin current section.
        echo ${HTML_HEADING}
        echo "<table>"
        ;;
      esac
  else
    # Parsing rules for non-headings.
    if [ "${CURR_FORMAT}" = "NORMAL" ]; then
      # Print the HTML for a normal paragraph.
      echo "<p>$i</p>"
    elif [ `echo $i | egrep "^--" | wc -l | tr -d ' '` -gt 0 ]; then
      CURR_FORMAT=TABLE
    elif [ "${CURR_FORMAT}" = "TABLEHDR" ]; then
      # Print the HTML for table header.
      echo "<tr><th>$i</th></tr>" | sed 's~   *~</th><th>~g'
    elif [ "${CURR_FORMAT}" = "TABLE" ]; then
      # Print the HTML for a table.
      echo "<tr><td>$i</td></tr>" | sed 's~   *~</td><td>~g'
    fi
  fi
done

# Print out the footers.
echo "</table>"
echo "<p><a href=\"#Top\">Back to Top</a></p>"
echo "</body>"
echo "</html>"
