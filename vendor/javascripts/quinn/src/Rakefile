require 'rubygems'
require 'fileutils'

desc 'Build the library and readme'
task :build => [:readme, :annotated, :minified] do
end

desc 'Build the minified version'
task :minified do
  require 'closure-compiler'

  source  = File.read('jquery.quinn.js')
  min     = Closure::Compiler.new.compress(source)

  File.open('jquery.quinn.min.js', 'w') { |f| f.puts min }
end

desc 'Builds the annotated source code docs'
task :annotated do
  `bundle exec rocco jquery.quinn.js`
  FileUtils.mv('jquery.quinn.html', 'docs/jquery.quinn.html')
end

desc 'Build the index.html readme'
task :readme do
  require 'kramdown'

  markdown = Kramdown::Document.new(File.read('README.md'))
  index    = File.read('index.html')

  index.gsub!(/^    <!-- begin README -->.*<!-- end README -->\n/m, <<-HTML)
    <!-- begin README -->

    #{markdown.to_html}
    <!-- end README -->
  HTML

  File.open('index.html', 'w') { |f| f.puts index }
end

desc 'Show the library filesize, including when Gzipped'
task :filesizes do
  require 'zlib'
  require 'stringio'

  development = File.size('jquery.quinn.js')
  minified    = File.size('jquery.quinn.min.js')

  output = StringIO.new
  output.set_encoding 'BINARY'

  gz = Zlib::GzipWriter.new(output)
  gz.write(File.read('jquery.quinn.min.js'))
  gz.close

  gzipped = output.string.bytesize

  puts <<-INFO

    Quinn library filesizes
    -----------------------

    Development:  #{(development.to_f / 1024).round(1)}kb
    Minified:     #{(minified.to_f / 1024).round(1)}kb
    Gzipped:      #{(gzipped.to_f / 1024).round(1)}kb

  INFO
end
