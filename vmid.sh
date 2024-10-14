#!/bin/bash
cat apply.out | grep innprox | awk {'print $6'} > apply.copy



# Read the content of apply.out
input=$(cat apply.copy)

# Extract the integer using grep and sed
vmid=$(echo "$input" | grep -oP '(?<=\[id=innprox/qemu/)\d+(?=\])')
# Output the result
if [[ -n "$vmid" ]]; then
    echo ""
else
    echo "No valid vmid found."
fi

vmid=$vmid
echo  $vmid > vmid.txt

echo "
- hosts: vmgroup
  tasks:
    - name: Run the network command on the VM
      shell: \"qm guest cmd $vmid network-get-interfaces | grep 'ip-address' | awk '{print \$3}' > ip.txt && awk 'NR==7' ip.txt\"
      register: command_output

    - name: Display the output on machine-1
      debug:
        msg: \"{{ command_output.stdout }}\"
" > ansible.yml

./ansible.sh
#rm apply.out apply.copy


