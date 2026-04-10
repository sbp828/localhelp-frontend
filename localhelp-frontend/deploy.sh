#!/bin/bash

echo "🚀 Building React app..."
npm run build

echo "📦 Copying build to NGINX directory..."
sudo rm -rf /var/www/localhelp
sudo mkdir -p /var/www/localhelp
sudo cp -r build/* /var/www/localhelp/

echo "🔄 Restarting NGINX..."
sudo systemctl restart nginx

echo "✅ Deployment complete!"
