require "CSV"
require "open-uri"
require 'fileutils'
require 'net/http'

# Usage:
#   ruby get_mirex_estimates.rb
#     -> Run Parts 1 and 2 of the script.
#        Part 1 takes a long time because it requires downloading thousands of files from MIREX website.
#        Part 2 takes a few minutes. It downloads ground truth zipfiles from various sources.
#        Before running, please confirm paths in "user_path.txt".
#   ruby get_mirex_estimates.rb 1
#     -> Run only Part 1.
#   ruby get_mirex_estimates.rb 2
#     -> Run only Part 2.

def url_download(uri, filename=".")
    puts("Downloading %s...\n" % [uri])
    open(filename, 'w') do |foo|
        foo.print URI.open(uri).read
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

def downloadMIREXdata(mirex_path)
  # # # #         PART 1: DOWNLOAD ALL THE STRUCTURAL ANALYSIS EVALUTION DATA PUBLISHED BY MIREX

  # Define list of algorithms and datasets:
  algos_year = {
    "2012" => ["SP1", "SMGA2", "MHRAF1", "SMGA1", "SBV1", "KSP2", "OYZS1", "KSP3", "KSP1"],
    "2013" => ["RBH1","RBH2","RBH3","RBH4","MP1","MP2","CF5","CF6"],
    "2014" => ["SUG1","SUG2","NJ1","NB1","NB2","NB3"],
    "2015" => ["CC1","GS1","GS3","MC1"],
    "2016" => ["CC1","MC1","ON1","ON2","ON3","ON4","ON5"],
    "2017" => ["CC1","CM1"]
  }

  ds_year = {
    "2012" => ["mrx09", "mrx10_1", "mrx10_2", "sal"],
    "2013" => ["mrx09", "mrx10_1", "mrx10_2", "sal"],
    "2014" => ["mrx09", "mrx10_1", "mrx10_2", "sal"],
    "2015" => ["mrx09", "mrx10_1", "mrx10_2", "salami"],
    "2016" => ["mrx09", "mrx10_1", "mrx10_2", "salami"],
    "2017" => ["mrx09", "mrx10_1", "mrx10_2", "salami"]
  }
  mirex_url = "https://nema.lis.illinois.edu/nema_out/mirex"

  # Create appropriate directory tree and download CSV files:
  Dir.mkdir(mirex_path) unless File.directory?(mirex_path)
  puts("Downloading CSV files...\n")
  algos_year.each do | year, algos |
      datasets = ds_year[year]
      datasets.each do |dset|
          # Make dataset directory:
          dir_path = File.join(mirex_path,year,dset)
          #Dir.mkdir(dir_path) unless File.directory?(dir_path)
          FileUtils.mkdir_p(dir_path) unless File.directory?(dir_path)
          algos.each do |algo|
              # Make algorithm directory:
              algo_path = File.join(dir_path,algo)
              Dir.mkdir(algo_path) unless File.directory?(algo_path)
              # Download the CSV file to this directory:
              algocsvpath = File.join(algo_path,"per_track_results.csv")
              csv_path = File.join((mirex_url+year),"/results/struct",dset,algo,"per_track_results.csv")
              url_download(csv_path, algocsvpath)
          end
      end
  end

  puts "..done with that."

  puts "Now we will download all the files output by each algorithm. This could take a while depending on your connection."
  #puts "Since this script points to " + datasets.length.to_s + " datasets and " + algos.length.to_s + " algorithms, you should expect to wait however long it takes between each of the next lines to appear, times " + (datasets.length*algos.length).to_s + "."

  # Read each CSV file and download all the json files it points to:
  algos_year.each do | year, algos |
      datasets = ds_year[year]
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
                  url = mirex_url + year + "/results/struct/" + dset + "/" + algo.downcase + "segments" + song_id.delete("_") + ".js"
                  download_path = File.join(download_folder,song_id + ".js")
                  url_download(url, download_path)
              end
          end
          puts("Done with " + dset + " dataset!\n")
      end
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
end



# # # #         PART 2:  GET (AND CONVERT) THE ANNOTATION DATA PUBLISHED BY OTHERS

def downloadAnnotationData(mirex_path)
  puts "PART 2 of the script: we download all the zip files (from various websites) that contain the public collections of ground truth files. This will only take a couple minutes, depending on connection speed (it's about 4 MB total)."

  # Download and unzip all public annotations
  list_of_db_urls = [
    "https://staff.aist.go.jp/m.goto/RWC-MDB/AIST-Annotation/AIST.RWC-MDB-P-2001.CHORUS.zip",
    "https://staff.aist.go.jp/m.goto/RWC-MDB/AIST-Annotation/AIST.RWC-MDB-C-2001.CHORUS.zip",
    "https://staff.aist.go.jp/m.goto/RWC-MDB/AIST-Annotation/AIST.RWC-MDB-J-2001.CHORUS.zip",
    "https://staff.aist.go.jp/m.goto/RWC-MDB/AIST-Annotation/AIST.RWC-MDB-G-2001.CHORUS.zip",
    "https://github.com/DDMAL/salami-data-public/archive/1.2.zip",
    "http://www.ifs.tuwien.ac.at/mir/audiosegmentation/dl/ep_groundtruth_excl_Paulus.zip",
    "http://musicdata.gforge.inria.fr/IRISA.RWC-MDB-P-2012.SEMLAB_v003_full.zip",
    "http://musicdata.gforge.inria.fr/IRISA.RWC-MDB-P-2012.SEMLAB_v003_reduced.zip",
    "http://musicdata.gforge.inria.fr/IRISA.RWC-MDB-P-2001.BLOCKS_v001.zip",
    "http://www.isophonics.net/files/annotations/The%20Beatles%20Annotations.tar.gz",
    "http://www.isophonics.net/files/annotations/Carole%20King%20Annotations.tar.gz",
    "http://www.isophonics.net/files/annotations/Queen%20Annotations.tar.gz",
    "http://www.isophonics.net/files/annotations/Michael%20Jackson%20Annotations.tar.gz",
    "http://www.isophonics.net/files/annotations/Zweieck%20Annotations.tar.gz",
    "http://www.cs.tut.fi/sgn/arg/paulus/beatles_sections_TUT.zip"]
    #"http://www.iua.upf.edu/~perfe/annotations/sections/beatles/structure_Beatles.rar"]  # This one is no longer valid

  public_data_path = File.join(mirex_path,"public_data")
  Dir.mkdir(public_data_path) unless File.directory?(public_data_path)
  list_of_db_urls.each do |db_url|
      url_download(db_url, File.join(public_data_path,File.basename(db_url)))
  end
  puts "..done with that.\n\n"
  puts "Script apppears to have ended successfully. All files were downloaded and saved to " + public_data_path +"."
  puts "To continue please unpack all zip files, start MATLAB, and run 2-generate_smith2013_ismir.m. You can read more on README."
  puts "Important: be sure that the zip files unpack into the correct file structure. Again, see README for details."
end

# Very hacky arg parsing:

dostep1 = false
dostep2 = false

if ARGV[0]==nil
  dostep1 = true
  dostep2 = true
else
  ARGV.each do|a|
    if a=="1"
      dostep1 = true
    elsif a=="2"
      dostep2 = true
    end
  end
end

mirex_path = File.open("user_paths.txt").readlines[1].strip()
if dostep1
  downloadMIREXdata(mirex_path)
end
if dostep2
  downloadAnnotationData(mirex_path)
end
