# LocalHelp Frontend

## 📌 Overview

LocalHelp Frontend is a React-based web application that allows users to request and respond to local help services such as medicine requests and essential services.

This application is part of the LocalHelp 3-Tier Architecture project.

---

## 🚀 Features

* User-friendly UI 
* Help request form with validation
* Medicine listing and cart system
* Quantity control (max 5 per item)
* Cart summary and order flow (UI level)

---

## 🛠️ Tech Stack

* React.js
* React Router
* Context API (State Management)
* CSS (Custom styling)

---

## 📂 Project Structure

```
src/
 ├── components/
 ├── context/
 ├── pages/
 ├── App.js
 └── index.js
```

---

## ⚙️ Setup Instructions


### 5️⃣ Setup Web Server (Frontend)

```bash
sudo apt update
sudo apt install nginx -y
```
### Start and enable nginx and check status:

```bash
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl status nginx
```

### 📁 Clean default web folder

Nginx serves from: /var/www/html

Clear it:

```bash
sudo rm -rf /var/www/html/*
```

### Pull Code from GitHub to EC2

```bash
git clone https://github.com/your-username/3tier-devsecops-ai.git
cd localhelp-frontend
```

### Build the React App
```bash
npm install
npm run build
```
### 👉 This creates: build/

### 📦 Deploy React to Nginx

Copy build files:

```bash
sudo cp -r build/* /var/www/html/
```

### 6️⃣ Test the Application

NGINX is serving your files ✅

Your React app is deployed ✅

* Open browser: http://your-ec2-ip

```
👉 Your React app is LIVE 🎉
```

### 1. Clone the repo

```
git clone https://github.com/sbp828/localhelp-frontend.git
cd localhelp-frontend
```

### 2. Install dependencies

```
npm install
```

### 3. Run the app

```
npm start
```

App will run at:

```
http://localhost:3000
```

---

## 🔗 Backend Integration

This frontend connects to the LocalHelp backend APIs.

👉 Backend Repo:
https://github.com/sbp828/localhelp-backend

---

## 📌 Future Enhancements

* Payment integration
* Real-time request tracking
* Notification system
* UI improvements

---

## 👨‍💻 Author

Developed as part of a DevSecOps learning project.
