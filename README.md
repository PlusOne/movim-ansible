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
- `domain_name`: The domain name for Nginx.
- `web_server`: Select the web server to use (`nginx`, `caddy`, `apache2`).

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

## Usage

1. **Run the Playbook:**
   Execute the playbook using the command above. You will be prompted to enter the required variables.

2. **Provide the Required Information:**
   - **DAEMON_URL:** Enter the URL where the Movim daemon will be accessible.
   - **db_type:** Choose between `mysql` or `postgresql`.
   - **mysql_root_user:** Enter the MySQL root username.
   - **mysql_root_password:** Enter the MySQL root password.
   - **domain_name:** Specify the domain name for Nginx configuration.
   - **web_server:** Select the web server (`nginx`, `caddy`, `apache2`) you wish to use.

3. **Access Movim:**
   After successful execution, access Movim via the domain you specified.

## Handlers
The playbook includes handlers to reload the selected web server after configuration changes.

## License
This project is licensed under the MIT License.
