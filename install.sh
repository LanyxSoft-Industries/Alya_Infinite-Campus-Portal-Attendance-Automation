BASE_DIR="/usr/share"
LANYXSOFT_DIVISION="Alya"
PROGRAM="attendance"
PROGRAM_FULLNAME="infinite-campus-portal-attendance-automation"
MACHINE_TYPE="`uname -m`"

is_user_root() { [ "$(id -u)" -eq 0 ]; }
if is_user_root; then
    echo "Starting install script."
else
    echo "Please run with root."
    exit;
fi

# Determine the Machine type
case ${MACHINE_TYPE} in
    'x86_64')
        MACHINE_TYPE='x86_64'
        ;;
    *)
        MACHINE_TYPE='unknown'
        ;;
esac

# Linux Core Functions
lm_core_d() {
    if [! -d "/usr/share"]
    then 
        read -p "Enter a location to store the core directories [use the form /dir/dir]: " BASE_DIR
    fi
    if [ -d "${BASE_DIR}" ]
    then
        if [ ! -d "${BASE_DIR}/lanyxsoft" ]
        then
            echo "Creating driectory 'lanyxsoft' in [${BASE_DIR}]"
            mkdir "${BASE_DIR}/lanyxsoft"
        fi
    fi
    if [ -d "${BASE_DIR}" ]
    then
        if [ -d "${BASE_DIR}/lanyxsoft" ]
        then
            if [ ! -d "${BASE_DIR}/lanyxsoft/${LANYXSOFT_DIVISION}" ]
            then
                echo "Creating driectory [${LANYXSOFT_DIVISION}' in '${BASE_DIR}/lanyxsoft]"
                mkdir "${BASE_DIR}/lanyxsoft/${LANYXSOFT_DIVISION}"
            fi
        fi
    fi
    if [ -d "${BASE_DIR}" ]
    then
        if [ -d "${BASE_DIR}/lanyxsoft" ]
        then
            if [ ! -d "${BASE_DIR}/lanyxsoft/${LANYXSOFT_DIVISION}/${PROGRAM}" ]
            then
                echo "Creating driectory '${PROGRAM}' in [${BASE_DIR}/lanyxsoft/${LANYXSOFT_DIVISION}]"
                mkdir "${BASE_DIR}/lanyxsoft/${LANYXSOFT_DIVISION}/${PROGRAM}"
            fi
        fi
    fi
}

ld_core_f() {
    if ! ls "${BASE_DIR}/lanyxsoft/${LANYXSOFT_DIVISION}/${PROGRAM}/attendance.py" > /dev/null
    then
        wget -q "https://raw.githubusercontent.com/LanyxSoft-Industries/Alya_Infinite-Campus-Portal-Attendance-Automation/main/attendance.py"
    else
        echo "File already exists, not updating"
    fi
}

