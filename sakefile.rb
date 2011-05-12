# -*- ruby -*-
# sake variant sake3

def try_load file
  begin
    load file
  rescue LoadError; end
end

# Configure any rules related to releasing and uploading and such
# things.
try_load('local/releasing.rb')

desc "Prepares web pages."
task :web do
  srcfiles = Dir['web/*.txt2tags.txt']
  for srcfile in srcfiles
    htmlfile = srcfile.sub(/\.txt2tags\.txt$/, ".html")
    sh("tools/txt2tags --target xhtml --infile %s --outfile %s --encoding utf-8" % [srcfile, htmlfile])
  end
end

#
# Copyright 2008 Helsinki Institute for Information Technology (HIIT)
# and the authors. All rights reserved.
#
# Authors: Tero Hasu <tero.hasu@hut.fi>
#

# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
