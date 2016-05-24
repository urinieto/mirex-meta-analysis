require "CSV"
require "open-uri"
# require "simplexml"
mirex_path = "/Users/jblsmith/Documents/repositories/mirex-meta-analysis/mirex_data"
    # EDIT THIS TO BE YOUR OWN DESIRED PATH.
    # IT WILL NEED TO HOLD ROUGHLY 70 MB OF DATA.
    
def url_download(uri, filename=".")
    open(filename, 'w') do |foo|
        foo.print open(uri).read
    end
end

def convert_file(filename)
    ann_out_file = filename[0..-4] + "_gt.txt"
    alg_out_file = filename[0..-4] + "_pred.txt"
    ann_out = File.open(ann_out_file,'w')
    alg_out = File.open(alg_out_file,'w')
    text = File.open(filename,'r').readlines[1..-4].join("").split(/[\[\]]/)
    text = File.open(filename,'r').readlines(sep=",").join("").split(/[\[\]]/)
    ann = text[2].split(/[\{\}]/)
    alg = text[4].split(/[\{\}]/)
    ann_out.write(json_2_text(ann))
    alg_out.write(json_2_text(alg))
    ann_out.close
    alg_out.close
end

def json_2_text(json)
    txt = []
    (1..json.length).step(2).to_a.each do |indx|
        line = json[indx]
        els = line.split(",")
        # Make a LAB-style annotation (3-column):
        # txt.push([els[0].split(" ")[-1].to_f, els[1].split(" ")[-1].to_f, els[2].split("\"")[-1]].join("\t"))
        # Make a TXT-style annotation (2-column):
        txt.push([els[0].split(" ")[-1].to_f, els[2].split("\"")[-1]].join("\t"))
    end
    txt.push([json[-1].split(",")[1].split(" ")[-1].to_f, "End"].join("\t"))
    return txt.join("\n")
end

puts "Thanks for starting the script! Stay tuned for periodic updates."

# # # #         PART 1:  DOWNLOAD ALL THE STRUCTURAL ANALYSIS EVALUTION DATA PUBLISHED BY MIREX

# Define list of algorithms and datasets:
datasets = ["mrx09", "mrx10_1", "mrx10_2", "sal"]

algos = ["SP1", "SMGA2", "MHRAF1", "SMGA1", "SBV1", "KSP2", "OYZS1", "KSP3", "KSP1"]
year = "2012"

algos = ["RBH1","RBH2","RBH3","RBH4","MP1","MP2","CF5","CF6"]
year = "2013"

algos = ["SUG1","SUG2","NJ1","NB1","NB2","NB3"]
year = "2014"

# Create appropriate directory tree and download CSV files:
Dir.mkdir(mirex_path) unless File.directory?(mirex_path)
puts("Downloading CSV files...\n")
datasets.each do |dset|
    # Make dataset directory:
    dir_path = File.join(mirex_path,year,dset)
    Dir.mkdir(dir_path) unless File.directory?(dir_path)
    algos.each do |algo|
        # Make algorithm directory:
        algo_path = File.join(dir_path,algo)
        Dir.mkdir(algo_path) unless File.directory?(algo_path)
        # Download the CSV file to this directory:
        algocsvpath = File.join(algo_path,"per_track_results.csv")
        csv_path = File.join(("http://nema.lis.illinois.edu/nema_out/mirex"+year),"/results/struct",dset,algo,"per_track_results.csv")
        url_download(csv_path, algocsvpath)
    end
end

puts "..done with that."

puts "Now we will download all the files output by each algorithm. This could take a while depending on your connection."
puts "Since this script points to " + datasets.length.to_s + " datasets and " + algos.length.to_s + " algorithms, you should expect to wait however long it takes between each of the next lines to appear, times " + (datasets.length*algos.length).to_s + "."

