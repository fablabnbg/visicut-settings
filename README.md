Visicut settings
================

Settings for [VisiCut](https://github.com/t-oster/VisiCut) (A userfriendly tool to prepare, save and send Jobs to Lasercutters) used by Fab Lab Region Nuernberg e.V.

Instructions
------------

In newer versions of VisiCut you can select 'Germany, Nuremberg: Fab Lab Region Nürnberg, e.V.' from
```Options -> Settings -> Download Recommended Settings ...```


Warnings
--------

These settings define the lasercutters. Materials found here are outdated and may or may not work. Please refer to 

 * https://wiki.fablab-nuernberg.de/w/Nova_35#Notwendige_Einstellungen
 * https://wiki.fablab-nuernberg.de/w/ZING_4030#Schneiden:_CUT_-_.28.22Rote_Linie.22.29

It is not possible to merge changes when you load these settings. Everything you edited is silently overwritten or discarded

The data format here is very strict XML. The correct dtd is unknown.

Migrating from one version to another version of visicut fails, if the format changes. 

Adding new settings here (or re-adding old broken settings) is only possible through the visicut gui. Use patience when doing so.


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

