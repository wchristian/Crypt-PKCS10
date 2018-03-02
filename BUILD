To build a distribution kit:

Clone the git repository & cd to it

Make any changes.

Make sure any executables are marked properly in the index:
  git update-index --chmod +x file

Make sure any binary or special line-ending files are on .gitignore

Commit any changes.

Install Dist::Zilla from CPAN (has many dependencies, takes a LONG time)
Install Dist::Zilla::Plugin::CopyFilesFromBuild
Install Dist::Zilla::Plugin::MakeMaker::Awesome
Install Dist::Zilla::Plugin::MetaProvides::Package
Install Dist::Zilla::Plugin::MinimumPerl
Install Dist::Zilla::Plugin::Run
Install Dist::Zilla::Plugin::Signature # If you plan to sign your distributions.
                                       # Otherwise, comment-out the [Signature] in dist.ini
Install Pod::Readme

Update the version number in lib/Crypt/PKCS10.pm (and Changes)
Make any README changes in lib/Crypt/PKCS10.pm
Update copyrights.

Update Changes

Managing buid with Minilla:

    minil test     - run test cases
    minil dist      - make your dist tarball
    minil install   - install your dist
    minil release   - release your dist to CPAN

