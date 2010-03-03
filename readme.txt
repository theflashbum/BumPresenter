BumPresenter


** Quick Start Guide **

The fastest way to get BumPresenter up and running is to use the packaged ANT Build.

1) Copy build.properties.template file and rename it to build.properties.

2) Change the path for FLEX_HOME to where your Flex 3/4 SDK is.

3) Run the default build target compile-swf

Once to do a build, ANT will copy over all the default files such as the index.html page, swfs, images, and css folders
to the bin directory.


** Auto Launching BumPresenter through Ant **

This has been configured to work on a Mac so you may have to modify the Ant build to work on a PC

1) Modify the browser you use for testing in the build.properties file on line 19

2) Run the local-test target

When compiling is done, Ant will automatically open up your browser and point it to the bin/index.html


** Local Testing **

When testing locally Flash will complain about security warnings. You can ignore this or run the bin folder form a local
apache server.


** Library Linkages **

BumPresenter depends on several open source libraries to run. All of these swcs have been bundled with the checkout. You
can find them in build/libs. If you are modifying code in an IDE you may want to link this folder up so you can get code
hinting. The Ant build automatically looks at this directory to do a compile. Likewise you can add any additional code to
this folder that your project may depend on.

BumPresenter is build on top of the BumEngine (http://github.com/theflashbum/BumEngine). The latest build of this library
is part of the build/libs directory but if you want to modify the core engine you can always get the source code from
github.


** Building a new presentation **

1) Create a new XML file in build/bin-resources/xml/locations (BumEngine was based on locations but this may change in
future builds of the presenter).

2) This is the base structure of a presentation:


<?xml version="1.0"?>
<containers layout="ConnectFourLayout" random="false" bendOverride="true" defaultContainer="1">

</containers>

There are several layout types you can use. Right now only ConnectFourLayout and HorizontalLayout are included in this
build. You can make your own layouts (more on this later).

3) You now have to add a container inside of the <containers ...> </containers> node:

<container class="ImageContainer" id="2" title="Slide 2" w="1024" h="768" src="images/intro/intro.002.jpg"/>

There are several container types. Here are examples for each:

<container class="ImageContainer" id="2" title="Slide 2" w="1024" h="768" src="images/intro/intro.002.jpg"/>
<container class="VideoImageContainer" id="2" title="Video Container" w="640" h="480" src="videos/trailer_640x480.jpg" vsrc="../videos/trailer.mp4"/>

(More container are coming soon)


4) You much change the "defaultLocation" var in the src/BumPresenter.as class on line 34 to the name of the XML location
you created in step 1.

5) Add as many containers as you need then run the build to see it work.