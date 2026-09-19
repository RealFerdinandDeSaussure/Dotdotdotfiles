function bootwin
    set -l win_entry (efibootmgr | grep "Windows Boot Manager" | cut -f1 -d\* | tr -d [:alpha:])
    command sudo efibootmgr -n $win_entry && command systemctl reboot
end
