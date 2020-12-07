BASE_DIR="/usr/share"
LANYXSOFT_DIVISION="Alya"
PROGRAM="attendance"
PROGRAM_FULLNAME="infinite-campus-portal-attendance-automation"
MACHINE_TYPE="`uname -m`"

is_user_root() { [ "$(id -u)" -eq 0 ]; }
if is_user_root; then
    echo "Starting uninstall script."
else
    echo "Please run with root."
    exit;
fi

# Determine the Machine type
case $MACHINE_TYPE in
    'x86_64')
        MACHINE_TYPE='x86_64'
        ;;
    *)
        MACHINE_TYPE='unknown'
        ;;
esac

# Linux Core Functions
ld_core_d() {
    if [! -d "/usr/share"]
    then 
        read -p "Enter a location to store the core directories [use the form /dir/dir]: " BASE_DIR
    fi
    if [ -d "${BASE_DIR}" ]
    then
        if [ ! -d "${BASE_DIR}/lanyxsoft" ]
        then
            echo "[ERROR]: Base directory 'lanyxsoft' was not found. Creating it now in [${BASE_DIR}]..."
            mkdir "${BASE_DIR}/lanyxsoft"
        fi
    fi
    if [ -d "${BASE_DIR}" ]
    then
        if [ -d "${BASE_DIR}/lanyxsoft" ]
        then
            if [ -d "${BASE_DIR}/lanyxsoft/${LANYXSOFT_DIVISION}" ]
            then
                if [ -d "${BASE_DIR}/lanyxsoft/${LANYXSOFT_DIVISION}/${PROGRAM}" ]
                then
                    echo "Removing '${PROGRAM}' core directory..."
                    rm -r "${BASE_DIR}/lanyxsoft/${LANYXSOFT_DIVISION}/${PROGRAM}"
                else
                    echo "[ERROR]: Core directory '${PROGRAM}' was not found. Assuming uninstallation completion status: TRUE"
                    exit;
                fi
            else
                echo "[ERROR]: Core directory '${LANYXSOFT_DIVISION}' was not found. Assuming uninstallation completion status: TRUE"
                exit;
            fi
        fi
    fi
}

case "`uname`" in
    'Linux')
        OS='Linux'

        if [ -e "/etc/cron.d/lanyxsoft_${LANYXSOFT_DIVISION}_${PROGRAM_FULLNAME}" ]
        then
            echo "Removing cron task [/etc/cron.d/lanyxsoft_${LANYXSOFT_DIVISION}_${PROGRAM_FULLNAME}]"
            rm "/etc/cron.d/lanyxsoft_${LANYXSOFT_DIVISION}_${PROGRAM_FULLNAME}"
        fi
        echo "Deleting ${LANYXSOFT_DIVISION} core directories and installed files."
        ld_core_d
        ;;
    'FreeBSD')
        OS='FreeBSD'

        echo "Not implimented yet. :\\"
        exit;
        ;;
    'WindowsNT')
        OS='Windows'

        echo "Not implimented yet. :\\"
        exit;
        ;;
    'Darwin') 
        OS='Mac'

        echo "Not implimented yet. :\\"
        exit;
        ;;
    'SunOS')
        OS='Solaris'

        echo "Not implimented yet. :\\"
        exit;
        ;;
    'AIX')
        OS='AIX'

        echo "Not implimented yet. :\\"
        exit;
        ;;
    *)
        OS='unknown'

        echo "Not implimented yet. :\\"
        exit;
        ;;
esac