# Read each CSV file and download all the json files it points to:
datasets.each do |dset|
    algos.each do |algo|
        puts( "Starting to download "+dset+ " dataset for " + algo + " algorithm...\n")
        download_folder = File.join(mirex_path,year,dset,algo)
        algocsvpath = File.join(download_folder,"per_track_results.csv")
        csv_data = File.read(algocsvpath).split("\n")
        header = csv_data.delete_at(0)
        # For each line in the spreadsheet, extract the songid and download the corresponding json document.
        csv_data.each do |line|
            line = line.split(",")
            song_id = line[1]
            url = "http://nema.lis.illinois.edu/nema_out/mirex" + year + "/results/struct/" + dset + "/" + algo.downcase + "segments" + song_id.delete("_") + ".js"
            download_path = File.join(download_folder,song_id + ".js")
            # download_path = download_folder + "/" + song_id + ".js"
            url_download(url, download_path)
        end
    end
    puts("Done with " + dset + " dataset!\n")
end

puts "..done with that."

puts "Now, a much faster step: turning all the json files you downloaded into simpler text files."
# Scan for all the json files, and convert each one into two text files, one for the algorithm output, one for the annotation:
all_json_files = Dir.glob(File.join(mirex_path,year,"*","*","*.js"))
all_json_files.each do |file|
    convert_file(file)
    puts file
end

puts "..done with that."

puts "Now, PART 2 of the script: we download all the zip files (from various websites) that contain the public collections of ground truth files. This will only take a couple minutes, depending on connection speed (it's about 4 MB total)."


# # # #         PART 2:  GET (AND CONVERT) THE ANNOTATION DATA PUBLISHED BY OTHERS

# Download and unzip all public annotations
list_of_db_urls = ["https://staff.aist.go.jp/m.goto/RWC-MDB/AIST-Annotation/AIST.RWC-MDB-P-2001.CHORUS.zip", "https://staff.aist.go.jp/m.goto/RWC-MDB/AIST-Annotation/AIST.RWC-MDB-C-2001.CHORUS.zip", "https://staff.aist.go.jp/m.goto/RWC-MDB/AIST-Annotation/AIST.RWC-MDB-J-2001.CHORUS.zip", "https://staff.aist.go.jp/m.goto/RWC-MDB/AIST-Annotation/AIST.RWC-MDB-G-2001.CHORUS.zip", "http://www.music.mcgill.ca/~jordan/salami/releases/SALAMI_data_v1.2.zip", "http://www.ifs.tuwien.ac.at/mir/audiosegmentation/dl/ep_groundtruth_excl_Paulus.zip", "http://musicdata.gforge.inria.fr/IRISA.RWC-MDB-P-2012.SEMLAB_v003_full.zip", "http://musicdata.gforge.inria.fr/IRISA.RWC-MDB-P-2012.SEMLAB_v003_reduced.zip", "http://musicdata.gforge.inria.fr/IRISA.RWC-MDB-P-2001.BLOCKS_v001.zip", "http://www.isophonics.net/files/annotations/The%20Beatles%20Annotations.tar.gz", "http://www.isophonics.net/files/annotations/Carole%20King%20Annotations.tar.gz", "http://www.isophonics.net/files/annotations/Queen%20Annotations.tar.gz", "http://www.isophonics.net/files/annotations/Michael%20Jackson%20Annotations.tar.gz", "http://www.isophonics.net/files/annotations/Zweieck%20Annotations.tar.gz", "http://www.cs.tut.fi/sgn/arg/paulus/beatles_sections_TUT.zip", "http://www.iua.upf.edu/~perfe/annotations/sections/beatles/structure_Beatles.rar"]

public_data_path = File.join(mirex_path,"public_data")
Dir.mkdir(public_data_path) unless File.directory?(public_data_path)
list_of_db_urls.each do |db_url|
    open(File.join(public_data_path,File.basename(db_url)), 'wb') do |foo|
      foo.print open(db_url).read
    end
end

# # # #         NOW, PLEASE EXIT THE SCRIPT, AND UNZIP ALL THOSE PACKAGES.
# # # #         WHEN YOU'RE DONE, GO ONTO THE PARENT MATLAB FILE TO RUN THE ANALYSES.
puts "..done with that.\n\n"
puts "Script apppears to have ended successfully. All files were downloaded and saved to " + public_data_path +"."
puts "To continue please unpack all zip files, start MATLAB, and run 2-generate_smith2013_ismir.m. You can read more on README."
puts "Important: be sure that the zip files unpack into the correct file structure. Again, see README for details."