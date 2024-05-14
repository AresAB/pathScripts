
Just some basic scripts I made when learning how to do so.

pathscan.sh: literally just 'which -a', didn't realize it existed at the time

pathorg.sh: no inputs, returns a more readable version of $PATH

pathorg2.sh: my first attempt of using flags within shell scripts. By default, it does the exact same as pathorg.sh, but it can take in 4 different flags. These flags can interact with one another, and make us of a custom 'flaghandler.sh' script to handle flag inputs (not included in this directory)
		-s | --search
			takes an input and returns each path in $PATH as a true or false depending on if the input can be found in the directory
		-f | --filter
			returns only the paths that go to real directories
		-p | --package
			takes whatever is being returned and reformats it back into the style of $PATH
		-i | --inverse
			inverses the results of any of the other flags that impact the return contents
