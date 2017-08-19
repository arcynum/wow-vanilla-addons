# Package WoW Vanilla Addons.

## Information
This is a collection of addons packaged for easy download for vanilla wow.
Wherever possible the addons refer directly to their authors github respository.
Addionally, there is a deployement powershell script to relocate and configure the addons which require unpackaging.

## How to run.
All you need to do to run these items is download a copy of the repository (close or zip file).
Once you have downloaded, open up powershell and navigate to the addon directory.
Then run the following:
.\deploy.ps1 -wow "Wow directory"

For example:
.\deploy.ps1 -wow "C:\Users\USERNAME\Games\World of Warcraft"

## Caveats
Make sure you use quotes in the folder path.
I offer no support for anything to do with this repository or deployment. This was made for my own convenience, but im happy to share.
Any updates or fixes, open a ticket or send through a pull request.