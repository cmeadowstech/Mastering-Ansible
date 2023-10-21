# [Mastering Ansible](https://www.udemy.com/course/mastering-ansible/)

My repro for the above Udemy course, which was recommended to me by a friend who found it useful when he started working with Ansible.

Unfortunately some of the content is quite, old, but I've so far been able to update most of the issues I've run into.
- Demo app was built with Python 2, so had to update dependencies because I'm running Ubuntu 22
- my.conf location has been updated
- MySQL dependencies differ largely due to Python 3
- Some syntax fixes such as groups.group to "{{groups['group']}}"
  - sites to "{{ sites }}" within with_dict
- httplib2 is no longer a dependency of Ansible's uri module, so omitting it
- Updated include under site.yml to import_playbook. include has been [deprecated](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/include_module.html#deprecated)

I'm also using Terraform to provision LXC instances on my Proxmox VE home server. It has made a wonderful combination thus far.