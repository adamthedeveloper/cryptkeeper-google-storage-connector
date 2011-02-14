# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cryptkeeper}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Adam Medeiros"]
  s.date = %q{2011-02-13}
  s.description = %q{Work with Google Storage}
  s.email = %q{adammede@gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "lib/crypt_keeper.rb"]
  s.files = ["README.rdoc", "Rakefile", "lib/crypt_keeper.rb", "Manifest", "cryptkeeper.gemspec"]
  s.homepage = %q{http://github.com/adamthedeveloper/cryptkeeper}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Cryptkeeper", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{cryptkeeper}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Work with Google Storage}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
