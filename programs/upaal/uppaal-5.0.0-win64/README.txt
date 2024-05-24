README for UPPAAL Stratego 5.0.0, June 2023 
Copyright (c) 2011 - 2023. Aalborg University.
Copyright (c) 1995 - 2010. Uppsala University and Aalborg University.

June 21, 2023

1. Introduction
2. Installation
3. Bugs, issues, feature requests
4. Changelog

1. Introduction
===============

This is a distribution of UPPAAL toolsuite -- a model checker which combines the following:
* Symbolic analysis (zone based exhaustive reachability exploration),
* Statistical model-checking (SMC based on concrete simulations),
* Strategy synthesis using Timed games (TIGA queries with strategy assignment)
* Performance optimization using statistical learning (min/max-imization queries with strategy assignemnt)
* Strategy refinemnent via learning (queries under strategy)
* Strategy evaluation via Symbolic analysis and SMC (queries under strategy)

The Uppaal toolkit is free for non-commercial applications for academic institutions that deliver academic degrees.
As academic use, we consider only work performed by researchers or students at institutions delivering academic degrees.
In addition, the work or the worker may not be contracted by any non-academic institution.
Any other use requires a license, see uppaal.org for commercial lincensing.

This product includes software developed by the Apache Software
Foundation (http://www.apache.org/).

2. Installation
===============

To install, unzip the zip-file uppaal-5.0.0. This should create
the directory uppaal-5.0.0 containing at least the files uppaal,
uppaal.jar, and the directories lib, bin, lib, fonts, res and demo.
The bin contains the verifyta(.exe) and server(.exe) executable engine files and libraries.
The demo contains demonstration model files with suffixes .xml and .q.

The graphical interface requires Java Runtime Environment (JRE) version >= 11.
OpenJDK Java can be downloaded and installed from https://adoptium.net/ .
During OpenJDK installation, we recommend to include JavaSoft registry entries and
associations with jar files to improve the desktop integration.

Linux:
* Launch the uppaal script, or run `java -jar uppaal.jar` on command line
* Launch AddLinks.sh to install Desktop shortcuts and launch Uppaal from Start menu

Windows:
* Launch by double clicking the uppaal.jar file, or run `java -jar uppaal.jar` on command line
* Launch AddLinks.vbs to install Desktop shortcuts and run Uppaal from Start menu

MacOS:
* Remove quarantine attribute: `xattr -r -d com.apple.quarantine uppaal-5.0.0`.
* Move the UPPAAL-5.0.0.app to Applications and launch it from there.
* Alternatively, launch uppaal script, or run `java -jar uppaal.jar` from command line.

3. Bugs, Issues, Feature Requests, Discussions
==============================================
Please use the meta-repository to file bug reports and discuss features:
https://github.com/UPPAALModelChecker/UPPAAL-Meta

More contacts and mailing lists:
https://uppaal.org/contact/

Known Issues in this release:
* Simulation query uses the new syntax where the number of runs is inside the bound brackets:
  `simulate [<=10; 5] { x, y, z }`

4. Changelog
====================
You can see the full changelog at https://uppaal.org/changelog/#uppaal
