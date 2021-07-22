#!/bin/bash -xe

echo "Installing Apache on this machine"

RPM_INSTALL_ARGS="install -y httpd php php-common"

subscription-manager repos --disable=rhui-rhel-7-server-rhui-rpms.skip_if_unavailable=true
yum update -y --disablerepo=rhui-rhel-7-server-rhui-extras-rpms

yum $RPM_INSTALL_ARGS

rm -rf /var/www/html/index.html

cat >> /var/www/html/index.php <<'EOF'
${index_file}
EOF
systemctl enable httpd
systemctl start httpd
systemctl restart httpd
