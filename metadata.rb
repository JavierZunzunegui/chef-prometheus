name             'prometheus'
maintainer       'Elijah Wright'
maintainer_email 'elijah.wright@gmail.com'
license          'Apache 2.0'
description      'Installs/Configures Prometheus'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.6.3'
source_url 'https://github.com/elijah/chef-prometheus' if respond_to?(:source_url)
issues_url 'https://github.com/elijah/chef-prometheus/issues' if respond_to?(:issues_url)

%w(ubuntu debian centos redhat fedora).each do |os|
  supports os
end

depends 'apt', '= 3.0.0' # any higher requires chef 12
depends 'yum'
depends 'build-essential'
depends 'runit', '~> 1.5'
depends 'bluepill', '~> 2.3'
depends 'accumulator'
depends 'ark'
depends 'golang'
