#!/bin/bash

# One image, two roles selected by env flags:
#   RUN_RAILS=true  -> puma web server
#   RUN_WORKER=true -> delayed_job worker (bin/rails jobs:work)
# supervisord reads the exported RUN_RAILS / RUN_WORKER to decide which programs autostart.

# Default to the web server if no role is specified
if [ -z "$RUN_RAILS" ] && [ -z "$RUN_WORKER" ]; then
  RUN_RAILS=true
  echo "⚠️ RUN_RAILS and RUN_WORKER are not set, defaulting to RUN_RAILS=true"
fi

# Normalize to literal booleans (accept "1" as true)
if [ "$RUN_RAILS" == "true" ] || [ "$RUN_RAILS" == "1" ]; then
  RUN_RAILS=true
else
  RUN_RAILS=false
fi
if [ "$RUN_WORKER" == "true" ] || [ "$RUN_WORKER" == "1" ]; then
  RUN_WORKER=true
else
  RUN_WORKER=false
fi

if [ "$RUN_RAILS" == "true" ]; then
  echo "✅ Running Rails"
fi
if [ "$RUN_WORKER" == "true" ]; then
  echo "✅ Running delayed_job worker"
fi

export RUN_RAILS
export RUN_WORKER

# Abort if gems are not installed
bundle check
if [ $? -ne 0 ]; then
  echo "❌ Gems in Gemfile are not installed, aborting..."
  exit 1
else
  echo "✅ Gems in Gemfile are installed"
fi

# Run pending migrations unless explicitly skipped
if [ -z "$SKIP_MIGRATIONS" ]; then
  bundle exec rails db:migrate
else
  echo "⚠️ Skipping migrations"
fi

echo "✅ Migrations are all up"

echo "🚀 $@"
exec "$@"
