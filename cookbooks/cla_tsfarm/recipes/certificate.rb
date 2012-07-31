#
# Cookbook Name:: cla_tsfarm
# Recipe:: certificate
#
# Copyright 2012, Adam Mielke, (C) Regents of the University of Minnesota
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

execute "Import certificate" do
  command "certutil -p \"testing\" -importpfx \"#{node['cla_tsfarm']['cert_location']}\""
  not_if { Registry.key_exists?("HKLM\\SOFTWARE\\Microsoft\\SystemCertificates\\my\\Certificates\\#{node['cla_tsfarm']['cert_thumbprint']}") }
  action :run
end

powershell "Set RDS certificate" do
  code <<-EOH
  Import-Module RemoteDesktopServices
  $CurrentCert = (Get-Item RDS:/RDSConfiguration/Connections/RDP-Tcp/SecuritySettings/SSLCertificateSHA1Hash).CurrentValue
  if ($CurrentCert -ne "#{node['cla_tsfarm']['cert_thumbprint']}") {
    Set-Item RDS:/RDSConfiguration/Connections/RDP-Tcp/SecuritySettings/SSLCertificateSHA1Hash #{node['cla_tsfarm']['cert_thumbprint']}
  }
  EOH
end
