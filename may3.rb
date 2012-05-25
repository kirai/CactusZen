load 'prof.rb'
 
@text = "carlos test 1 chris ojete carlos cads ojete moreno hector chris "
items = ["carlos", "moreno", "ojete"]

puts "--------------------------------------------------------------------"
puts "Counting each time a word from items appears at text (the total sum)"
puts "--------------------------------------------------------------------"

# bench "Baseline" do |text| 5; end

bench "Chris Regex based solution" do |text| text.gsub(/(carlos|moreno|ojete)/).count; end

bench "Chris Regex in split based solution" do |text| text.split(/(?=carlos|moreno|ojete)/).size; end

bench "Carlos Collect solution" do |text| text.split(' ').collect{|word| 1 if items.include?(word)}.compact.count end

bench "Hector inject solution" do |text| text.split(' ').inject(0) { |sum, word| items.include?(word) ? sum + 1 : sum  } end

bench "Carlos find_all solution" do |text| text.split(' ').find_all{|word| items.include?(word)}.count end

bench "Chris each solution" do |text| sum = 0; text.split.each{|word| sum += 1 if items.include?(word)}; sum end

bench "Chris each solution with items - text loop" do |text|
  sum = 0
  splitted_text = text.split
  items.each do |item|
    splitted_text.each{|word| sum += 1 if item == word}
  end
  sum
end

bench "Chris each solution with text - items loop" do |text|
  sum = 0
  splitted_text = text.split
  splitted_text.each do |word|
    items.each{|item| sum += 1 if item == word}
  end
  sum
end

bench "GSUB replace, quite slow,  Chris" do |text| text.gsub(/(?!carlos|moreno|ojete)./, "").size; end

# http://stackoverflow.com/questions/541954/how-would-you-count-occurences-of-a-string-within-a-string-c
bench "inverse GSUB replace, amazingly quick for large data sets,  Chris" do |text| 
  items.inject(0) do |sum, item|
    sum += (text.size - text.gsub(item, "").size) / item.size; 
  end
end

bench "Chris - Using 'group by and collect' from the next benchmark" do |text|
  group = text.split(" ").group_by{|elem| elem}
  items.inject(0){|sum, item|sum += group[item].size; sum}
end

bench "scan, Chris" do |text| text.scan(/(carlos|moreno|ojete)/).size end

bench "scan with block, Chris" do |text| i=0; text.scan(/(carlos|moreno|ojete)/){||i+=1}; i; end

bench "I don't know ruby, just C, the WTF, I am WTF programmer and try it the stupid way, Chris" do |text|
  text_size = text.size
  items_size = items.size
  count = 0
  
  for i in 0...text_size
    for j in 0...items_size
      item = items[j]
  
      if item[0] == text[i]
        size = item.size
        for g in 1...size
           break unless item[g] == text[i+g]
        end
        count += 1 if g + 1 == size
      end
    end
  end
  
  count
end

expected_result = 5

benchmark @text, expected_result

puts "-----------------------------------------------------------"
puts "Keeping a count of the appearances of each word in the text"
puts "-----------------------------------------------------------"

# bench "Baseline" do |text| 5; end

bench "Using group by and collect" do |text| Hash[text.split(" ").group_by{|elem| elem}.collect{|key, val|  [key, val.size]}] end

bench "Using inject Carlos solution" do |text| text.split(" ").inject({}) {|hash, key| hash.has_key?(key) ? hash[key] +=1 : hash[key] = 1; hash} end

bench "Using inject Chris solution using boolean || instead of .has_key?" do |text| 
  text.split(" ").inject({}) {|hash, value| hash[value] ||= 0; hash[value] += 1; hash;} 
end

bench "has_key with each, Chris's solution, init hash with {}" do |text| 
  h = {}; text.split.each{|w|h.has_key?(w) ? h[w] +=1 : h[w] = 1;}; h 
end

bench "has_key with each, Chris's solution, init hash with Hash.new" do |text| 
  h = Hash.new; text.split.each{|w|h.has_key?(w) ? h[w] +=1 : h[w] = 1;}; h 
end

expected_result = {"carlos"=>2, "test"=>1, "1"=>1, "chris"=>2, "ojete"=>2, "cads"=>1, "moreno"=>1, "hector"=>1}

benchmark @text, expected_result
