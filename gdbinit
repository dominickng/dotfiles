#gdb init file

#clearing screen
define cls
    shell clear
end

document cls
    Clears the screen with a simple command.
end

# stl view script
source ~/.gdb/stl-views.gdb

# other settings
set confirm off
set verbose off
# Mac 10.7 debugging
# set env MallocStackLoggingNoCompact 1

# array printing
define parray
    print *$arg0@$arg1
end

document parray
    Prints the array at <arg0> over length <arg1> items
end
