# WearScript Contrib

So you want to share your scripts with other WearScript users? This is the repository to fork.

##Adding Your Script

1. Fork this repo.
2. Run `bundle install`
3. Run `rake new` and answer all of the questions
4. Edit manifest.json to taste. This is what we use to render your script listing. Includes are for additional javascript or image files that you want to be able to load from the WebView. Require tells the WS server that other scripts should also be installed on the user's Glass for everything to work happily.
5. For added coolness (and to possible qualify for our featured section), make sure you add some screenshots.
6. Submit a Pull Request. Someone on the WearScript team will review your script, help you get it signed if needed, and will categorize your script.

##Compiling

Running `rake apps` will generate `scripts.yml` which can then be copied over to the site builder and used to update it.

##Syncing to S3

Running `rake` will rebuild the YAML and sync all `index.html` files to the S3 bucket.
