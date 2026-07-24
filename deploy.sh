#!/usr/bin/env bash
# Deploy de la web VantAr a Cloudflare Pages (produccion, branch main).
# Lee las credenciales desde ~/.vantar/claves.md en tiempo de ejecucion:
# el token nunca queda en el chat ni en este archivo.
set -euo pipefail
cd "$(dirname "$0")"

CLAVES="$HOME/.vantar/claves.md"
TOKEN=$(sed -n 's/.*API Token:\*\* `\([^`]*\)`.*/\1/p' "$CLAVES" | head -1)
ACCOUNT=$(sed -n 's/.*Account ID:\*\* `\([^`]*\)`.*/\1/p' "$CLAVES" | head -1)

if [ -z "$TOKEN" ] || [ -z "$ACCOUNT" ]; then
  echo "ERROR: no pude leer las credenciales de Cloudflare desde $CLAVES" >&2
  exit 1
fi

npm run build
CLOUDFLARE_API_TOKEN="$TOKEN" CLOUDFLARE_ACCOUNT_ID="$ACCOUNT" \
  npx wrangler pages deploy dist --project-name vantar-soluciones --branch main
