#!/bin/bash
set -ex

echo "Uploading to Fabric Beta"

#
# Required parameters
if [ -z "${fabric_apk_path}" ] ; then
  echo " [!] Missing required input: fabric_apk_path"
  exit 1
fi
if [ ! -f "${fabric_apk_path}" ] ; then
  echo " [!] File doesn't exist at specified path: ${fabric_apk_path}"
  exit 1
fi

if [ -z "${fabric_api_key}" ] ; then
  echo " [!] Missing required input: fabric_api_key"
  exit 1
fi

if [ -z "${fabric_build_secret}" ] ; then
  echo " [!] Missing required input: fabric_build_secret"
  exit 1
fi

if [ -z "${fabric_android_res}" ] ; then
  echo " [!] Missing required input: fabric_android_res"
  exit 1
fi

if [ -z "${fabric_android_manifest}" ] ; then
  echo " [!] Missing required input: fabric_android_manifest"
  exit 1
fi

if [ $fabric_beta_distribution_notification == "Yes" ] ; then
	fabric_beta_distribution_notification=true
fi
if [ $fabric_beta_distribution_notification == "No" ] ; then
	fabric_beta_distribution_notification=false
fi

THIS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

unzip "$THIS_SCRIPT_DIR/crashlytics/crashlytics.zip" -d "$THIS_SCRIPT_DIR"

DEVTOOLS_JAR_PATH="$THIS_SCRIPT_DIR/crashlytics/crashlytics-devtools.jar"

chmod a+x "$DEVTOOLS_JAR_PATH"

if [ $fabric_beta_distribution_notification == true ] && [  -n $fabric_beta_distribution_list ] ; then
	java -jar "$DEVTOOLS_JAR_PATH" \
	 -apiKey $fabric_api_key \
	 -apiSecret $fabric_build_secret \
	 -uploadDist $fabric_apk_path \
	 -androidRes $fabric_android_res \
	 -androidManifest $fabric_android_manifest \
	 -betaDistributionNotifications $fabric_beta_distribution_notification \
	 -betaDistributionGroupAliases $fabric_beta_distribution_list
else
	java -jar "$DEVTOOLS_JAR_PATH" \
	 -apiKey $fabric_api_key \
	 -apiSecret $fabric_build_secret \
	 -uploadDist $fabric_apk_path \
	 -androidRes $fabric_android_res \
	 -androidManifest $fabric_android_manifest \
	 -betaDistributionNotifications $fabric_beta_distribution_notification
fi
