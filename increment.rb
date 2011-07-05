#
## Author:: Johnlouis Petitbon (<jpetitbon@mdsol.com>)
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
#

require 'chef/knife'
 
module KnifeFlow
  class Increment < Chef::Knife
 
    deps do
      require 'chef/cookbook_loader'
      require 'chef/cookbook_uploader'
    end
 
    banner "knife increment COOKBOOK"

    WORKING_BRANCH = "develop"

    def run
     
      @cookbooks = parse_name_args!

      self.config = Chef::Config.merge!(config)
      
      if !config[:cookbook_path]
        raise ArgumentError, "Default cookbook_path is not specified in the knife.rb config file, and a value to -o is not provided. Nowhere to write the new cookbook to." 
      end
      
      if check_branch(WORKING_BRANCH)

        pull_branch(WORKING_BRANCH) 

        @cookbook_path = Array(config[:cookbook_path]).first
     
        @cookbooks.each do | book |
          metadata_file = File.join(@cookbook_path, book, "metadata.rb")

          # 1) increase version on the metadata file
          replace_version(find_version(book), increment_version(find_version(book)), metadata_file )
        
        end
      
        # 2) upload cookbooks to chef server
        cookbook_up = Chef::Knife::CookbookUpload.new
        cookbook_up.name_args = @cookbooks 
        cookbook_up.config[:freeze] = true
        cookbook_up.run  
        
        # 3) commit and push WORKING_BRANCH
        commit_and_push_branch(WORKING_BRANCH, "#{@cookbooks} have been incremented")
      
      end

    end
    
    def parse_name_args!
      if name_args.empty?
        ui.error("USAGE: knife increment COOKBOOK COOKBOOK COOKBOOK")
        exit 1
      else
        return name_args
      end
    end

    def commit_and_push_branch(branch, comment)
      print "--------------------------------- \n"
      system("git pull origin #{branch}") 
      system("git add .")
      system("git commit -am  '#{comment}'")
      system("git push origin #{branch}")
      print "--------------------------------- \n"
    end

    def pull_branch(name)
      print "--------------------------------- \n"
      system("git pull origin #{name}")
      print "--------------------------------- \n"
    end

    def check_branch(name)
      if (`git status` =~ /#{name}/) != nil
        return true
      else
        ui.error("USAGE: you must be in the #{name} branch")
        exit 1
      end
    end

    def find_version(name)
     loader = Chef::CookbookLoader.new(@cookbook_path)
     return loader[name].version
    end

    def increment_version(version)
     current_version = version.split(".").map{|i| i.to_i}
     current_version[2] = current_version[2] + 1
     return current_version.join('.')
    end

    def replace_version(search_string, replace_string, file)
      open_file = File.open(file, "r")
      body_of_file = open_file.read
      open_file.close
      body_of_file.gsub!(search_string, replace_string)
      File.open(file, "w") { |file| file << body_of_file }
    end

  end
end