case "`uname`" in
    'Linux')
        OS='Linux'

        read -p "Current user: " USER
        
        cd "${BASE_DIR}"
        lm_core_d
        cd "lanyxsoft/${LANYXSOFT_DIVISION}/${PROGRAM}"
        echo "Creating initialization log file."
        echo "Timestamp: `date`\n------> User: ${USER}\n------> `sudo dmidecode | grep -A3 '^System Information'`\n`uname -r` | `uname -v` on `uname -o`\n------> Node Name: `uname -n`\n" >> "LanyxSoft Alya Initialization.log"
        
        echo "Downloading files from Github [https://github.com/LanyxSoft-Industries/Alya_Infinite-Campus-Portal-Attendance-Automation]..."
        ld_core_f

        if [ ! -e "/etc/cron.d/lanyxsoft_${LANYXSOFT_DIVISION}_${PROGRAM_FULLNAME}" ]
        then
            echo "Creating cron task [/etc/cron.d/lanyxsoft_${LANYXSOFT_DIVISION}_${PROGRAM_FULLNAME}]"
            # echo "*/5 0-15 * * 1-5 root export DISPLAY=:0 && export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bin && /usr/bin/python3 /usr/share/lanyxsoft/${LANYXSOFT_DIVISION}/${PROGRAM}/scheduler.py >> /usr/share/lanyxsoft/${LANYXSOFT_DIVISION}/${PROGRAM}/scheduler.log\n20 14 * * 1-5 root export DISPLAY=:0 && export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bin && /usr/bin/python3 /usr/share/lanyxsoft/${LANYXSOFT_DIVISION}/${PROGRAM}/schedule_reset.py >> /usr/share/lanyxsoft/${LANYXSOFT_DIVISION}/${PROGRAM}/schedule_reset.log" >> "/etc/cron.d/lanyxsoft_${LANYXSOFT_DIVISION}_google-meets-automation"
            # echo "*/5 0-15 * * 1-5 root export DISPLAY=:0 && export PATH=\$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bin && /usr/bin/python3 /usr/share/lanyxsoft/${LANYXSOFT_DIVISION}/${PROGRAM}/scheduler.py >> /usr/share/lanyxsoft/${LANYXSOFT_DIVISION}/${PROGRAM}/scheduler.log\n20 14 * * 1-5 root export DISPLAY=:0 && export PATH=\$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bin && /usr/bin/python3 /usr/share/lanyxsoft/${LANYXSOFT_DIVISION}/${PROGRAM}/schedule_reset.py >> /usr/share/lanyxsoft/${LANYXSOFT_DIVISION}/${PROGRAM}/schedule_reset.log" >> "/etc/cron.d/lanyxsoft_${LANYXSOFT_DIVISION}_google-meets-automation"
            # echo "*/5 0-15 * * 1-5 root export DISPLAY=:0 && export PATH=\$PATH:/usr/local/bin && /usr/bin/python3 /usr/share/lanyxsoft/${LANYXSOFT_DIVISION}/${PROGRAM}/scheduler.py >> /usr/share/lanyxsoft/${LANYXSOFT_DIVISION}/${PROGRAM}/scheduler.log\n20 14 * * 1-5 root export DISPLAY=:0 && export PATH=\$PATH:/usr/local/bin && /usr/bin/python3 /usr/share/lanyxsoft/${LANYXSOFT_DIVISION}/${PROGRAM}/schedule_reset.py >> /usr/share/lanyxsoft/${LANYXSOFT_DIVISION}/${PROGRAM}/schedule_reset.log" >> "/etc/cron.d/lanyxsoft_${LANYXSOFT_DIVISION}_google-meets-automation"
            read -p "Infinite Campus username: " IC_USERNAME
            read -p "Infinite Campus password: " IC_PASSWORD
            read -p "Infinite Campus link: " IC_LINK
            read -p "User Agent to use (Optional) type 'none' to use default: " IC_USERAGENT
            if [ "${IC_USERAGENT}" = "" -o "${IC_USERAGENT}" = "none" -o "${IC_USERAGENT}" = "default" ]; then
                echo "0 10 * * 1-5 root DISPLAY=:0 XAUTHORITY=~${USER}/.Xauthority python3 ${BASE_DIR}/lanyxsoft/${LANYXSOFT_DIVISION}/${PROGRAM}/attendance.py -u '${IC_USERNAME}' -p '${IC_PASSWORD}' -url '${IC_LINK}' >> ${BASE_DIR}}/lanyxsoft/${LANYXSOFT_DIVISION}/${PROGRAM}/attendance.log" > "/etc/cron.d/lanyxsoft_${LANYXSOFT_DIVISION}_${PROGRAM_FULLNAME}"
            else
                echo "0 10 * * 1-5 root DISPLAY=:0 XAUTHORITY=~${USER}/.Xauthority python3 ${BASE_DIR}/lanyxsoft/${LANYXSOFT_DIVISION}/${PROGRAM}/attendance.py -u '${IC_USERNAME}' -p '${IC_PASSWORD}' -ua '${IC_USERAGENT}' -url '${IC_LINK}' >> ${BASE_DIR}}/lanyxsoft/${LANYXSOFT_DIVISION}/${PROGRAM}/attendance.log" > "/etc/cron.d/lanyxsoft_${LANYXSOFT_DIVISION}_${PROGRAM_FULLNAME}"
            fi
        fi
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