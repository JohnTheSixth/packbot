**NOTE:** This Readme, like the Packbot app, is a work in progress.

# Contents

1. [About](#about)
1. [Deploy](#deploy)
1. [Register](#register)
1. [Configure](#configure)
1. [Authenticate](#authenticate)
1. [Sending Slash Commands](#sending-slash-commands)
	- [Formatting the Slash Command](#formatting-the-slash-command)
	- [Sending a Lone URL](#sending-a-lone-url)
	- [Sending a URL with Tags](#sending-a-url-with-tags)
1. [Slash Command Responses](#slash-command-responses)
	- [If Packbot Cannot Process the Command](#if-packbot-cannot-process-the-command)
	- [If Pocket Cannot Process the URL](#if-pocket-cannot-process-the-url)

# About

Packbot (Pocket + Slackbot...see what I did there?) is a web app designed to allow a Slack team to add URLs to a single Pocket account.

## Use Cases

A team of scholars are working together to research a paper. They have a Slack channel where they are posting links, but they want anything posted in this channel to be sent to Pocket for more permanent storage. They use Packbot to do this automatically.

An engineering team member posts links about training, tutorials, and resources for the rest of the team to use, and she encourages other members of the team to do the same. Packbot allows them to selectively add content to a designated Pocket account curated by a team member, without adding all the other `#engineering` channel clutter to Pocket at the same time.

## Who It's For

Anyone who has a Slack team and a Pocket account, and wants the ability to automatically export links from Slack to Pocket.

# Deploy

First, **make sure you clone the app locally or fork the app to your own repository**. If I decide to pull the app off GitHub, you don't want the version you're running to go kaput.

Then, deploy to Heroku using the Heroku toolbelt. Make sure you take note of the app's URL if you did not choose it. You'll need it later.

# Register

You will need to register your deployed app with Pocket, which will allow you to get a Pocket Consumer Key for your app.

# Configure

You will need to configure your environment variables on your deployed app. You can do this by using the Heroku toolbelt.

You will need to add two things to your `.env` file:

1. Your Slack team's Slack Token
2. The Pocket Consumer Key for your deployed app

# Authenticate

See the [Pocket API Docs](https://getpocket.com/developer/docs/authentication) for more information.

Before you can add any articles to your Pocket account via your app, you will need to authenticate the app with Pocket's servers. There is a UI built into Packbot that allows you to do this.

1. Go to the login page at `your-packbot-url.com/authenticate`.
2. Log in to the app *with your Pocket account login and password.*
3. The app will redirect you, letting you know that it is authenticating with Pocket.
4. You will see a success message, letting you know that the app is now authenticated with Pocket.

# Sending Slash Commands

Once your Packbot app is authenticated, and you've added the slash command functionality to your Slack app, you have a couple of different choices about how you can send URLs to Pocket.

## Formatting the Slash Command

Your slash command must include the following items exactly in this order:

- `/pack` - this command tells Slack what to do with your URL. This must be at the very beginning of the line.
- `http://some-url-here.com` - your URL *must* begin with `http` or `https`. Any other formatting will not add the URL. Your URL must also not contain any spaces. (Basically, just copy the URL from your browser's address bar...it should already conform to all the formatting rules.)
- `tag1, tags 2 and 3, tag 4` - a comma-delimited list of tags that comes after the URL. Spaces in tag names will be included when it is added to Pocket.

So, your final slash command will look like this:

```
/pack http://some-url-here.com tag1, tag 2 and 3, tag 4
```

You have a couple of options when it comes to sending your URL to Pocket.

### Sending a Lone URL

You can send a URL all by its lonesome, like so:

```
/pack http://www.politico.com/story/2016/10/john-podesta-wikileaks-hacked-emails-229304
```

This will add the URL to your Pocket account without any tags.

### Sending a URL with Tags

You can also add tags to your article by including them *after* your URL, separated by commas (spaces in between commas don't matter):

```
/pack http://www.politico.com/story/2016/10/john-podesta-wikileaks-hacked-emails-229304 politics, wikileaks, presidential election
```

A command in this format will add the tags "politics", "wikileaks", and "presidential election" to your article in Pocket.

# Slash Command Responses

After you submit slash command in Slack, if Packbot successfully adds the URL to Pocket, you will get the following message in Slack:

```
:thumbsup: Your URL has been added to Pocket! Here it is for Slack:
http://some-url-here.com
```

This way, your URL will be processed by Packbot, then posted in Slack.

If your URL is not successfully added to Pocket, there are one of two reasons for this.

## If Packbot Cannot Process the Command

If you submit a slash command that Packbot doesn't like - say, for example, it's missing `http` on the URL:

```
/pack www.some-url-here.com
```

Packbot will let you know right away that your command is not formatted correctly:

```
Check yo'self before you wreck yo'self. Something is wrong with your command.
```

If you're going to get an error, it would be better for it to be this one, since you can fix this easily.

## If Pocket Cannot Process the URL

If Pocket cannot process the URL you're sending, Packbot will respond with the HTTP status and associated error message. So, if you enter a properly formatted slash command:

```
/pack http://some-url-here.com
```

...but your app does not have the proper login credentials, the Pocket servers will return a HTTP 401 error:

```
/shrug Well, Pocket returned a 401 error. There was a problem authenticating the user.
```