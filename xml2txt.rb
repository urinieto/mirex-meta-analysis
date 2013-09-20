require 'xmlsimple'

# Script to convert Ewald Peiszer's XML annotations to my TXT format annotations.

a = XmlSimple.xml_in(ARGV[0])
rows = []
a["segmentation"][0]["segment"].each do |item|
    rows << [item["start_sec"],item["label"]].join("\t")
end
rows << [a["segmentation"][0]["segment"][-1]["end_sec"],"end"].join("\t")

if ARGV[1].nil? then
    filename = ARGV[0].split(".")[0..-2].join(".")
else
    filename = ARGV[1].chomp
end

c = File.open(filename+".txt",'w')
c.write(rows)
c.close