This README explains all the steps required to replicate the work done for the article, "A meta-analysis of the MIREX Structural Segmentation task."

All of the contents of this repository are released under the MIT license (shown below).



===== HOW TO REPRODUCE THE PAPER =====

1: You will need Ruby and Matlab and a connection to the Internet.

2: You will need to download a version of the Structural Analysis Evaluation project, also hosted on SoundSoftware. You can do so here:
<https://code.soundsoftware.ac.uk/projects/structural_analysis_evaluation/repository>

3: You will need to edit some of the Ruby and Matlab files you have downloaded, in order to point the program to the desired folders:
   >> In "1-get_mirex_estimates.rb", set the path to download all the data
NOTE: We recommend making this the "./mirex_data" path, since some of the data is already there!
   >> In "2-generate_smith2013_ismir", set the exact same path
   >> In "2-generate_smith2013_ismir", set the path for the "structural analysis evaluation" repository

4. Run the Ruby script "1-get_mirex_estimates.rb" and wait a while for all the data to download.

5. Unzip all the folders that you obtained.
	Note: in this version, one of the repositories, the Ewald Peiszer repository, is included already as a zip file ("ep_groundtruth_txt.zip"). Please move this to 

6. Run the Matlab script "2-generate_smith2013_ismir" and wait for all the data to be assembled, and for the figures to be generated.

7. You're done! Hey, that wasn't so bad.



===== The MIT License (MIT) =====

Copyright (c) 2013 Jordan B. L. Smith

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

The software is provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or the use or other dealings in the software.