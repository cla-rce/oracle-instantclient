require_relative "./spec_helper"

case os[:family]
when "redhat"
  packages = %w( unzip libaio )
  orahome = "/usr/local/instantclient_12_2"
  oravers = "12.2.0.1.0"

when "ubuntu"
  packages = %w( unzip libaio1 )
  if os[:release].to_f == 14.04
    orahome = "/usr/local/instantclient_11_2"
    oravers = "11.2.0.3.0"
  else
    orahome = "/usr/local/instantclient_12_2"
    oravers = "12.2.0.1.0"
  end

end

packages.each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

describe file("#{orahome}/SQLPLUS_README") do
  it { should be_owned_by "root" }
  it { should be_grouped_into "root" }
  it { should be_mode 664 }
  its(:content) { should match %r|#{oravers}| }
end

describe file("#{orahome}/JDBC_README") do
  it { should be_owned_by "root" }
  it { should be_grouped_into "root" }
  it { should be_mode 664 }
  its(:content) { should match %r|#{oravers}| }
end

# We run this via Bash to test whether the scripts we dropped in
# /etc/profile.d are working correctly
describe command("/bin/bash -lc 'echo | $ORACLE_HOME/sqlplus'") do
  its(:stdout) { should match %r|^SQL\*Plus: Release #{oravers}| }
end

if os[:family] == "ubuntu"
  describe command("/usr/bin/php --modules") do
    its(:stdout) { should match %r|^oci8$| }
  end
end
