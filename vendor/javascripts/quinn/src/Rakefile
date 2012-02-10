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
