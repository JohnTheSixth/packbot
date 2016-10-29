This Readme is totally not done.

I've been following the Pocket API documentation [here](https://getpocket.com/developer/docs/authentication). Long story short, the API isn't built to make sending links from a third-party app easy.

Basically, the Pocket API expects that you will be adding/modifying/deleting your Pocket feed from within an app that supports session information (like something with a built-in browser), not a stateless app running on a server (like a Slackbot). So the process will involve a bit of hacking that needs to go like this:

1. Sign in to Pocket
2. Authorize the app (by clicking on a link from within the app, that sends the authentication information)
3. Approve the app
4. Then you can add things

As of right now, I've got step 1 down; step 2 requires a bit of extra front-end coding I haven't gotten to yet (maybe there's a better way we can manage it from the back-end; again, I haven't had a chance to figure it out.) Once the app is authenticated with the Pocket account and we've ironed out the best way to store current session information, the Slack code should be simple.

Message:
  `/pack [your url here]`

Action:
  send to Pocket

Response:
  Added to Pocket: {Article}
