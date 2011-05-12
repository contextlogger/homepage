require 'pathname'
require 'pp'
require 'strscan'

$docroot = File.expand_path('web')

if system("which git-ls-files")
  $git_ls_files = "git-ls-files"
else
  $git_ls_files = "git ls-files -c"
end

Dir.chdir('..')

def find_candidates
  file_list = []
  src_re = /[.](?:h|c|hpp|cpp|inl)$/
  IO::popen($git_ls_files) do |input|
    input.each_line do |line|
      line.chomp!
      file_list.push(line) if line =~ src_re
    end
  end
  file_list
end

$file_list = find_candidates
#pp file_list

class Concept
  attr_accessor :name, :desc, :files, :apifiles

  def initialize name
    @name = name
    @files = []
  end
end

$concept_map = Hash.new

def parse_concept file, sc
  sc.scan(/!concept\s*/mu) or raise
  sc.scan(/\{[^{}]*\}/mu) or raise
  rec_s = sc.matched
  #p rec_s
  rec = eval(rec_s)
  #p rec
  raise unless rec.has_key? :name
  name = rec[:name]
  cn = $concept_map[name]
  unless cn
    cn = Concept.new(name)
    $concept_map[name] = cn
  end
  desc = rec[:desc]
  if desc
    cn.desc = desc
  end
  files = cn.files
  if files and !files.include? file
    files = files.push file
  else
    cn.files = [file]
  end
end

def parse_file file
  #p file
  sc = StringScanner.new(File.read(file))
  until sc.eos?
    if sc.scan(/[^!]+/mu)
      next
    elsif sc.check(/!concept\s*\{/mu)
      parse_concept file, sc
    else
      sc.scan(/./mu)
      next
    end
  end
end

for file in $file_list
  parse_file file
end

#pp $concept_map

$api_root = 'daemon/private-cxx-api/html'

$rel_api_root = Pathname.new(File.expand_path($api_root)).relative_path_from(Pathname.new($docroot))

def to_doxyname file
  fn = File.basename file
  fn.gsub! /_/, "__"
  fn.gsub! /[.]/, "_8"
#  fn += "-source.html" # older doxygen
  fn += "_source.html" # newer
  fn
end

for key, value in $concept_map
  value.apifiles = value.files.map do |file|
    dn = to_doxyname(file)
    pn = File.join($api_root, dn)
    unless File.exist? pn
      raise "file nxist #{pn}"
    end
    [file, File.join($rel_api_root, dn)]
  end
  #p value.apifiles
end

concepts = $concept_map.values
concepts.sort! do |x, y|
  x.name <=> y.name
end

def kjoin x
  x.join ", "
end

puts %q{ContextLogger2 Source Code Bits of Interest

%%mtime(%c)

%!includeconf: config.t2t

Below is a list of pointers to some of the more interesting bits of
code in the ContextLogger2 codebase, in the authors' opinion.
The files listed are to the "main" files demonstrating the concept.

|| Concept | Description | Files |}

for cn in concepts
  $stdout.write "| "
  $stdout.write cn.name
  $stdout.write " | "
  if cn.desc
    $stdout.write cn.desc
  end
  $stdout.write " | "
  links = cn.apifiles.map do |entry|
    "[%s %s]" % entry
  end
  $stdout.write(kjoin(links))
  $stdout.write " |"
  $stdout.write "\n"
end

puts %q{
------------------------------------------------
_signature_

% Local Variables:
% mode: longlines
% End:
}
