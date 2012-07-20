## Knife plugin to set node environment
# See http://wiki.opscode.com/display/chef/Environments
#
## Install
# Place in .chef/plugins/knife/set_environment.rb
#
## Usage
# Nick-Stielaus-MacBook-Pro:chef-repo nstielau$ knife node set_environment mynode.net my_env
# Looking for mynode.net
# Setting environment to my_env
# 1 items found
# 
# Node Name:   mynode.net
# Environment: my_env
# FQDN:        mynode.net
# IP:          66.111.39.46
# Run List:    role[base], role[web_app]
# Roles:       base, web_app
# Recipes      timezone::default, hosts::default, sudo::default, web_app::default
# Platform:    ubuntu 10.04


require 'chef/knife'

module SomeNamespace
  class NodeSetEnvironment < Chef::Knife

    deps do
      require 'chef/search/query'
      require 'chef/knife/search'
    end

    banner "knife node set_environment NODE ENVIRONMENT"

    def run
      unless @node_name = name_args[0]
        ui.error "You need to specify a node"
        exit 1
      end

      unless @environment = name_args[1]
        ui.error "You need to specify an environment"
        exit 1
      end

      puts "Looking for #{@node_name}"

      searcher = Chef::Search::Query.new
      result = searcher.search(:node, "name:#{@node_name}")

      knife_search = Chef::Knife::Search.new
      node = result.first.first
      if node.nil?
        puts "Could not find a node named #{@node_name}"
        exit 1
      end

      puts "Setting environment to #{@environment}"
      node.chef_environment(@environment)
      node.save

      knife_search = Chef::Knife::Search.new
      knife_search.name_args = ['node', "name:#{@node_name}"]
      knife_search.run

    end
  end
end
