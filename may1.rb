require 'benchmark'

@amount = 100000
@results = {}

text = "carlos test 1 chris ojete carlos cads ojete moreno hector chris"
items = ["carlos", "moreno", "ojete"]

def bench title, &block
  @results[title] = block
end

def print_result gc
  puts "Start Benchmarking with#{gc ? "" : "out"} GC"

  GC.start
  GC.disable unless gc
  
  counter, total = 0, @results.size * @amount

  results = @results.collect do |title, block|
    time = Benchmark.realtime do 
      @amount.times do 
        print " Running benchmarks... #{100 * counter / total} %   \r" if counter % (total / 100) == 0
        block.call
        counter += 1
      end
    end
    result = block.call

    [title, {:time => time, :result => result}]
  end
  
  puts " Finished Benchmarks... 100 % Showing results from best to worst"
  puts
  
  results.sort{|x,y|x[1][:time] <=> y[1][:time]}.each do |title, result|
    puts title
    puts "Time: #{format("%.4f", result[:time] * 1_000_000.0 / @amount)} ns Result: #{result[:result].inspect}"
    puts
  end

  GC.enable
end

p "--------------------------------------------------------------------"
p "Counting each time a word from items appears at text (the total sum)"
p "--------------------------------------------------------------------"

bench "Chris Regex based solution" do text.gsub(/(carlos|moreno|ojete)/).count; end

bench "Chris Regex in split based solution" do text.split(/(?=carlos|moreno|ojete)/).size; end

bench "Carlos Collect solution" do text.split(' ').collect{|word| 1 if items.include?(word)}.compact.count end

bench "Hector inject solution" do text.split(' ').inject(0) { |sum, word| items.include?(word) ? sum + 1 : sum  } end

bench "Carlos find_all solution" do text.split(' ').find_all{|word| items.include?(word)}.count end

bench "GSUB replace, quite slow,  Chris" do text.gsub(/(?!carlos|moreno|ojete)./, "").size; end

bench "scan, Chris" do text.scan(/(carlos|moreno|ojete)/).size end

bench "scan with block, Chris" do i=0; text.scan(/(carlos|moreno|ojete)/){||i+=1}; i; end

print_result true
print_result false
@results = {}

p "-----------------------------------------------------------"
p "Keeping a count of the appearances of each word in the text"
p "-----------------------------------------------------------"

bench "Using group by and collect" do Hash[text.split(" ").group_by{|elem| elem}.collect{|key, val|  [key, val.size]}] end

bench "Using inject Carlos solution" do text.split(" ").inject({}) {|hash, key| hash.has_key?(key) ? hash[key] +=1 : hash[key] = 1; hash} end

bench "Using inject Chris solution using boolean || instead of .has_key?" do 
  text.split(" ").inject({}) {|hash, value| hash[value] ||= 0; hash[value] += 1; hash;} 
end

bench "has_key with each, Chris's solution, init hash with {}" do 
  h = {}; text.split.each{|w|h.has_key?(w) ? h[w] +=1 : h[w] = 1;}; h 
end

bench "has_key with each, Chris's solution, init hash with Hash.new" do 
  h = Hash.new; text.split.each{|w|h.has_key?(w) ? h[w] +=1 : h[w] = 1;}; h 
end

print_result true
print_result false
@results = {}
