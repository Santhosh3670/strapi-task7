Strapi CMS - DevOps Internship Task

This project is part of my DevOps internship assignment to explore Strapi CMS. It includes cloning the official repository, setting up a local Strapi project, creating a custom content type, and documenting the process.

---

Repository Exploration

Step 1: Clone the Official Strapi Repository

Command:
git clone https://github.com/strapi/strapi.git

Purpose: To explore Strapi’s monorepo folder structure and plugin architecture.

---

Local Strapi App Setup

Step 2: Create a New Strapi App

Command:
npx create-strapi-app@latest strapi-app --quickstart

- Skipped login/signup when prompted.
- Project folder created: strapi-app
- Automatically installed dependencies and started the dev server.

Step 3: Run Strapi with External Access

Command:
STRAPI_HOST=0.0.0.0 npm run develop

- Made Strapi accessible outside the VM.
- Accessed the admin panel from host machine:  
  http://192.168.114.129:1337/admin

---

Admin Setup

- Chose Developer as the role.
- Created admin account during first login.
- Explored the admin panel dashboard.

---

Custom Content Type: Blog

Created a collection type called Blog using the Content-Type Builder with the following fields:

Title         - Text  
Body          - Rich Text  
Published     - Boolean  
Published At  - DateTime  

- Added multiple sample blog entries via Content Manager.

---

GitHub Setup

Step 4: Initialize Git & Push to GitHub

Commands:
git init  
git remote add origin git@github.com:Santhosh3670/strapi-app.git  
git add .  
git commit -m "Initial commit: Strapi blog app setup"  
git push -u origin main  

GitHub Repository: https://github.com/Santhosh3670/strapi-app

---

Task Checklist

[x] Cloned Strapi repository  
[x] Explored folder structure  
[x] Created a Strapi app locally  
[x] Ran Strapi with external access  
[x] Created admin user  
[x] Built and tested Blog content type  
[x] Pushed project to GitHub  
[ ] Recorded Loom video  
[ ] Shared PR + video link in team channel

---

Loom Video

Link to Loom walkthrough video goes here

---

Thank You

This project helped me gain hands-on experience with CMS setup, local hosting, and DevOps integration workflows.

