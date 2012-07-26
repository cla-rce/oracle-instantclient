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

powershell "import certificate" do
  code <<-EOH
#requires -Version 2.0

function Import-Certificate
{
	param
	(
		[IO.FileInfo] $CertFile = $(throw "Paramerter -CertFile [System.IO.FileInfo] is required."),
		[string[]] $StoreNames = $(throw "Paramerter -StoreNames [System.String] is required."),
		[switch] $LocalMachine,
		[switch] $CurrentUser,
		[string] $CertPassword,
		[switch] $Verbose
	)
	
	begin
	{
		[void][System.Reflection.Assembly]::LoadWithPartialName("System.Security")
	}
	
	process 
	{
        if ($Verbose)
		{
            $VerbosePreference = 'Continue'
        }
    
		if (-not $LocalMachine -and -not $CurrentUser)
		{
			Write-Warning "One or both of the following parameters are required: '-LocalMachine' '-CurrentUser'. Skipping certificate '$CertFile'."
		}

		try
		{
			if ($_)
            {
                $certfile = $_
            }
            $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 $certfile,$CertPassword
		}
		catch
		{
			Write-Error ("Error importing '$certfile': $_ .") -ErrorAction:Continue
		}
			
		if ($cert -and $LocalMachine)
		{
			$StoreScope = "LocalMachine"
			$StoreNames | ForEach-Object {
				$StoreName = $_
				if (Test-Path "cert:\$StoreScope\$StoreName")
				{
					try
					{
						$store = New-Object System.Security.Cryptography.X509Certificates.X509Store $StoreName, $StoreScope
						$store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
						$store.Add($cert)
						$store.Close()
						Write-Verbose "Successfully added '$certfile' to 'cert:\$StoreScope\$StoreName'."
					}
					catch
					{
						Write-Error ("Error adding '$certfile' to 'cert:\$StoreScope\$StoreName': $_ .") -ErrorAction:Continue
					}
				}
				else
				{
					Write-Warning "Certificate store '$StoreName' does not exist. Skipping..."
				}
			}
		}
		
		if ($cert -and $CurrentUser)
		{
			$StoreScope = "CurrentUser"
			$StoreNames | ForEach-Object {
				$StoreName = $_
				if (Test-Path "cert:\$StoreScope\$StoreName")
				{
					try
					{
						$store = New-Object System.Security.Cryptography.X509Certificates.X509Store $StoreName, $StoreScope
						$store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
						$store.Add($cert)
						$store.Close()
						Write-Verbose "Successfully added '$certfile' to 'cert:\$StoreScope\$StoreName'."
					}
					catch
					{
						Write-Error ("Error adding '$certfile' to 'cert:\$StoreScope\$StoreName': $_ .") -ErrorAction:Continue
					}
				}
				else
				{
					Write-Warning "Certificate store '$StoreName' does not exist. Skipping..."
				}
			}
		}
	}
	
	end
	{ }
}
  Import-Certificate -Certfile #{node['cla_tsfarm']['cert_location']} -StoreNames My -LocalMachine
  ls cert:/LocalMachine/My
  EOH
  not_if "exit /b 1"
end
