This README explains all the steps required to replicate the work done for the article, "A meta-analysis of the MIREX Structural Segmentation task."

All of the contents of this repository are released under the MIT license (shown below).



## How to Reproduce the Paper

1. You will need Ruby and Matlab and a connection to the Internet.

2. Download a version of my Structural Analysis Evaluation code: <https://github.com/jblsmith/structural_analysis_evaluation>

3. Edit the directory locations of the Ruby and Matlab files you have downloaded, in order to point the program to the desired folders:
	* In "1_get_mirex_estimates.rb", set your local path to download all the data (NOTE: We recommend making this the "./mirex_data" path, since some of the data is already there!)
	* In "2_generate_smith2013_ismir", set the exact same path as above
	* In "2_generate_smith2013_ismir", set the path to your copy of the "structural analysis evaluation" repository

4. Run the Ruby script "1_get_mirex_estimates.rb" and wait a while for all the data to download. [Alternatively, because this takes a long time, just unzip the contents of the included MIREX_DATA.zip file. It's all there. Running the Ruby script just allows you to literally reproduce my work.]

5. Unzip all the folders that you obtained.
	Note: in this version, one of the repositories, the Ewald Peiszer repository, is included already as a zip file ("ep_groundtruth_txt.zip"). If you set "./mirex_data" as the download path in Step 3, then just unzip it here. Otherwise, move it to wherever the rest of the zips are.
	Note: the SALAMI data contains a zipfile, so after unzipping it, you will need to unzip one of its contents again.
	Note: due to inconsistencies in how different zipping programs handle things, the folder structure upon unzipping may be inconsistent. Please look at the Ground Truth Directory map below and make sure your files unzip in the same way. If they don't, you'll have to move things around until the structure matches.

6. Run the Matlab script "2_generate_smith2013_ismir" and wait for all the data to be assembled, and for the figures to be generated. They will appear in "./plots". This repository includes what those pictures *should* look like. Hopefully you overwrite them with exact replicas.

7. You're done! Hey, that wasn't so bad.


## Known issues

1. Bug in how CSV files are parsed in Ruby v.1.9.3. Seems to work fine using an older version: try 1.8.7.

1.1. In January 2014, the code was updated to work with Ruby v.2.1.


===== Ground Truth Directory map =====

When your ground truth is all downloaded and unzipped, it should look like this (relevant for Step 5 above):

	|-- AIST.RWC-MDB-C-2001.CHORUS
	|-- AIST.RWC-MDB-G-2001.CHORUS
	|-- AIST.RWC-MDB-J-2001.CHORUS
	|-- AIST.RWC-MDB-P-2001.CHORUS
	|-- Carole%20King%20Annotations
	|   |-- all
	|   |   |-- Carole King
	|   |   |   |-- Tapestry
	|   |-- chordlab
	|   |   |-- Carole King
	|   |   |   |-- Tapestry
	|   |-- keylab
	|   |   |-- Carole King
	|   |   |   |-- Tapestry
	|   |-- seglab
	|   |   |-- Carole King
	|   |   |   |-- Tapestry
	|-- ep_groundtruth
	|   |-- groundtruth
	|-- ep_groundtruth_txt
	|   |-- groundtruth
	|-- IRISA.RWC-MDB-P-2001.BLOCKS
	|-- IRISA.RWC-MDB-P-2012.SEMLAB_v003_full
	|-- IRISA.RWC-MDB-P-2012.SEMLAB_v003_reduced
	|-- Michael%20Jackson%20Annotations
	|   |-- all
	|   |   |-- Michael Jackson
	|   |   |   |-- Essential Michael Jackson [Disc 1]
	|   |   |   |-- Essential Michael Jackson [Disc 2]
	|   |-- seglab
	|   |   |-- Michael Jackson
	|   |   |   |-- Essential Michael Jackson [Disc 1]
	|   |   |   |-- Essential Michael Jackson [Disc 2]
	|-- Queen%20Annotations
	|   |-- all
	|   |   |-- Queen
	|   |   |   |-- Greatest Hits I
	|   |   |   |-- Greatest Hits II
	|   |   |   |-- Greatest Hits III
	|   |-- chordlab
	|   |   |-- Queen
	|   |   |   |-- Greatest Hits I
	|   |   |   |-- Greatest Hits II
	|   |-- keylab
	|   |   |-- Queen
	|   |   |   |-- Greatest Hits I
	|   |   |   |-- Greatest Hits II
	|   |-- seglab
	|   |   |-- Queen
	|   |   |   |-- Greatest Hits I
	|   |   |   |-- Greatest Hits II
	|   |   |   |-- Greatest Hits III
	|-- SALAMI_data_v1.2
	|   |-- data
	|   |   |-- 2
	|   |   |   |-- parsed
	|   |   |-- 4
	|   |   |   |-- parsed
	|   |   |-- 6
	|   |   |   |-- parsed
	|   |   |-- 8
	|   |   |   |-- parsed
	|   |   .
	|   |   .
	|   |   .
	|   |   |-- 1648
	|   |   |   |-- parsed
	|   |   |-- 1650
	|   |   |   |-- parsed
	|   |   |-- 1652
	|   |   |   |-- parsed
	|   |   |-- 1654
	|   |   |   |-- parsed
	|-- The%20Beatles%20Annotations
	|   |-- all
	|   |   |-- The Beatles
	|   |   |   |-- 01_-_Please_Please_Me
	|   |   |   |-- 02_-_With_the_Beatles
	|   |   |   |-- 03_-_A_Hard_Day's_Night
	|   |   |   |-- 04_-_Beatles_for_Sale
	|   |   |   |-- 05_-_Help!
	|   |   |   |-- 06_-_Rubber_Soul
	|   |   |   |-- 07_-_Revolver
	|   |   |   |-- 08_-_Sgt._Pepper's_Lonely_Hearts_Club_Band
	|   |   |   |-- 09_-_Magical_Mystery_Tour
	|   |   |   |-- 10CD1_-_The_Beatles
	|   |   |   |-- 10CD2_-_The_Beatles
	|   |   |   |-- 11_-_Abbey_Road
	|   |   |   |-- 12_-_Let_It_Be
	|   |-- beat
	|   |   |-- The Beatles
	|   |   |   |-- 01_-_Please_Please_Me
	|   |   |   |-- 02_-_With_the_Beatles
	|   |   |   |-- 03_-_A_Hard_Day's_Night
	|   |   |   |-- 04_-_Beatles_for_Sale
	|   |   |   |-- 05_-_Help!
	|   |   |   |-- 06_-_Rubber_Soul
	|   |   |   |-- 07_-_Revolver
	|   |   |   |-- 08_-_Sgt._Pepper's_Lonely_Hearts_Club_Band
	|   |   |   |-- 09_-_Magical_Mystery_Tour
	|   |   |   |-- 10CD1_-_The_Beatles
	|   |   |   |-- 10CD2_-_The_Beatles
	|   |   |   |-- 11_-_Abbey_Road
	|   |   |   |-- 12_-_Let_It_Be
	|   |-- chordlab
	|   |   |-- The Beatles
	|   |   |   |-- 01_-_Please_Please_Me
	|   |   |   |-- 02_-_With_the_Beatles
	|   |   |   |-- 03_-_A_Hard_Day's_Night
	|   |   |   |-- 04_-_Beatles_for_Sale
	|   |   |   |-- 05_-_Help!
	|   |   |   |-- 06_-_Rubber_Soul
	|   |   |   |-- 07_-_Revolver
	|   |   |   |-- 08_-_Sgt._Pepper's_Lonely_Hearts_Club_Band
	|   |   |   |-- 09_-_Magical_Mystery_Tour
	|   |   |   |-- 10CD1_-_The_Beatles
	|   |   |   |-- 10CD2_-_The_Beatles
	|   |   |   |-- 11_-_Abbey_Road
	|   |   |   |-- 12_-_Let_It_Be
	|   |-- keylab
	|   |   |-- The Beatles
	|   |   |   |-- 01_-_Please_Please_Me
	|   |   |   |-- 02_-_With_the_Beatles
	|   |   |   |-- 03_-_A_Hard_Day's_Night
	|   |   |   |-- 04_-_Beatles_for_Sale
	|   |   |   |-- 05_-_Help!
	|   |   |   |-- 06_-_Rubber_Soul
	|   |   |   |-- 07_-_Revolver
	|   |   |   |-- 08_-_Sgt._Pepper's_Lonely_Hearts_Club_Band
	|   |   |   |-- 09_-_Magical_Mystery_Tour
	|   |   |   |-- 10CD1_-_The_Beatles
	|   |   |   |-- 10CD2_-_The_Beatles
	|   |   |   |-- 11_-_Abbey_Road
	|   |   |   |-- 12_-_Let_It_Be
	|   |-- seglab
	|   |   |-- The Beatles
	|   |   |   |-- 01_-_Please_Please_Me
	|   |   |   |-- 02_-_With_the_Beatles
	|   |   |   |-- 03_-_A_Hard_Day's_Night
	|   |   |   |-- 04_-_Beatles_for_Sale
	|   |   |   |-- 05_-_Help!
	|   |   |   |-- 06_-_Rubber_Soul
	|   |   |   |-- 07_-_Revolver
	|   |   |   |-- 08_-_Sgt._Pepper's_Lonely_Hearts_Club_Band
	|   |   |   |-- 09_-_Magical_Mystery_Tour
	|   |   |   |-- 10CD1_-_The_Beatles
	|   |   |   |-- 10CD2_-_The_Beatles
	|   |   |   |-- 11_-_Abbey_Road
	|   |   |   |-- 12_-_Let_It_Be
	|-- TUT
	|   |-- 01_-_Please_please_me_1963
	|   |-- 02_-_With_The_Beatles_1963
	|   |-- 03_-_A_hard_days_night_1964
	|   |-- 04_-_Beatles_for_sale_1964
	|   |-- 05_-_Help_1965
	|   |-- 06_-_Rubber_Soul.bak.bak
	|   |-- 07_-_Revolver
	|   |-- 08_-_Sgt._Pepper's_Lonely_Hearts_Club_Band
	|   |-- 09_-_Magical_Mystery_Tour
	|   |-- 10_-_The_Beatles_(White_Album)_CD1
	|   |-- 10_-_The_Beatles_(White_Album)_CD2
	|   |-- 11_-_Abbey_Road
	|   |-- 12_-_Let_it_Be
	|   |-- LICENSE
	|   |-- README
	|-- Zweieck%20Annotations
	    |-- all
	    |   |-- Zweieck
	    |   |   |-- Zwielicht
	    |-- beat
	    |   |-- Zweieck
	    |   |   |-- Zwielicht
	    |-- chordlab
	    |   |-- Zweieck
	    |   |   |-- Zwielicht
	    |-- keylab
	    |   |-- Zweieck
	    |   |   |-- Zwielicht
	    |-- seglab
	        |-- Zweieck
	            |-- Zwielicht


## The MIT License (MIT)

Copyright (c) 2013 Jordan B. L. Smith

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

The software is provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or the use or other dealings in the software.
