#! /bin/sh

if [ $TARGET = "redmine" ]; then
  # Setup scms
  sudo apt-get update -qq
  sudo apt-get --no-install-recommends install bzr cvs git mercurial subversion
fi

PLUGIN_NAME="redmine_reminderz"

# Get & deploy Redmine
wget http://www.redmine.org/releases/redmine-${REDMINE_VERSION}.tar.gz
tar xf redmine-${REDMINE_VERSION}.tar.gz

# Copy plugin files to plugin directory
mkdir redmine-${REDMINE_VERSION}/plugins/${PLUGIN_NAME}
mv config   redmine-${REDMINE_VERSION}/plugins/${PLUGIN_NAME}/config
mv lib      redmine-${REDMINE_VERSION}/plugins/${PLUGIN_NAME}/lib
mv test     redmine-${REDMINE_VERSION}/plugins/${PLUGIN_NAME}/test
mv init.rb  redmine-${REDMINE_VERSION}/plugins/${PLUGIN_NAME}/init.rb

# Create necessary files
cat > redmine-${REDMINE_VERSION}/config/database.yml <<_EOS_
test:
  adapter: sqlite3
  database: db/redmine_test.db
_EOS_

# All move to work directory
mv redmine-${REDMINE_VERSION}/* .

