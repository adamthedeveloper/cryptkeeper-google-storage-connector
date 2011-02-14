# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cryptkeeper}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Adam Medeiros"]
  s.date = %q{2011-02-14}
  s.description = %q{Use cryptkeeper to talk to Google Storage}
  s.email = %q{adammede@gmail.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "CHANGELOG",
    "README.rdoc",
    "Rakefile",
    "cryptkeeper.gemspec",
    "lib/buckets.rb",
    "lib/crypt_keeper.rb",
    "lib/objects.rb"
  ]
  s.homepage = %q{http://github.com/adamthedeveloper/cryptkeeper}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Google Storage Connector}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hpricot>, [">= 0"])
      s.add_runtime_dependency(%q<iconv>, [">= 0"])
      s.add_runtime_dependency(%q<hmac-sha1>, [">= 0"])
      s.add_runtime_dependency(%q<base64>, [">= 0"])
      s.add_runtime_dependency(%q<uri>, [">= 0"])
    else
      s.add_dependency(%q<hpricot>, [">= 0"])
      s.add_dependency(%q<iconv>, [">= 0"])
      s.add_dependency(%q<hmac-sha1>, [">= 0"])
      s.add_dependency(%q<base64>, [">= 0"])
      s.add_dependency(%q<uri>, [">= 0"])
    end
  else
    s.add_dependency(%q<hpricot>, [">= 0"])
    s.add_dependency(%q<iconv>, [">= 0"])
    s.add_dependency(%q<hmac-sha1>, [">= 0"])
    s.add_dependency(%q<base64>, [">= 0"])
    s.add_dependency(%q<uri>, [">= 0"])
  end
end

