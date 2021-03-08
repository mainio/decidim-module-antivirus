# Decidim::Antivirus

[![Build Status](https://github.com/mainio/decidim-module-antivirus/actions/workflows/ci_antivirus.yml/badge.svg)](https://github.com/mainio/decidim-module-antivirus/actions)
[![codecov](https://codecov.io/gh/mainio/decidim-module-antivirus/branch/master/graph/badge.svg)](https://codecov.io/gh/mainio/decidim-module-antivirus)

A [Decidim](https://github.com/decidim/decidim) module to add antivirus checks
as validations for Decidim's public file uploads, e.g. for proposals.

![Decidim Antivirus](sample.png)

The antivirus checks are done through ClamAV using
[Clamby](https://github.com/kobaltz/clamby).

The antivirus validation is handled by
[Ratonvirus](https://github.com/mainio/ratonvirus).

The gem has been developed by [Mainio Tech](https://www.mainiotech.fi/).

The development has been sponsored by the
[City of Helsinki](https://www.hel.fi/).

## Prerequisites

You need to have ClamAV installed on the target machine for the antivirus checks
to actually work. With the default configuration, you will also need the ClamAV
daemon installed in order to make the antivirus checks more efficient.

Check ClamAV installation and configuration instructions from:

https://github.com/mainio/ratonvirus-clamby

## Installation

Add this line to your application's Gemfile:

```ruby
gem "decidim-antivirus"
```

And then execute:

```bash
$ bundle
```

After installation, test that the gem is loaded properly in your environment and
it can run the ClamAV executable:

```bash
$ bundle exec rails ratonvirus:test
```

This command should show the following message when correctly installed:

```
Ratonvirus correctly configured.
```

## Usage

This gem provides a new validator named `AntivirusValidator` which can be used
to attach antivirus checks to any CarrierWave connected file attributes.

This is automatically added to the Decidim's own `Decidim::Attachment` model to
check any files that the users upload as attachments to any records, e.g.
proposals.

If this is all you need, you are all set after installing this gem.

NOTE:

The custom validator is applied automatically only if you have configured the
ClamAV daemon correctly for checking the files. In case the ClamAV executable
`clamdscan` is not available on the target machine, this gem does nothing.

### Testing from the UI

In order to test that the functionality is working correctly, follow these
steps:

1. Create an [EICAR test file](https://en.wikipedia.org/wiki/EICAR_test_file)
   with one of the Decidim's supported files extensions (e.g. `.pdf`).
1. Install Decidim with this gem and create the development app. In case you
   have an existing instance.
1. Run the development server `bundle exec rails s`.
1. Add the Proposals component to one of your participatory spaces and enable
   attachments for the component and proposal creation for the active step.
1. Go to the component URL and create a new proposal. Define the EICAR test file
   in the attachement's file field in the final "complete" step.
1. Try posting the Proposal form.

In case the validator is working correctly, you should see an error saving the
proposal and when you scroll the page down, you should also see the following
validation error in the file field:

> File contains a virus

### Adding antivirus checks to custom models

In case you want to attach any other models to the `AntivirusValidator`, it is
also possible. For example, if you have the following type of model locally in
your installation:

```ruby
class CustomModel < Decidim::ApplicationRecord
  validates :image, :content_type, presence: true
  mount_uploader :image, Decidim::AttachmentUploader
end
```

You can apply the `AntiVirusValidator` to that model by adding the following
line to the class:

```ruby
  validates :image, antivirus: true
```

## Contributing

See [Decidim](https://github.com/decidim/decidim).

### Testing

To run the tests run the following in the gem development path:

```bash
$ bundle
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rake test_app
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rspec
```

Note that the database user has to have rights to create and drop a database in
order to create the dummy test app database.

In case you are using [rbenv](https://github.com/rbenv/rbenv) and have the
[rbenv-vars](https://github.com/rbenv/rbenv-vars) plugin installed for it, you
can add these environment variables to the root directory of the project in a
file named `.rbenv-vars`. In this case, you can omit defining these in the
commands shown above.

### Test code coverage

If you want to generate the code coverage report for the tests, you can use
the `SIMPLECOV=1` environment variable in the rspec command as follows:

```bash
$ SIMPLECOV=1 bundle exec rspec
```

This will generate a folder named `coverage` in the project root which contains
the code coverage report.

## License

See [LICENSE-AGPLv3.txt](LICENSE-AGPLv3.txt).
