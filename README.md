<h1 align="center" id="title">SSH-AL3RT</h1>

<p align="center"><img src="https://socialify.git.ci/SushantVijay/22h-al3rt/image?font=Source%20Code%20Pro&amp;language=1&amp;name=1&amp;owner=1&amp;pattern=Brick%20Wall&amp;stargazers=1&amp;theme=Auto" alt="project-image"></p>

<p id="description">SSH Login Alert System A lightweight shell script to monitor SSH login attempts in real time. It detects successful logins from system logs extracts user and IP information and sends instant alerts via email. Ideal for enhancing server security by staying informed of login activity.</p>

  
  
<h2>🧐 Features</h2>

Here're some of the project's best features:

*   Monitors system logs for successful SSH logins.
*   Extracts details such as username IP address and login timestamp.
*   Sends instant alerts via email to keep you informed.
*   Works seamlessly with popular Linux distributions (Ubuntu Debian CentOS etc.).
*   Simple setup and minimal dependencies.

<h2>🛠️ Installation Steps:</h2>

<p>1. Clone the Repository</p>

```
https://github.com/SushantVijay/22h-al3rt.git
```

<p>2. Install Dependencies For Debian/Ubuntu:</p>

```
sudo apt update sudo apt install mailutils geoip-bin iptables
```

<p>4. Configure the Script</p>

```
nano shell.sh
```

<p>5. Update the LOGFILE path if necessary (e.g. /var/log/secure for CentOS).</p>

```
ALERT_EMAIL="your_email@example.com"
```

<p>6. Make the Script Executable</p>

```
chmod +x shell.sh
```

<p>7. Run the Script</p>

```
sudo ./shell.sh
```

<p>8. To run in the background:</p>

```
nohup sudo ./shell.sh &
```

<h2>🍰 Contribution Guidelines:</h2>

Feel free to fork enhance or submit pull requests. Let’s make this tool even better together!

  
  
<h2>💻 Built with</h2>

Technologies used in the project:

*   shell scripting
*   mailx
*   mailutils
*   geoip-bin
*   iptables

<h2>🛡️ License:</h2>

This project is licensed under the

<h2>💖Like my work?</h2>

Secure your server stay informed and take control with SSH Login Alert System! Do follow and Star it if you like it!
