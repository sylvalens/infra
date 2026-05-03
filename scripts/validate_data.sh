#!/bin/bash

# Default to ../forest-res if not set in environment
DATA_ROOT="${FOREST_DATA_ROOT:-../forest-res}"

echo "Checking data volume at: $DATA_ROOT"

if [ ! -d "$DATA_ROOT" ]; then
  echo "❌ ERROR: Data root directory '$DATA_ROOT' does not exist."
  echo "Please download the required datasets and place them in the correct folder, or set the FOREST_DATA_ROOT environment variable."
  exit 1
fi

REQUIRED_DIRS=(
  "FORMS-T"
  "global-forest-change"
  "lidar-hd"
)

REQUIRED_FILES=(
  "cadastre-68-communes.json"
)

MISSING=0

for dir in "${REQUIRED_DIRS[@]}"; do
  if [ ! -d "$DATA_ROOT/$dir" ]; then
    echo "❌ ERROR: Required directory '$dir' is missing in $DATA_ROOT"
    MISSING=1
  else
    echo "✅ Found directory: $dir"
  fi
done

for file in "${REQUIRED_FILES[@]}"; do
  if [ ! -f "$DATA_ROOT/$file" ]; then
    echo "❌ ERROR: Required file '$file' is missing in $DATA_ROOT"
    MISSING=1
  else
    echo "✅ Found file: $file"
  fi
done

if [ "$MISSING" -eq 1 ]; then
  echo ""
  echo "❌ Data validation failed. Please ensure all required datasets are present before starting the services."
  exit 1
fi

echo ""
echo "✅ All required external datasets validated successfully!"
exit 0
