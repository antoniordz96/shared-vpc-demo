#!/bin/bash -xe

echo "Installing Apache on this machine"

RPM_INSTALL_ARGS="install -y httpd php php-common"

yum update -y --disablerepo=rhui-rhel-7-server-rhui-optional-debug-rpms,rhui-rhel-7-server-rhui-rh-common-rpms

yum $RPM_INSTALL_ARGS

rm -rf /var/www/html/index.html

cat >> /var/www/html/index.php <<'EOF'
${index_file}
EOF
systemctl enable httpd
systemctl start httpd
systemctl restart httpd
