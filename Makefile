all:
	true

upload:
	scp gcode/*.ngc cnc:/home/base/adluc/busunit2

clean:
	# Removing backup files
	find . \( -name "*.s#*" -o -name "*.b#*" -o -name "*.job" \) -delete

clean_gerber:
	# Removing gerber files
	find . \( -name "*.g*" -o -name "*.dr*" \) -delete
