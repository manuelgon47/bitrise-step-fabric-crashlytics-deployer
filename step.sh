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

wget https://github.com/manuelgon47/bitrise-step-fabric-crashlytics-deployer/raw/test/crashlytics/crashlytics.zip
unzip crashlytics.zip
chmod a+x ./crashlytics/crashlytics-devtools.jar
ls -la

command=`java -jar ./crashlytics/crashlytics-devtools.jar`
command+=` -apiKey $fabric_api_key`
command+=` -apiSecret $fabric_build_secret`
command+=` -uploadDist $fabric_apk_path`
command+=` -androidRes $fabric_android_res`
command+=` -androidManifest $fabric_android_manifest`
command+=` -betaDistributionNotifications $fabric_beta_distribution_notification`
#if [ $fabric_beta_distribution_notification == "Yes" ] ; then
#command+=` -betaDistributionGroupAliases $fabric_beta_distribution_list`
#fi
echo "$command"
