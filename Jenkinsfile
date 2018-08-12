import jenkins.model.*
jenkins = Jenkins.instance

timestamps {
node () {
	stage ('BootISO - Checkout') {
 	 checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'a0576608-6290-4b83-ba32-9c9b6665e204', url: 'https://github.com/jayfitzpatrick/Build_Centos_Netboot.git']]])
	}
	stage ('BootISO - Build') {
 			// Shell build step
sh """
dir=extracted
dir2=bootcd
cd /tmp
sudo yum install mkisofs -y
if [[ ! -e CentOS-7-x86_64-NetInstall-1804.iso ]]; then
wget http://ftp.heanet.ie/pub/centos/7/isos/x86_64/CentOS-7-x86_64-NetInstall-1804.iso
fi

if [[ ! -e ${dir} ]]; then
    mkdir ${dir}
elif [[ ! -d ${dir} ]]; then
    echo "${dir} already exists but is not a directory" 1>&2
fi
sudo mount -o loop ./CentOS-7-x86_64-NetInstall-1804.iso ./extracted
if [[ ! -e ${dir2} ]]; then
    mkdir ${dir2}
elif [[ ! -d ${dir2} ]]; then
    echo "${dir2} already exists but is not a directory" 1>&2
fi
sudo \\cp -r ./extracted/isolinux ./bootcd/
cd bootcd/
mkisofs -o kickstart.iso -b isolinux.bin -c boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -R -J -v -T isolinux/
cd ..
sudo umount extracted
"""
	}
}
}
