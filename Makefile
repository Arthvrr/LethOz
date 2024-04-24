OZC="/Applications/Mozart2.app/Contents/Resources/bin/ozc"
# For those you want to modify the library
LethOzLib.ozf: project_library.oz
	$(OZC) -o $@ -c $<
