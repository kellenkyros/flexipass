# frozen_string_literal: true

require_relative "lib/flexipass/version"

Gem::Specification.new do |spec|
  spec.name = "flexipass"
  spec.version = Flexipass::VERSION
  spec.authors = ["Shiju Devarajan"]
  spec.email = ["shijudevarajan@gmail.com"]

  spec.summary = "Flexipass mobile key integration gem."
  spec.description = "A Ruby gem allows you to easily interact with Flexipass APIs"
  spec.homepage = "https://github.com/kellenkyros/flexipass"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/kellenkyros/flexipass"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  # spec.files = Dir.chdir(__dir__) do
  #   `git ls-files -z`.split("\x0").reject do |f|
  #     (File.expand_path(f) == __FILE__) ||
  #       f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile
  #       .rspec CHANGELOG.md CODE_OF_CONDUCT.md LICENSE.txt README.md Rakefile .rubocop.yml sig/flexipass.rbs
  #       flexipass.gemspec lib/flexipass.rb lib/flexipass/version.rb])
  #   end
  # end
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile
        .rspec CHANGELOG.md CODE_OF_CONDUCT.md LICENSE.txt README.md Rakefile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "faraday", "~> 1.0"
  spec.add_dependency "json", "~> 2.0"
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'webmock', '~> 3.23', '>= 3.23.1'
  spec.add_development_dependency 'debug', '~> 1.9', '>= 1.9.2'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
