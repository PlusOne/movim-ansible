# Movim Ansible Playbook

## Description
This Ansible playbook automates the installation and configuration of the Movim XMPP HTTP responsive client. It supports installation with different web servers (`nginx`, `caddy`, `apache2`) and database systems (`mysql`, `postgresql`).

## Requirements
- Ansible 2.17.4 or later
- Python 3.10+
- Supported Operating System: Ubuntu/Debian

## Variables
During the execution of the playbook, you will be prompted to enter the following variables:

- `DAEMON_URL`: The URL for the Movim daemon.
- `db_type`: Select the database type (`mysql` or `postgresql`).
- `mysql_root_user`: MySQL root username (default: `root`).
- `mysql_root_password`: MySQL root password.
- `movim_db_user`: Movim database username.
- `movim_db_password`: Movim database password.
- `web_server`: Select the web server to use (`nginx`, `caddy`, `apache2`).
- `backend_ip`: The IP address for the backend service (default: `127.0.0.1`).
- `backend_port`: The port number for the backend service (default: `8075`).
- `install_service`: Do you want to install the Movim systemd service? (`yes` or `no`)

## Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/yourusername/movim-ansible.git
   cd movim-ansible
   ```

2. **Create Inventory File:**
   Create an `inventory.yaml` file with your target hosts. Example:
   ```yaml
   all:
     hosts:
       your_server:
         ansible_host: your.server.ip
         ansible_user: your_user
   ```

3. **Run the Playbook:**
   ```bash
   ansible-playbook -i inventory.yaml playbook.yml --connection=local
   ```

## Configuration

### Database Selection

Choose the database type by setting the `db_type` variable during the playbook execution. Supported options are `mysql` and `postgresql`.

```bash
ansible-playbook -i "localhost," -c local playbook.yml
```

You will be prompted to select the database type:

```
Select Database Type (mysql/postgresql) [mysql]:
```

- **MySQL**: Sets up the MySQL database and related configurations using the separate `configure_mysql.yml` task file.
- **PostgreSQL**: Sets up the PostgreSQL database and related configurations using the separate `configure_postgresql.yml` task file.

### Web Server Selection

Select your preferred web server (`nginx`, `caddy`, or `apache2`) during the playbook execution:

```
Select Web Server (nginx/caddy/apache2) [nginx]:
```

The playbook will configure the selected web server accordingly.

## Usage

1. **Run the Playbook:**
   Execute the playbook using the command above. You will be prompted to enter the required variables.

2. **Provide the Required Information:**
   - **DAEMON_URL:** Enter the URL where the Movim daemon will be accessible.
   - **db_type:** Choose between `mysql` or `postgresql`.
   - **mysql_root_user:** Enter the MySQL root username.
   - **mysql_root_password:** Enter the MySQL root password.
   - **movim_db_user:** Enter the Movim database username.
   - **movim_db_password:** Enter the Movim database password.
   - **web_server:** Select the web server (`nginx`, `caddy`, `apache2`) you wish to use.
   - **backend_ip:** Enter the IP address for the backend service (default: `127.0.0.1`).
   - **backend_port:** Enter the port number for the backend service (default: `8075`).
   - **install_service:** Do you want to install the Movim systemd service? (`yes` or `no`)

3. **Run Database Migrations:**
   After the playbook completes, navigate to the Movim directory and run the migrations:
   ```bash
   cd /var/www/movim
   composer movim:migrate
   ```

4. **(Optional) Install Movim Systemd Service:**
   If you chose to install the systemd service during the playbook execution, the service will be enabled and started automatically. The default service user is `www-data`. You can manage the service using:
   ```bash
   sudo systemctl start movim
   sudo systemctl enable movim
   sudo systemctl status movim
   ```
   *To override the default service user, you can run the playbook with an extra variable:*
   ```bash
   ansible-playbook -i inventory.yaml playbook.yml --extra-vars "service_user=your_user"
   ```

5. **Access Movim:**
   After successful execution, access Movim via the domain you specified.

## Handlers
The playbook includes handlers to reload the selected web server after configuration changes.

- **Nginx**: Reloads Nginx if selected.
- **Caddy**: Reloads Caddy if selected.
- **Apache2**: Reloads Apache2 if selected.
- **Movim Service**: Restarts the Movim service if installation was chosen.

## License
This project is licensed under the MIT License.
