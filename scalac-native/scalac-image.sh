#!/bin/sh

[ -z "$GRAALVM_HOME" ] && echo "GRAALVM_HOME is currently not set. This script will not work." && exit 1
[ ! -f "$GRAALVM_HOME/bin/native-image" ] && echo "Can't find native-image in $GRAALVM_HOME. Check that the directory is valid." && exit 1
[ -z "$SCALA_HOME" ] && echo "SCALA_HOME is currently not set. This script will not work." && exit 1
SCALA_LIB="$SCALA_HOME/lib"
if [ -d "$SCALA_HOME/libexec" ]; then
   SCALA_LIB="$SCALA_HOME/libexec/lib"
fi
[ ! -d "$SCALA_LIB" ] && echo "Can't find jars in $SCALA_LIB. Check that the Scala instalation is correct." && exit 1
for filename in $SCALA_LIB/*.jar; do
    SCALA_LIB_CLASSPATH=$filename:$SCALA_LIB_CLASSPATH
done

$GRAALVM_HOME/bin/native-image --no-fallback -cp $SCALA_LIB_CLASSPATH:$PWD/scalac-substitutions/target/scala-2.12/scalac-substitutions_2.12-0.1.0-SNAPSHOT.jar scala.tools.nsc.Main -H:SubstitutionResources=substitutions.json -H:ReflectionConfigurationFiles=scalac-substitutions/reflection-config.json -H:Name=scalac $@
