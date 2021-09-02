# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile
#noinspection ShrinkerUnresolvedReference

# 줄번호 유지
-renamesourcefileattribute astroluj.serial
-keepattributes SourceFile, LineNumberTable, Signature, Exceptions, *Annotation*, InnerClasses, EnclosingMethod
# variable names
-keepparameternames

# JNI methods
-keepclassmembers public class com.astroluj.serial.ttyserial.SerialPort { public protected private native <methods>; }
# keep private Activity activity
-keepclassmembers public class com.astroluj.serial.ttyserial.SerialPort { private java.io.FileDescriptor mFd ; }
# Static
-keepclassmembers public class com.astroluj.serial.** { public protected private static <fields> ; public static <methods>; }

# All
-keep class com.astroluj.serial.** { public protected *; }

#keep package name
-keep class com.astroluj.serial.** { public * ; }
-keep interface com.astroluj.serial.** { public * ; }
