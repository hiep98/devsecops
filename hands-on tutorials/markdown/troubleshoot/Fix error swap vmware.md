# Fix error swap vmware

```
sudo swapoff -a           # turn off swap  
sudo rm -i /swapfile      # remove old /swapfile  
sudo dd if=/dev/zero of=/swapfile bs=1M count=4096  
sudo chmod 600 /swapfile  # set proper file protections  
sudo mkswap /swapfile     # init /swapfile  
sudo swapon /swapfile     # turn on swap  
free -h                   # confirm 32G RAM and 4G swap
``` 
  
**  
Add to /etc/sysctl.conf below lines and reboot the system.  
\# Controls interval between generating an NMI perf monitoring interrupt that kernel uses to check for soft-lockup errors.  
watchdog_thresh=120  
  
**"NMI watchdog: BUG: soft lockup - CPU # stuck for #s! X:3005" in message log file after a Flame application crash  
****Causes:**  
Current time for CPU is greater than Watchdog threshold causing a soft lockup.  
**Solution:**  
To resolve this behavior, perform the following steps as root user:  
>1. Edit the file '/etc/sysctl.conf' and add the following line at the end  
>>"kernel.watchdog_thresh=30"  
  
>1. Save and Exit.  
>1. Reboot machine.  
  
  
*From \< https://www.autodesk.com/support/technical/article/caas/sfdcarticles/sfdcarticles/NMI-watchdog-BUG-soft-lockup-CPU-stuck-for-s-X-3005-in-message-log-file-after-a-Flame-application-crash.html&gt; *  
  
  

