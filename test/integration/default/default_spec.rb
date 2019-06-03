case os[:family]
when "redhat"
  packages = %w( unzip libaio )
  orahome = "/usr/local/instantclient_12_2"
  oravers = "12.2.0.1.0"

when "debian"
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

%w( JDBC_README sdk/SDK_README ).each do |filename|
  describe file("#{orahome}/#{filename}") do
    it { should be_owned_by "root" }
    it { should be_grouped_into "root" }
    it { should be_mode 0664 }
    its(:content) { should match %r|#{oravers}| }
  end
end

if os[:family] == "ubuntu"
  describe command("/usr/bin/php --modules") do
    its(:stdout) { should match %r|^oci8$| }
  end
end

# We run these commands via Bash to test whether the scripts we dropped in
# /etc/profile.d are working correctly, in addition to testing whether the
# executables were unpacked correctly

describe command("/bin/bash -lc 'echo | $ORACLE_HOME/sqlplus'") do
  its(:stdout) { should match %r|^SQL\*Plus: Release #{oravers}| }
end

if oravers.to_i >= 12
  describe command("/bin/bash -lc '$ORACLE_HOME/sqlldr --foo'") do
    its(:stderr) { should match %r|^SQL\*Loader: Release #{oravers}| }
  end
end
