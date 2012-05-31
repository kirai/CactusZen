require 'benchmark'

puts `ruby -v`

@amount = 10000
@tests = {}

def bench title, &block
  @tests[title] = block
end

def benchmark text, expected_result
  print_result true, text, @amount, expected_result
  print_result false, text, @amount, expected_result
  
  puts "-----------------------------------------------------------"
  puts "Try the same with more text"
  puts "-----------------------------------------------------------"
  
  print_result true, text*1000, @amount / 1000
  print_result false, text*1000, @amount / 1000
  
  puts "-----------------------------------------------------------"
  puts "Try the same with even more text"
  puts "-----------------------------------------------------------"
  
  print_result true, text*10000, @amount / 10000
  print_result false, text*10000, @amount / 10000
  
  @count ||= 0
  @count += 1
  file_name = "stats_#{@count}.csv"
  puts "-----------------------------------------------------------"
  puts "Plotted Benchmark output to #{file_name}"
  puts "Can be opened e.g. with OpenOffice"
  puts "(open with OpenOffice, allow TAB as separator, then after opening, click the graph icon, very easy)"
  puts "gives you the amount of bytes processed per ns in respect to the data size (64byte ~ 64000byte)"
  puts "-----------------------------------------------------------"

  plotter text, file_name
  
  # clear tests
  @tests = {}
end

# private

def print_result gc, text, amount, expected_result=nil
  puts "*" * 100
  puts " Start Benchmarking with#{gc ? "" : "out"} GC"
  
  counter, total = 0, @tests.size * amount

  results = @tests.collect do |title, block|
    GC.start
    GC.disable unless gc
    
    mem = (GC.respond_to?(:stat) ? GC.stat : {})

    time = Benchmark.realtime do 
      amount.times do 
        print " Running benchmarks... #{100 * counter / total} %   \r" if counter % (total / 100 + 1) == 0
        result = block.call(text)
        counter += 1
        
        unless expected_result == nil || expected_result == result
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
  
  if results.first[1][:result]
    puts " Expected result: #{results.first[1][:result].inspect}" if results.first[1][:result]
    puts
  end
  
  results.sort{|x,y|x[1][:time] <=> y[1][:time]}.each do |title, result|
    puts "Time: #{format("%.4f", result[:time] * 1_000_000.0 / amount)} ns  Title: #{title}  Memory: GC=#{result[:mem][:gc_count]} mem incr=#{result[:mem][:mem_incr]}"
  end
end

def plotter text, file_name
  results = plotter_calc text

  rows = results.collect{|hash|hash[:size_factor]}.uniq.sort
  columns = results.collect{|hash|hash[:title]}.uniq.sort
  
  csv = rows.size.times.collect{||[nil] * columns.size} # for each row create an array for the columns

  results.each do |hash|
    csv[rows.index(hash[:size_factor])][columns.index(hash[:title])] = hash[:bytes_pro_ns]
  end
  
  File.open(file_name, "w") do |file|
    file.write(([''] + columns).join("\t") + "\n")

    csv.each_with_index do |line, i|
      vals = [rows[i]] + line
      file.write(vals.join("\t") + "\n")
    end
  end
  
  results
end

def plotter_calc text
  results = @tests.collect do |title, block|
    mem = (GC.respond_to?(:stat) ? GC.stat : {})
    
    (0..15).collect do |factor|
      size_factor = (10 ** (2 * factor / 10.0)).to_i
      time = plotter_one title, text * size_factor, block
      {:size_factor => "Bytes #{text.size * size_factor}", :bytes_pro_ns => text.size * size_factor / time, :time => time, :title => title.gsub(/[^\w]/, '')[0..15]}
    end
  end.flatten
end

def plotter_one title, text, block
  r0 = Time.now
  
  gc = false
  
  GC.start
  GC.disable unless gc

  timeout = 40 # ms
  samples = 15

  result = plotter_sampled_timeout_test samples, timeout, text, block

  puts "#{format("%.4f", result.average)} ns   standard deviation: +/- #{format("%.4f", result.perc_standard_deviation)}%  Size: #{text.size}  #{title}"
  
  GC.enable
  
  result.average
end

# runs one test several times and returns the time taken for each
def plotter_sampled_timeout_test samples, timeout, text, block
  samples.times.collect{||plotter_timeout_test timeout, text, block}
end

# returns ns average time of one single test, timeout is in ms
def plotter_timeout_test timeout, text, block
  # initialize machine (loading etc.)
  block.call(text)

  r0 = Time.now
  elapsed_time = 0
  count = 0

  while(elapsed_time < timeout)
    block.call(text)
    count += 1
    elapsed_time = (Time.now - r0) * 1_000.0
  end

  count == 0 ? 0 : 1_000 * elapsed_time / count
end


#  Add methods to Enumerable, which makes them available to Array
module Enumerable
 
  #  sum of an array of numbers
  def sum
    return self.inject(0){|acc,i|acc +i}
  end
 
  #  average of an array of numbers
  def average
    return self.sum/self.length.to_f
  end
 
  #  variance of an array of numbers
  def sample_variance
    avg=self.average
    sum=self.inject(0){|acc,i|acc +(i-avg)**2}
    return(1/self.length.to_f*sum)
  end
 
  #  standard deviation of an array of numbers
  def standard_deviation
    return Math.sqrt(self.sample_variance)
  end
  
  def perc_standard_deviation
    100.0 * standard_deviation / average
  end
 
end  #  module Enumerable