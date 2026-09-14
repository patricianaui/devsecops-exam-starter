# Secure Delivery Pipeline - Macky Merch API

This repository contains a containerized Node.js application integrated with an automated Github Actions CI pipeline and security scanning using Trivy.

---

## Local Setup Instructions

To build and run the application locally using Docker:

1. **Build the Docker Image:**
```bash
docker build -t macky-api .
```

2. **Run the Container:**
```bash
docker run -p 3000:3000 macky-api
```

3. **Verify App Execution:**
Open your browser and navigate to `http://localhost:3000/health`.

---

## Architectural Explanation
1. **Base Image (`node:18-alpine`):**
`node:18-alpine` was selected instead of the standard `node:latest` because Alpine Linux is lightweight and minimal (~5 MB). This reduces the container image size, speeds up CI build times, and minimizes vulnerability to attacks because unlike `node:latest `, it does not have hundreds of pre-installed packages. Alpine is also more reliable than using the latest version because with new updates to Node.js, there is a risk of the build breaking.

2. **Non-Root Execution (`USER node`):**
To adhere to container security best practices, the Dockerfile explicitly switches to the unprivileged `node` user before execution. This prevents potential container-breakout exploits from gaining root privileges on the host system.

3. **Security Scanner (Trivy):**
Aqua Security Trivy was chosen because, in the real world, developers might install a package to their codebase without realizing that the package contains security flaws. With the help of Trivy which automatically runs on GitHub's cloud servers, the vulnerability is caught, preventing the risky build from going live to customers, clients, or users.

---

## Vulnerability Demonstration

To test the security scanning phase of the CI pipeline, a vulnerable dependency `"lodash": "4.17.11"` was deliberately placed.

When pushed to GitHub, the Trivy Security Scan step flagged multiple High and Critical prototype pollution vulnerabilities within `lodash@4.17.11` and stopped the pipeline, successfully blocking the Docker build step.

![alt text](<Screenshot 2026-09-14 at 10.22.30 PM.png>)

(The following screenshot is to show that the Docker image has been built successfully; the previous screenshot shows the pipeline failure that prevented the Docker image from being built due to the security scan preventing the remaining steps from being executed).

![alt text](<Screenshot 2026-09-14 at 10.39.12 PM.png>)

---

## Challenges Faced

**Challenge:**
Overcoming a steep learning curve in DevSecOps concepts with no prior background in JavaScript, Docker, or automated security pipelines.

**Solution:**
Coming from a background focused strictly on C, Java, and a little bit of socket programming, concepts like containerization, YAML pipeline definitions, and NPM dependency vulnerabilities were completely foreign. To solve this within the given time, I adopted an active-learning approach--primarily using Gemini as an interactive tutor. Rather than relying on automated generation, I used Gemini to explain backend architecture, break down Docker file layering, and map Trivy security scanning to real-world software engineering practices. This allowed me to understand why tools like Trivy are essential for preventing vulnerable dependencies (like the prototype pollution in `lodash`) from reaching production environments.
