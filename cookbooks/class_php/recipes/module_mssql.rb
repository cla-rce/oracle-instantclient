#include_recipe "freetds"

package "php-mssql" do
  case node[:platform]
  when "debian","ubuntu"
    package_name "php5-sybase"
  when "centos","redhat","fedora","suse","scientific"
    package_name "php-mssql"
  end
  action :install
end
