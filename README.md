# SIMP puppet module skeleton
[![Build Status](https://travis-ci.org/simp/puppet-module-skeleton.svg?branch=master)](https://travis-ci.org/simp/puppet-module-skeleton)


This is a very opinionated Puppet module skeleton, forked from the fantastic [garethr/puppet-module-skeleton](https://github.com/garethr/puppet-module-skeleton).  It provides a template for the `puppet module generate` tool to generate new modules targeted toward inclusion with [SIMP](https://github.com/NationalSecurityAgency/SIMP), a compliance-management framework built on Puppet.

## Installation

As a feature, `puppet module generate` will use the path defined in the Puppet config item `module_skeleton_dir` as a template (**NOTE:** In the examples below `~/.puppet/var/puppet-module/skeleton` is used; this not universal and you should double-check your local settings before installing).

As we don't want to have this repository's .git files and README in our new modules, we install the skeleton like this:

    git clone https://github.com/garethr/puppet-module-skeleton
    cd puppet-module-skeleton
    find skeleton -type f | git checkout-index --stdin --force --prefix="$HOME/.puppet/var/puppet-module/" --

## Usage

Now, just generate your new module structure like so:

    puppet module generate user-module

Once you have your module then install the development dependencies:

    cd user-module
    bundle install

Now you should have a bunch of rake commands to help with your module
development:

    bundle exec rake -T
    rake acceptance        # Run acceptance tests
    rake build             # Build puppet module package
    rake clean             # Clean a built module package
    rake contributors      # Populate CONTRIBUTORS file
    rake coverage          # Generate code coverage information
    rake help              # Display the list of available rake tasks
    rake lint              # Check puppet manifests with puppet-lint / Run puppet-lint
    rake spec              # Run spec tests in a clean fixtures directory
    rake spec_clean        # Clean up the fixtures directory
    rake spec_prep         # Create the fixtures directory
    rake spec_standalone   # Run spec tests on an existing fixtures directory
    rake syntax            # Syntax check Puppet manifests and templates
    rake syntax:manifests  # Syntax check Puppet manifests
    rake syntax:templates  # Syntax check Puppet templates

Of particular interst should be:

* `rake spec` - run unit tests
* `rake lint` - checks against the puppet style guide
* `rake syntax` - to check your have valid puppet and erb syntax

## Thanks

- This module was forked from the [garethr/puppet-module-skeleton](https://github.com/garethr/puppet-module-skeleton).

- The trick used in the installation above, and a few other bits came from
another excellent module skeleton from [spiette](https://github.com/spiette/puppet-module-skeleton).
