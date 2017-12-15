#### Download the installer for your operating system
* New! [Windows Desktop and Workstation 10.10][win10.10]
* New! [Mac Desktop and Workstation 10.10][mac10.10]
* [Windows (MicroStrategy Desktop 10 and later)][win10]
* [Windows (MicroStrategy Desktop 9 and earlier)][win9]
* [Mac][mac]
* [Linux](linux)
* [AIX][aix]
* [SunOS][sunos]
* [Win9_220][win9220]



## Release notes
Each supported operating system has its own RScript Functions Installer which includes the pre-compiled R script functions, ready to be imported into MicroStrategy, with separate installers for use with MicroStrategy Desktop 10.

As the 2.2.001 changes are related to MicroStrategy 10.6+ enhancements, with details in ReadMe.txt, the AIX, SunOS, and Win9_220 installers here are the same as from 2.2.000, released September 15, 2016.

## MicroStrategy Desktop installation
#### Windows (64 bit)
The installer will be named RIntegrationPack64.msi. Once downloaded, execute the installer, following the instructions provided by the wizard. The default installation, which can be changed by the wizard, is:
```sh
C:\Program Files\R Integration Pack
```

#### Windows (32 bit)
The installer will be named RIntegrationPack.msi. Once downloaded, execute the installer, following the instructions provided by the wizard. The default installation, which can be changed by the wizard, is
```sh
C:\Program Files (x86)\R Integration Pack
```


#### Mac
The installer will be named R Integration Pack.pkg. Once downloaded, execute the installer, following the instructions provided by the wizard.
Installation will be performed within the MicroStrategy Desktop app, which by default is at 
```sh
/Applications/MicroStrategy Desktop.app
```


## Unix/Linux installation
For installation of Unix/Linux, the installer will be named RIntegrationPack_<OS>.tar.gz (where <OS> may be SunOS, AIX or Linux). Once downloaded, follow these instructions to install the RScript functions:
1. Unzip the file (e.g. gunzip RIntegrationPack<OS>.tar.gz_)
2. Extract the installation files (e.g. tar -xvf RIntegration<OS>.tar_)
3. Execute the installation wizard, using the command setup.sh
4. Follow the instructions provided by the wizard, including the specification of where R has been installed on the system


The default installation location is one of the following (this location can be altered via the wizard):
```sh
/var/opt/RIntegrationPack (for root user)
$HOME/RIntegrationPack (for non-root user)
```



[mac]: <https://github.com/MicroStrategy/RIntegrationPack/raw/master/installers/R%20Integration%20Pack.pkg>
[win9]: <https://github.com/MicroStrategy/RIntegrationPack/raw/master/installers/RIntegrationPack.msi>
[win10]: <https://github.com/MicroStrategy/RIntegrationPack/raw/master/installers/RIntegrationPack64.msi>
[aix]: <https://github.com/MicroStrategy/RIntegrationPack/raw/master/installers/RIntegrationPack_AIX.tar.gz>
[sunos]: <https://github.com/MicroStrategy/RIntegrationPack/raw/master/installers/RIntegrationPack_SunOS.tar.gz>
[win9220]: <https://github.com/MicroStrategy/RIntegrationPack/raw/master/installers/RIntegrationPack.msi>
[linux]: <https://github.com/MicroStrategy/RIntegrationPack/raw/master/installers/RIntegrationPack_Linux.tar.gz>
[win10.10]: <https://github.com/MicroStrategy/RIntegrationPack/raw/master/installers/RIntegrationPack64%20-%20Windows%2010.10.msi>
[mac10.10]: <https://github.com/MicroStrategy/RIntegrationPack/raw/master/installers/R%20Integration%20Pack%20-%20Mac%2010.10.pkg>
