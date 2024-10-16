from flask import Flask, render_template, request, redirect, url_for
import os
import re
import subprocess
import time  # Use time instead of sleep module
app = Flask(__name__)

# Store VM configuration details
vm_config = {
    "vm_name": "",
    "os_type": "",
    "ram": "",
    "cpu_cores": "",
    "storage": "",
    "username": "",
    "password": ""
}

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/resources', methods=['POST'])
def resources():
    # Collect OS type and VM name
    vm_config["vm_name"] = request.form['vm_name']
    vm_config["os_type"] = request.form['os_type']
    
    # Proceed to resources configuration
    return render_template('resources.html')

@app.route('/credentials', methods=['POST'])
def credentials():
    # Collect RAM, CPU cores, and storage details
    vm_config["ram"] = request.form['ram']
    vm_config["cpu_cores"] = request.form['cpu_cores']
    vm_config["storage"] = request.form['storage']
    
    # Proceed to credentials configuration
    return render_template('credentials.html')

@app.route('/create_vm', methods=['POST'])
def create_vm():
    # Collect username and password
    vm_config["username"] = request.form['username']
    vm_config["password"] = request.form['password']

    # Generate vars.tf file dynamically
    generate_vars_tf()

    # Run the Terraform script to provision the VM
    os.system('./script.sh')
    
    # Wait for the VM to be provisioned
    time.sleep(30)

    # Redirect to the result page
    return redirect(url_for('result'))

@app.route('/result')
def result():
    try:
        # Execute the script to get the VM ID
        vmid_output = subprocess.check_output('./vmid_show.sh', shell=True, text=True)
        vmid = vmid_output.strip()  # Capture the VM ID

        # Execute the script to get the VM IP
        vmip_output = subprocess.check_output('./vmip.sh', shell=True, text=True)
        # time.sleep(30)
        # print(type(vmip_output),'type')
        # print(vmip_output,'vm output for ip')
        # Use regex to extract the IP address
        # ip_match = re.search(r'\"(\d+\.\d+\.\d+\.\d+)\"', vmip_output)
        # vmip = ip_match.group(1) if ip_match else "IP not found"
        vmip = vmip_output
        vmip = re.sub(r'[\"\\,]', '', vmip_output).strip()
        print(vmip,'vmippppppp')

    except subprocess.CalledProcessError as e:
        return f"Error executing script: {e}"

    return render_template('result.html', vm_name=vm_config['vm_name'], vmid=vmid, vmip=vmip)

def generate_vars_tf():
    with open('vars.tf', 'w') as f:
        f.write(f'''
variable "vm_name" {{
  description = "Name of the VM"
  type        = string
  default     = "{vm_config['vm_name']}"
}}

variable "template_name" {{
  description = "Name of the template to clone"
  type        = string
  default     = "{vm_config['os_type']}"
}}

variable "vm_cores" {{
  description = "Number of CPU cores"
  type        = number
  default     = {vm_config['cpu_cores']}
}}

variable "vm_memory" {{
  description = "Amount of RAM in MB"
  type        = number
  default     = {vm_config['ram']}
}}

variable "vm_storage" {{
  description = "Amount of Storage in GB"
  type        = number
  default     = {vm_config['storage']}
}}

variable "ci_user" {{
  description = "Cloud-init username"
  type        = string
  default     = "{vm_config['username']}"
}}

variable "ci_passwd" {{
  description = "Cloud-init password"
  type        = string
  default     = "{vm_config['password']}"
}}
        ''')

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8000)
