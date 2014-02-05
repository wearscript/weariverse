[![Stories in Ready](https://badge.waffle.io/openshades/weariverse.png?label=ready)](https://waffle.io/openshades/weariverse)  
# WearScript Contrib

So you want to share your scripts with other WearScript users? This is the repository to fork.

##Adding Your Script

###The Best Way
1. Put your script in a gist and add the gist ID to `gists.json`

###The Snazzy Way
To use our snazzy tools, you must have Ruby installed on your machine. Quickest method is RVM: `curl -sSL https://get.rvm.io | bash -s stable`
We also recomend you install hub, on OS X with brew, do `brew install hub`. On Linux, check your repositories. Worst case, `gem install hub`

0. Clone this repo with `hub clone OpenShades/weariverse`
1. Inside the repo, fork with `hub fork`
2. Run `bundle install`
3. Run `rake new[script-name-here]` and answer all of the questions
4. Edit manifest.json to taste. This is what we use to render your script listing. Includes are for additional javascript or image files that you want to be able to load from the WebView. Require tells the WS server that other scripts should also be installed on the user's Glass for everything to work happily.
5. For added coolness (and to possible qualify for our featured section), make sure you add some screenshots. You can take a screenshot with the command `adb shell screencap -p | perl -pe 's/\x0D\x0A/\x0A/g' > screen.png`
6. If you would like your script distributed also as an APK, run `rake compile[script-name-here]` to compile the APK. This requires a full android environment on your machine.
7. Once you are done writing your script and are ready to submit it, run `rake submit[script-name-here]`. This will make sure your local copy is fully rebased and commit your changes.
8. Submit a pull request, either via the GitHub website or of the format `hub pull-request -m "Script: YOUR_SCRIPT_NAME" -b origin:master -h YOUR_USERNAME:master`

###The Manual Way
1. Copy another script in the script directory and edit the manifest.json to taste.
2. Rebase against our repo, then commit and submit a pull-request.

##Compiling

1. `bundle install` if you haven't recently
2. `rake apps`
3. All app data is now in scripts.yml

##Syncing to S3

1. `bundle install` if you haven't recently
2. Make sure your credentials are environmental variables at `AWS_ID` and `AWS_SECRET`
3. `rake`
