if platform?("debian","ubuntu")
  package "php-xsl" do
    package_name "php5-xsl"
    action :install
  end
end