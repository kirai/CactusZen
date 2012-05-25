require 'benchmark'

puts `ruby -v`

@data_amount = 50000
@results = {}

@text = "carlos test 1 chris ojete carlos cads ojete moreno hector chris "
items = ["carlos", "moreno", "ojete"]

def bench title, &block
  @results[title] = block
end

def print_result gc, text, expected_result
  puts "*" * 100
  puts " Start Benchmarking with#{gc ? "" : "out"} GC"
  
  amount = @data_amount / (text.size / @text.size)
  
  counter, total = 0, @results.size * amount

  results = @results.collect do |title, block|
    GC.start
    GC.disable unless gc
    
    mem = (GC.respond_to?(:stat) ? GC.stat : {})

    time = Benchmark.realtime do 
      amount.times do 
        print " Running benchmarks... #{100 * counter / total} %   \r" if counter % (total / 100 + 1) == 0
        result = block.call(text)
        counter += 1
        
        unless expected_result == result
          puts
          puts "(~_~)" + ';' * 100
          puts
          puts "WHO WROTE #{title} ??? WHO??? I ASKED WHO WROTE THAT SHIT???"
          puts
          puts "YOU!  YOU ARE DISQUALIFIER, CAUSE THE RESULT WAS <#{result}> AND NOT <#{expected_result}>"
          puts
          break
        end
      end
    end

    mem = Hash[(GC.respond_to?(:stat) ? GC.stat : {}).collect{|key,value| [key, value - mem[key]]}]

    GC.enable

    [title, {:time => time, :result => expected_result, :mem => {:gc_count => mem[:count], :mem_incr => mem[:heap_free_num]}}]
  end.compact
  
  puts " Finished Benchmarks... 100 % Showing results from best to worst"
  puts
  puts " Expected result: #{results.first[1][:result].inspect}"
  puts
  
  results.sort{|x,y|x[1][:time] <=> y[1][:time]}.each do |title, result|
    puts "Time: #{format("%.4f", result[:time] * 1_000_000.0 / amount)} ns  Title: #{title}  Memory: GC=#{result[:mem][:gc_count]} mem incr=#{result[:mem][:mem_incr]}"
  end
end

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

print_result true, @text, expected_result
print_result false, @text, expected_result

puts "-----------------------------------------------------------"
puts "Try the same with more text"
puts "-----------------------------------------------------------"

expected_result = 5000

print_result true, @text*1000, expected_result
print_result false, @text*1000, expected_result

puts "-----------------------------------------------------------"
puts "Try the same with even more text"
puts "-----------------------------------------------------------"

expected_result = 50000

print_result true, @text*10000, expected_result
print_result false, @text*10000, expected_result

@results = {}

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

print_result true, @text, expected_result
print_result false, @text, expected_result

puts "-----------------------------------------------------------"
puts "Try the same with more text"
puts "-----------------------------------------------------------"

expected_result = {"carlos"=>2000, "test"=>1000, "1"=>1000, "chris"=>2000, "ojete"=>2000, "cads"=>1000, "moreno"=>1000, "hector"=>1000}

print_result true, @text*1000, expected_result
print_result false, @text*1000, expected_result

puts "-----------------------------------------------------------"
puts "Try the same with even more text"
puts "-----------------------------------------------------------"

expected_result = {"carlos"=>20000, "test"=>10000, "1"=>10000, "chris"=>20000, "ojete"=>20000, "cads"=>10000, "moreno"=>10000, "hector"=>10000}

print_result true, @text*10000, expected_result
print_result false, @text*10000, expected_result

@results = {}

