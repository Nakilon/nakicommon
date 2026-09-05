Gem::Specification.new do |spec|
  spec.name         = "nakicommon-rake"
  spec.version      = "0.0.0"
  spec.summary      = "NOT FOR RUBYGEMS (yet?)"
  spec.metadata     = {"source_code_uri" => "https://github.com/nakilon/nakicommon"}

  spec.author       = "Victor Maslov aka Nakilon"
  spec.email        = "nakilon@gmail.com"
  spec.license      = "MIT"

  spec.add_dependency "rake"

  spec.files        = %w{ LICENSE nakicommon-rake.gemspec lib/nakicommon/rake.rb }
end
