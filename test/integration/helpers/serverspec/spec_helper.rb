require 'serverspec'

set :backend, :exec
set :path, "/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:$PATH"
