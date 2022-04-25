default["oracle_instantclient"]["download_base"] = "http://leviticus.claoit.umn.edu/oracle/instantclient"
default["oracle_instantclient"]["install_dir"] = "/usr/local"

default["oracle_instantclient"]["client_version"] = "12.2.0.1.0"
default["oracle_instantclient"]["client_dir_name"] = "instantclient_12_2"
default["oracle_instantclient"]["php_pecl_package"] = "oci8"

if platform?("ubuntu") && node["platform_version"].to_f <= 20.04
  # oci8-2.2.0 is the final version for PHP 7
  default["oracle_instantclient"]["php_pecl_package"] = "oci8-2.2.0"
end

if platform?("ubuntu") && node["platform_version"].to_f == 14.04
  default["oracle_instantclient"]["client_version"] = "11.2.0.3.0"
  default["oracle_instantclient"]["client_dir_name"] = "instantclient_11_2"
  # oci8-2.0.10 is the final version for PHP 5
  default["oracle_instantclient"]["php_pecl_package"] = "oci8-2.0.10"
end

if platform?("redhat", "centos") && node["platform_version"].to_i <= 7
  # oci8-2.0.10 is the final version for PHP 5
  default["oracle_instantclient"]["php_pecl_package"] = "oci8-2.0.10"
end
