# feature flags

Allows us to easily bring in Modules at runtime.

This will make it safe to deploy stuff to production and then turn it on as needed.


a great explanation of why and how.
https://github.com/launchdarkly/featureflags?files=1



1. Tags in git
- master, dev, stable.

2. Server to model and push the flag changes to servers and flutter apps
https://github.com/vsco/dcdr
- this is abstract and so we cna map feature tags to User groups or really anything.

3. deploy to web and app stores 3 versions that match the tags

