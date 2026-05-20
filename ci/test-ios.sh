#!/usr/bin/env bash
set -euo pipefail

PROJECT="${PROJECT:-StableCollectionViewLayout.xcodeproj}"
SCHEME="${SCHEME:-StableCollectionViewLayoutTests}"
DERIVED_DATA_PATH="${DERIVED_DATA_PATH:-${PWD}/DerivedData}"
DESTINATION_NAME="${DESTINATION_NAME:-}"

if [[ -n "${DESTINATION_NAME}" ]]; then
    DESTINATION="platform=iOS Simulator,name=${DESTINATION_NAME},OS=latest"
else
    DESTINATION_ID="$(
        xcrun simctl list devices available -j | /usr/bin/python3 -c '
import json
import sys

preferred_names = (
    "iPhone 17",
    "iPhone 16",
    "iPhone 15",
    "iPhone 14",
    "iPhone 13",
    "iPhone 12",
    "iPhone 11",
)
data = json.load(sys.stdin)
devices = []

for runtime, runtime_devices in data.get("devices", {}).items():
    if not runtime.startswith("com.apple.CoreSimulator.SimRuntime.iOS-"):
        continue

    for device in runtime_devices:
        if device.get("isAvailable"):
            devices.append(device)

for preferred_name in preferred_names:
    for device in devices:
        if device.get("name") == preferred_name:
            print(device["udid"])
            sys.exit(0)

if devices:
    print(devices[0]["udid"])
    sys.exit(0)

sys.exit("No available iOS simulator found")
'
    )"
    DESTINATION="id=${DESTINATION_ID}"
fi

xcodebuild test \
    -project "${PROJECT}" \
    -scheme "${SCHEME}" \
    -destination "${DESTINATION}" \
    -derivedDataPath "${DERIVED_DATA_PATH}" \
    CODE_SIGNING_ALLOWED=NO
