### 3.0.0 /2020-01-17

- Updated asset conventions to match SIMP 6.4.0-0
- Added static Travis CI pipeline
- Added module's Travis checks to `rake test` suite
- Added Rakefile env var workaround (`MODULE_CMD_PUPPET_VERSION`) to test
  Puppet 6 modules while using an older Puppet version to run `puppet module`
- Module CHANGELOG is now templated to fill in the correct timestamp and version
- Added top-level CHANGELOG.md
