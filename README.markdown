knife-flow 
========
A collection of Chef plugins for managing the migration of cookbooks to environments in different Opscode organizations.
The main reason for having a workflow around the development and promotion of cookbooks is to ensure quality, reliability and administrative security of the process.  

Requirements
---------------
Right now knife-flow is build with many assumptions:

* The knife-flow assumes you have at least 2 orgs; one for "development" and one for "production".
* The "development" org has one environment called "candidate".
* The "production" org has an "innovate" and a "production" environment.
* You are using git flow [http://jeffkreeftmeijer.com/2010/why-arent-you-using-git-flow/](http://jeffkreeftmeijer.com/2010/why-arent-you-using-git-flow/) for your chef-repo project.

Installing knife-flow
-------------------
Be sure you are running the latest version Chef.

Map the "development" org to the knife.rb file, and map the "production" org to a knife-production.rb file.

Copy the increment.rb, promote.rb and release.rb files to the <tt>chef-repo/.chef/knife/plugins</tt> directory.

Plugins
---------------

### increment
Increments the cookbooks version by 1 digit at the patch level (i.e. 2.3.1 -> 2.3.2 ) <br />
Uploads the cookbook by running <tt> knife cookbook upload COOKBOOK COOKBOOK </tt> <br />
Commits the changes to the "develop" branch <br />


    $ knife increment COOKBOOK1 COOKBOOK2 ... 


This plugin is useful when working on the projects in the "sandbox" stage. The "_default" environment will always load the latest versions of the cookbooks.


### promote
Increments the cookbooks version by 1 digit at the patch level ( i.e. 2.3.1 -> 2.3.2 ) <br />
Uploads the cookbook by running <tt> knife cookbook upload COOKBOOK COOKBOOK </tt> <br />
Updates the environments/ENVIRONMENT.json file with the list of COOKBOOK1 COOKBOOK2 and relative new versions. <br />
Uploads the ENVIRONMENT.json file to the "development" org. <br />
Commits the changes to the "develop" branch. <br />


    $ knife promote  ENVIRONMENT(i.e. candidate) COOKBOOK COOKBOOK ...


This plugin is useful when working on the projects in the "validation" and "performance" stage. The "candidate" environment will be used to validate the cookbooks versions.


### release
Copies the "candidate" environment cookbook list and transfer them to the ENVIRONMENT in the "production" org. <br />
Commits all changes and creates a release tag TAG using the <tt> git flow release start/finish TAG </tt>. <br />
Uploads all cookbooks to the "production" org. <br />

    $ knife release ENVIRONMENT(i.e. innovate or production) TAG(i.e. 2011.2.3)

This plugin is useful when we are ready to migrate the cookbooks to the environments in the "production" org.

License terms
-------------
Authors:: Johnlouis Petitbon, Jacob Zimmerman, Aaron Suggs 

Copyright:: Copyright (c) 2009-2011 Medidata Solutioins Worldwide, Inc.

License:: Apache License, Version 2.0


Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

