

import sys, os
import numpy as np
import time

lib_path = './../Sources/Utilities'

sys.path.append(lib_path) #src directory

from messaging.print_functions import ProgressBar

progbar = ProgressBar(bar_length=20, bar_fill='o', elapsed_time=True)

array = np.arange(0, 11, 1)

for i in array:
    progbar.update_progress(i/float(len(array)))
    time.sleep(0.5)

print ("Total elapsed time: ", progbar.get_elapsed_time())