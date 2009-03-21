require 'rake'
require 'rake/gempackagetask'
require 'rake/clean'
require 'rake/testtask'
require 'find'

name = 'captcha_service'
version = '0.8'

gem_spec = Gem::Specification.new do |s|
  s.name = name
  s.version = version
  s.summary = %{Lightweight access to external captcha services}
  s.description = %{Lightweight access to external captcha services by Tracy Flynn}
  s.author = "Tracy Flynn"
  s.email = "gems@olioinfo.net"
  s.homepage = "http://olioninfo.net/projects"

  s.test_files = FileList['test/**/*']

  s.files = FileList['lib/**/*.rb', 'README', 'doc/**/*.*', 'lib/**/*.yml']
  s.require_paths << 'lib'
  
  s.add_dependency("mollom", "0.1.4")
  
  # This will loop through all files in your lib directory and autorequire them for you.
  # It will also ignore all Subversion files.
  s.autorequire = []

  ["lib"].each do |dir|
    Find.find(dir) do |f|
      if FileTest.directory?(f) and !f.match(/.svn/)
        s.require_paths << f
      else
        if FileTest.file?(f)
          m = f.match(/[a-zA-Z\-_]*.rb/)
          if m
            model = m.to_s
            unless model.match("test_")
              x = model.gsub('/', '').gsub('.rb', '')
              s.autorequire << x
            end
          end
        end
      end
    end
  end
  s.autorequire.uniq!

end

Rake::GemPackageTask.new(gem_spec) do |pkg|
  pkg.need_zip = false
  pkg.need_tar = false
  rm_f FileList['pkg/**/*.*']
end

desc "Run test code"
Rake::TestTask.new(:default) do |t|
  t.libs << "test"
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

task :install => [:package] do
  sh %{gem install pkg/#{name}-#{version}.gem}
end

task :uninstall do
  sh %{gem uninstall #{name}}
end
