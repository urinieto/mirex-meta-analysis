This README explains all the steps required to replicate the work done for the article, "A meta-analysis of the MIREX Structural Segmentation task."

All of the contents of this repository are released under the MIT license (shown below).



===== HOW TO REPRODUCE THE PAPER =====

1: You will need Ruby and Matlab and a connection to the Internet.

2: You will need to download a version of the Structural Analysis Evaluation project, also hosted on SoundSoftware. You can donwload it here:
<https://code.soundsoftware.ac.uk/projects/structural_analysis_evaluation/repository>

3: You will need to edit some of the Ruby and Matlab files you have downloaded, in order to point the program to the desired folders.



2. 
- Download data from MIREX website:
	- Ground truth files
	- Algorithm output
	- Reported evaluation results

File: get_mirex_estimates.rb
Instructions: set local directory for download. Download repositories, unzip, set directories. [Can I write the script to do this?]

(Pre-process this data.)

- Assemble MIREX ground truth file data in Matlab.
- Assemble MIREX algorithm output data in Matlab.
- Assemble MIREX evaluation results in Matlab.

- Download public repositories of annotations.

- Assemble public ground truth data in Matlab.

- Compute extra evaluation measures using MIREX algorithm output.

- Compute extra features of the annotations (song length, mean segment length, etc.).

- Compute correlations between all these parameters.

- Display correlation figures.

- Search for matches between MIREX and public ground truth.

- Display analysis result figure.





The MIT License (MIT)

Copyright (c) 2013 DDMAL

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.