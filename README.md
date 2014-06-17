# redmine_reminderz
[![Build Status](https://secure.travis-ci.org/pinzolo/redmine_reminderz.png)](http://travis-ci.org/pinzolo/redmine_reminderz)

Add extra filters for redmine reminders

## Installation

### 1. Clone to your Redmine's plugins directory:

```sh
$ git clone https://github.com/pinzolo/redmine_reminderz.git plugins/redmine_reminderz
```

### 2. Restart your Redmine:

```sh
# In case of using passenger
$ touch tmp/restart.txt
```

## Extra options

### redimine:reminderz task

About default options, see also redmine/lib/tasks/reminder.rake

* ratio_gt  => max done ratio (excludes value)
* ratio_gte => max done ratio (includes value)
* ratio_lt  => min done ratio (excludes value)
* ratio_lte => min done ratio (includes value)

