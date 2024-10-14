rm logfile.log

#./test.sh
ansible-playbook -i /boot/Anirudh/git/cloud-phase-1/terraform_flask_app/hosts ansible.yml  #&> out.file
#cat out.file | grep
cat logfile.log | grep "msg" | grep "," | awk '{print $2}' > vmip.out
#rm logfile.log
