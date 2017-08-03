## Supported and Tested On :
- [x] CentOs 7

###  Scripts and their Usage :
| Script | Usage |
|-----|----|
|set_googlevm.sh|setup gcloud server using centos7/ubuntu on the fly ***(make sure to change the project_name variable accordingly i.e two projects can't have same name.)*** |
|get_set_xrdp.sh| Installs and setup's the desktop-envirnment, xrdp, browser, *|
|set_browser.sh| Setup's the browser to be auto-launched when the given user login's.|
|macro.sh|  Can find a way in any browser to keep on doing some activity on the website, like clicking links, opening links, closing tabs, refreshing the page after every 5 mins, etc|
|manager.sh|Manges all other scripts (i.e download them from net set's them up , and other script can be called from this script.).This script is recommended to be used. as it makes sure the other script are always up-to-date. ***(u only need to download this script other script will be downloaded automatically onces you execute this script.)*** |

***(get_set_xrdp.sh, set_browser.sh can be runned individually,  but its recommended to make them run under manager.sh with there respective option.)***


# How to use the scrips.
----------------------
## Executing script's individually.

## get_set_xrdp.sh :
Installs and setup’s the desktop-envirnment, xrdp, browser, *
```sh
# should be run under root privilages
$ sudo bash get_set_xrdp.sh 
```
## set_browser.sh :	
Setup’s the browser to be auto-launched when the given user login’s.
```sh
# set default to google-chrome.
$ bash set_browser.sh chrome

# set default to firefox
$ bash set_browser.sh firefox
```
----------------------
## macro.sh :
Can find a way in any browser to keep on doing some activity on the website, like clicking links, opening links, closing tabs, refreshing the page after every 5 mins, etc ***( website used for testing gmail).***
>This script should be run by the user after he login and opens the browser and website in the machine.(make sure the browser is in foreground and maximized.)

#### open the terminal and execute the script.
```sh
# minimize the terminal now.
# it will start executing after a specified interval (5m).
$ bash macro.sh
```

----------------------
----------------------
## Executing Other script's under manager.sh.
## manager.sh : 
Manages all other scripts (i.e download them from net sets them up , and other script can be called from this script.).This script is recommended to be used. as it makes sure the other script are always up-to-date.

##### Command line arguments and there use.
(by default downloads and setup's the other scripts)
- -init_setup  : sets up the xrdp server and stuff.
- -browser <browser_name> : sets the browser to be launced at login for the given user.(supported browsers are mention in the script.)
- -help : shows the help option for the script.

### EG:
>every time this script is run the other scripts are downloaded and updated automatically.

##### How to install and setup the xrdp, desktop, browser, * ***(should be run under root privilege.)***
.
```sh
# -init_setup option.
$ sudo bash manager.sh -init_setup
```
##### How to setup a given browser to auto-lauch at login .
```sh
# -browser option.

# set default to google-chrome.
$ bash manager.sh -browser chrome

# set default to firefox
$ bash manager.sh -browser firefox
```

