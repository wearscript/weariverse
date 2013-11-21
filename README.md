# WearScript Contrib

So you want to share your scripts with other WearScript users? This is the repository to fork.

##Adding Your Script

1. Fork this repo.
2. Grab a copy of the latest WS template with `cp -r script-template scripts/awesome-new-script`
3. Edit manifest.json to taste. This is what we use to render your script listing. Includes are for additional javascript or image files that you want to be able to load from the WebView. Require tells the WS server that other scripts should also be installed on the user's Glass for everything to work happily.
4. For added coolness (and to possible qualify for our featured section), make sure you add some screenshots.
5. Add whatever tags you feel are appropriate, someday we might have a script search that uses them.
6. Submit a Pull Request. Someone on the WearScript team will review your script, help you get it signed if needed, and will categorize your script.

##Deploying

If you just need to get the latest copy on gh-pages, run `rake`. It will update the app metadata and then compile the site.

##Running locally

The site is powered via Middleman and is the standard configuration, with deployment on gh-pages.

1. Install gems needed with `bundle install`
2. Generate the app metadata `rake apps`
3. Run the local development server `middleman server`
4. Verify your changes
5. Deploy to gh-pages with `rake publish`
