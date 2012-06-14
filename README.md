This is an quickstart based on the Dart Language[1] released by Google. This quickstart uses the OpenShift PaaS platform and the Do-It-Yourself cartridge to host the application.

This is extremly experimental code. The Dart language and APIs are still evolving so this quickstart does not include the latest binaries.

Rebuilding Dart binaries
-----------------------------

You can follow the following process to compile your own dart binaries from latest sources.
Make sure to compile the binary on the platform you want to run this application on.

Fedora 16 Instructions (based of Dart compilation instructions[2]):
1. Install build dependencies:

```sh
    su -c 'yum install subversion pkgconfig python perl gcc-c++ bison \
    flex gperf nss-devel nspr-devel gtk2-devel glib2-devel freetype-devel \
    atk-devel pango-devel cairo-devel fontconfig-devel GConf2-devel \
    dbus-devel alsa-lib-devel libX11-devel expat-devel bzip2-devel \
    dbus-glib-devel elfutils-libelf-devel libjpeg-devel \
    mesa-libGLU-devel libXScrnSaver-devel \
    libgnome-keyring-devel cups-devel libXtst-devel libXt-devel pam-devel'
```

2. Dart uses the same non-standard build chain as Chromiuim. Download the tools and add them to your path:
 
```sh
    mkdir -p depot_tools
    pushd depot_tools
    svn co http://src.chromium.org/svn/trunk/tools/depot_tools
    export PATH=$PATH:`pwd`//depot_tools
    popd
```

3. Download and compile Dart sources.

```sh
    mkdir dart
    pushd dart
    gclient config http://dart.googlecode.com/svn/trunk/deps/standalone.deps
    gclient sync
    cd runtime
    ../tools/build.py --arch=x64 -m release
    echo "Dart binaries available at: `pwd`/out/ReleaseX64/dart"
    popd
```

Running on OpenShift
----------------------------

Create an account at http://openshift.redhat.com/

Create a diy-0.1 application (you can call your application whatever you want)

    rhc app create -a dart -t diy-0.1

Add this upstream Dart example repo

    cd dart 
    git remote add upstream -m master git://github.com/kraman/dart-example.git
    git pull -s recursive -X theirs upstream master
    # note that the git pull above can be used later to pull updates to the Dart quick-start
    
Then push the repo upstream

    git push

That's it, you can now checkout your application at:

    https://dart-$yournamespace.rhcloud.com  (Hosted on OpenShift)

or

    https://dart-$yournamespace.example.com  (Hosted on OpenShift Origin)


NOTES:

GIT_ROOT/.openshift/action_hooks/deploy:
    This script is executed with every 'git push'.  Feel free to modify this script
    to learn how to use it to your advantage.  By default, this script will create
    the database tables that this example uses.

References
----------------------------

[1] http://www.dartlang.org/

[2] http://code.google.com/p/dart/wiki/Building#Building_the_standalone_VM

[3] Dart license: http://code.google.com/p/dart/source/browse/branches/bleeding_edge/LICENSE
