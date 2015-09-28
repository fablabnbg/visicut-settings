Visicut settings
================

Settings for [VisiCut](https://github.com/t-oster/VisiCut) (A userfriendly tool to prepare, save and send Jobs to Lasercutters) used by Fab Lab Region Nuernberg e.V.

Instructions
------------

In newer versions of VisiCut you can select 'Germany, Nuremberg: Fab Lab Region Nürnberg, e.V.' from
```Options -> Settings -> Download Recommended Settings ...```

In older versions of VisiCut you can use the ```Download ZIP``` link, and rename the .zip extension to .vcsettings and then use the Archive with ```Options -> Settings -> Import Settings ...``` If that does not work, you have to repack the archive, so that there is no toplevel directory. 


Use the source
--------------

 * Delete all settings before you clone this repo:
    
    ```bash
    rm -rf ~/.visicut/
    ```

 * Clone the repo to .visicut:
    
    ```bash
    git clone git@github.com:fablabnbg/visicut-settings.git .visicut
    ```


 * To update the settings run:

    ```bash
    cd ~/.visicut
    git pull
    ```

 * Before you commit changes, please check the settings by running
    `git diff`
   and
    `git status`
  inside the repository. Check also, that the settings are working properly.

*  Then add and commit everything:
    
    ```bash
    git add -A
    git commit -A
    ```

