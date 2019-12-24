#lsblk, blkid...

- Какой размер дисков? Диск 2 и их размеры 10ГБ и 10МБ.

  ```bash
  NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
  sda      8:0    0  10G  0 disk 
  └─sda1   8:1    0  10G  0 part /
  sdb      8:16   0  10M  0 disk 
  ```

- Есть ли неразмеченное место на дисках? Нет.

- Какой размер партиций? LINUX 10G

  ```bash
  /dev/sda1  *     2048 20971486 20969439  10G 83 Linux
  ```

- Какая таблица партционирования используется? msdos

  ```bash
  Model: VBOX HARDDISK (scsi)
  Disk /dev/sda: 10.7GB
  Sector size (logical/physical): 512B/512B
  Partition Table: msdos
  Disk Flags: 
  
  Number  Start   End     Size    Type     File system  Flags
   1      1049kB  10.7GB  10.7GB  primary  ext4         boot
  ```

- Какой диск, партция или лвм том смонтированы в /

```
sda1
```

#squashfs

```bash
vagrant@ubuntu-xenial:/vagrant/bash_scripts/lab3$ mksquashfs mai/* mai.sqsh
Parallel mksquashfs: Using 2 processors
Creating 4.0 filesystem on mai.sqsh, block size 131072.
[===================================================================================================================================================================|] 28/28 100%

Exportable Squashfs 4.0 filesystem, gzip compressed, data block size 131072
	compressed data, compressed metadata, compressed fragments, compressed xattrs
	duplicates are removed
Filesystem size 53.01 Kbytes (0.05 Mbytes)
	62.59% of uncompressed filesystem size (84.70 Kbytes)
Inode table size 340 bytes (0.33 Kbytes)
	32.14% of uncompressed inode table size (1058 bytes)
Directory table size 369 bytes (0.36 Kbytes)
	61.50% of uncompressed directory table size (600 bytes)
Number of duplicate files found 1
Number of inodes 33
Number of files 29
Number of fragments 1
Number of symbolic links  0
Number of device nodes 0
Number of fifo nodes 0
Number of socket nodes 0
Number of directories 4
Number of ids (unique uids + gids) 1
Number of uids 1
	vagrant (1000)
Number of gids 1
	vagrant (1000)
vagrant@ubuntu-xenial:/vagrant/bash_scripts/lab3$ sudo mkdir /mnt/mai
mkdir: cannot create directory ‘/mnt/mai’: File exists
vagrant@ubuntu-xenial:/vagrant/bash_scripts/lab3$ sudo mount mai.sqsh /mnt/mai -t squashfs -o loop
vagrant@ubuntu-xenial:/vagrant/bash_scripts/lab3$ cd /mnt/mai
vagrant@ubuntu-xenial:/mnt/mai$ ls
bash-scripts  images  Lab-AAA.md  lab-processes  Lab-processes.md  Lab-web.md  Seminar1.md  Seminar2-bash.md
```

#df 

Какая файловая система примонтирована в / 

**/dev/sda1**

```bash
Filesystem      Size  Used Avail Use% Mounted on
udev            991M     0  991M   0% /dev
tmpfs           200M  5.7M  195M   3% /run
/dev/sda1       9.7G  4.8G  5.0G  49% /
tmpfs          1000M  4.0K 1000M   1% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
tmpfs          1000M     0 1000M   0% /sys/fs/cgroup
vagrant         466G  191G  276G  41% /vagrant
tmpfs           200M     0  200M   0% /run/user/1000
/dev/loop0      128K  128K     0 100% /mnt/mai
```

С какими опциями примонтирована файловая система в /

```bash
(rw,relatime,data=ordered)
```

Какой размер файловой системы приментированной в /mnt/mai

```bash
128K
```

#Попробуем создать файлик в каталоге /dev/shm

```bash
vagrant@ubuntu-xenial:/mnt/mai$ dd if=/dev/zero of=/dev/shm/mai bs=1M count=100
100+0 records in
100+0 records out
104857600 bytes (105 MB, 100 MiB) copied, 0.028715 s, 3.7 GB/s
vagrant@ubuntu-xenial:/mnt/mai$ free -h
              total        used        free      shared  buff/cache   available
Mem:           2.0G        264M        792M        147M        943M        1.4G
Swap:            0B          0B          0B
vagrant@ubuntu-xenial:/mnt/mai$ rm -f /dev/shm/mai
vagrant@ubuntu-xenial:/mnt/mai$ free -h
              total        used        free      shared  buff/cache   available
Mem:           2.0G        264M        892M         47M        843M        1.4G
Swap:            0B          0B          0B
vagrant@ubuntu-xenial:/mnt/mai$ 
```

Что такое tmpfs?

```
Временное хранилище файлов в оперативной памяти.
```

Какая часть памяти изменялась?

```
100M
```



# ps

Какие процессы в системе порождают дочерние процессы через fork

```
systemd, gdm3
```

Какие процессы в системе являются мультитредовыми

```
bioset, postgres, atop
```





# Разберитесь что делает команда

```bash
ps axo rss | tail -n +2|paste -sd+ | bc
```

Данная команда подсчитывает количество занятой и не находящейся в swap оперативной памяти в килобайтах, использованное процессами всех пользователей. 

-

# pss

```bash
vagrant@ubuntu-xenial:/mnt/mai$ smem
  PID User     Command                         Swap      USS      PSS      RSS 
19273 vagrant  /lib/systemd/systemd --user        0      932     1809     5136 
19338 vagrant  -bash                              0     3064     3211     5436 
25425 vagrant  /usr/bin/python /usr/bin/sm        0     7048     7178     9384 
```



#script

в другом терминале отследите порождение процессов 

```
11733 pts/1		00:00:00  |		\_ bash
16253 pts/1		00:00:00  |		|		\_ python
16254 pts/1		00:00:00  |		|				\_ python
16256 pts/1		00:00:00  |		|						\_ python
16257 pts/1		00:00:00  |		|						\_ python
16258 pts/1		00:00:00  |		|						\_ python
16260 pts/1		00:00:00  |		|						\_ python
```

- отследите какие состояния вы видите у процессов

  **Z**

  почему появляются процессы со статусам Z

- какой PID у основного процесса 

  **16254**

  какой PPID стал у первого чайлда

  **16254**

- насколько вы разобрались в скрипте и втом что он делает? 

  ```
  Скрипт создает множество форков и отправляет некоторые из них в сон.
  ```

  

  

  #Научимся корректно завершать зомби процессы

  - запустим еще раз наш процесс
  - убьем процесс первого чайлда
  - проверим его состояние и убедимся что он зомби
  - остановим основной процесс
  - расскоментируем строки в скрипте
  - поторим все еще раз
  - отследим корректное завершение чайлда

  ```bash
  my name is 68719476736
  150094635296999121
  mrrrrr
  137438953472
  my child pid is 25718
  Bye
  ```



#gdb

```bash
vagrant@ubuntu-xenial:~$ sudo gdb
GNU gdb (Ubuntu 7.11.1-0ubuntu1~16.5) 7.11.1
Copyright (C) 2016 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
<http://www.gnu.org/software/gdb/documentation/>.
For help, type "help".
Type "apropos word" to search for commands related to "word".
(gdb) attach 26062
Attaching to process 26062
Reading symbols from /usr/bin/python2.7...(no debugging symbols found)...done.
Reading symbols from /lib/x86_64-linux-gnu/libpthread.so.0...Reading symbols from /usr/lib/debug/.build-id/b1/7c21299099640a6d863e423d99265824e7bb16.debug...done.
done.
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
Reading symbols from /lib/x86_64-linux-gnu/libc.so.6...Reading symbols from /usr/lib/debug//lib/x86_64-linux-gnu/libc-2.23.so...done.
done.
Reading symbols from /lib/x86_64-linux-gnu/libdl.so.2...Reading symbols from /usr/lib/debug//lib/x86_64-linux-gnu/libdl-2.23.so...done.
done.
Reading symbols from /lib/x86_64-linux-gnu/libutil.so.1...Reading symbols from /usr/lib/debug//lib/x86_64-linux-gnu/libutil-2.23.so...done.
done.
Reading symbols from /lib/x86_64-linux-gnu/libz.so.1...(no debugging symbols found)...done.
Reading symbols from /lib/x86_64-linux-gnu/libm.so.6...Reading symbols from /usr/lib/debug//lib/x86_64-linux-gnu/libm-2.23.so...done.
done.
Reading symbols from /lib64/ld-linux-x86-64.so.2...Reading symbols from /usr/lib/debug//lib/x86_64-linux-gnu/ld-2.23.so...done.
done.
0x00007f04fa4405b3 in __select_nocancel () at ../sysdeps/unix/syscall-template.S:84
84	../sysdeps/unix/syscall-template.S: No such file or directory.
(gdb) 
```



#umount

\#cd /mnt/mai

\#в другом терминале sudo umount /mnt/mai 

Выводится ошибка: 

```
vagrant@ubuntu-xenial:/mnt/mai$ sudo umount /mnt/mai
umount: /mnt/mai: target is busy
        (In some cases useful info about processes that
         use the device is found by lsof(8) or fuser(1).)
```



umount: /mnt/mai: target is busy



 fuser -v /mnt/dir

```
                     USER        PID ACCESS COMMAND
/mnt/mai:            root     kernel mount /mnt/mai
```



## Исчезновение места

Увеличение размера файла при запущенном процессе 

```bash
vagrant@ubuntu-xenial:~/myfiles/mai/lab-processes$ lsd -l
.rw-rw-r-- vagrant vagrant 63.7 MB Tue Dec 24 16:30:59 2019   myfile       
.rw-rw-r-- vagrant vagrant  703 B  Tue Dec 24 16:21:55 2019   myfork.py    
.rw-rw-r-- vagrant vagrant   84 B  Tue Dec 24 16:21:55 2019   test_write.py
vagrant@ubuntu-xenial:~/myfiles/mai/lab-processes$ lsd -l
.rw-rw-r-- vagrant vagrant 90.1 MB Tue Dec 24 16:31:01 2019   myfile       
.rw-rw-r-- vagrant vagrant  703 B  Tue Dec 24 16:21:55 2019   myfork.py    
.rw-rw-r-- vagrant vagrant   84 B  Tue Dec 24 16:21:55 2019   test_write.py
vagrant@ubuntu-xenial:~/myfiles/mai/lab-processes$ lsd -l
.rw-rw-r-- vagrant vagrant 104.1 MB Tue Dec 24 16:31:02 2019   myfile       
.rw-rw-r-- vagrant vagrant   703 B  Tue Dec 24 16:21:55 2019   myfork.py    
.rw-rw-r-- vagrant vagrant    84 B  Tue Dec 24 16:21:55 2019   test_write.py
```

После остановки

```bash
vagrant@ubuntu-xenial:~/myfiles/mai/lab-processes$ lsd -l
.rw-rw-r-- vagrant vagrant 185 MB Tue Dec 24 16:31:09 2019   myfile       
.rw-rw-r-- vagrant vagrant 703 B  Tue Dec 24 16:21:55 2019   myfork.py    
.rw-rw-r-- vagrant vagrant  84 B  Tue Dec 24 16:21:55 2019   test_write.py
vagrant@ubuntu-xenial:~/myfiles/mai/lab-processes$ lsd -l
.rw-rw-r-- vagrant vagrant 185 MB Tue Dec 24 16:31:09 2019   myfile       
.rw-rw-r-- vagrant vagrant 703 B  Tue Dec 24 16:21:55 2019   myfork.py    
.rw-rw-r-- vagrant vagrant  84 B  Tue Dec 24 16:21:55 2019   test_write.py
vagrant@ubuntu-xenial:~/myfiles/mai/lab-processes$ df
Filesystem     1K-blocks      Used Available Use% Mounted on
udev             1014696         0   1014696   0% /dev
tmpfs             204796      3236    201560   2% /run
/dev/sda1       10098468   5264284   4817800  53% /
tmpfs            1023968         4   1023964   1% /dev/shm
tmpfs               5120         0      5120   0% /run/lock
tmpfs            1023968         0   1023968   0% /sys/fs/cgroup
vagrant        488245288 189667464 298577824  39% /vagrant
tmpfs             204796         0    204796   0% /run/user/1000
```



Продолжаем процесс в фоне.

```bash
vagrant@ubuntu-xenial:~/myfiles/mai/lab-processes$ du -sh .
196M	.
vagrant@ubuntu-xenial:~/myfiles/mai/lab-processes$ du -sh .
237M	.
vagrant@ubuntu-xenial:~/myfiles/mai/lab-processes$ du -sh .
308M	.
vagrant@ubuntu-xenial:~/myfiles/mai/lab-processes$ rm myfile 
vagrant@ubuntu-xenial:~/myfiles/mai/lab-processes$ du -sh .
12K	.
vagrant@ubuntu-xenial:~/myfiles/mai/lab-processes$ du -sh .
12K	.
vagrant@ubuntu-xenial:~/myfiles/mai/lab-processes$ du -sh .
12K	.
vagrant@ubuntu-xenial:~/myfiles/mai/lab-processes$ df
Filesystem     1K-blocks      Used Available Use% Mounted on
udev             1014696         0   1014696   0% /dev
tmpfs             204796      3236    201560   2% /run
/dev/sda1       10098468   5719236   4362848  57% /
tmpfs            1023968         4   1023964   1% /dev/shm
tmpfs               5120         0      5120   0% /run/lock
tmpfs            1023968         0   1023968   0% /sys/fs/cgroup
vagrant        488245288 189669796 298575492  39% /vagrant
tmpfs             204796         0    204796   0% /run/user/1000
vagrant@ubuntu-xenial:~/myfiles/mai/lab-processes$ jobs -l
vagrant@ubuntu-xenial:~/myfiles/mai/lab-processes$ df
Filesystem     1K-blocks      Used Available Use% Mounted on
udev             1014696         0   1014696   0% /dev
tmpfs             204796      3236    201560   2% /run
/dev/sda1       10098468   5850472   4231612  59% /
tmpfs            1023968         4   1023964   1% /dev/shm
tmpfs               5120         0      5120   0% /run/lock
tmpfs            1023968         0   1023968   0% /sys/fs/cgroup
vagrant        488245288 189669460 298575828  39% /vagrant
tmpfs             204796         0    204796   0% /run/user/1000
```

Убиваем процесс

```bash
vagrant@ubuntu-xenial:~/myfiles/mai/lab-processes$ df
Filesystem     1K-blocks      Used Available Use% Mounted on
udev             1014696         0   1014696   0% /dev
tmpfs             204796      3236    201560   2% /run
/dev/sda1       10098468   6431276   3650808  64% /
tmpfs            1023968         4   1023964   1% /dev/shm
tmpfs               5120         0      5120   0% /run/lock
tmpfs            1023968         0   1023968   0% /sys/fs/cgroup
vagrant        488245288 190739784 297505504  40% /vagrant
tmpfs             204796         0    204796   0% /run/user/1000
```

Процесс убит и больше не занимает место. Поизошло это из-за удаления файла, но не закрытия файлового дескриптора. Т.к. он был не закрыт, скрипт продолжал увеличивать размер файла.



#Утилиты мониторинга

Через htop смотрим LA и топ процесов загружающих процессор и память. 

![Снимок экрана 2019-12-24 в 19.37.43](https://tva1.sinaimg.cn/large/006tNbRwgy1ga8abwqpfqj30h2042t9p.jpg)



![Снимок экрана 2019-12-24 в 19.43.41](https://tva1.sinaimg.cn/large/006tNbRwgy1ga8ai24ax4j312i04a0wb.jpg)

Генерируем файл командой dd.

![img](https://tva1.sinaimg.cn/large/006tNbRwgy1ga8ajeg2jdj31gl013gli.jpg)

iotop

```bash

Total DISK READ :       0.00 B/s | Total DISK WRITE :       0.00 B/s
Actual DISK READ:       0.00 B/s | Actual DISK WRITE:       0.00 B/s
  TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN     IO>    COMMAND                            
    1 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % init
    2 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [kthreadd]
    3 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [ksoftirqd/0]
    4 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [kworker/0:0]
    5 be/0 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [kworker/0:0H]
    6 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [kworker/u4:0]
    7 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [rcu_sched]
    8 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [rcu_bh]
    9 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/0]
   10 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [watchdog/0]
   11 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [watchdog/1]
   12 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/1]
   13 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [ksoftirqd/1]
 1550 be/4 syslog      0.00 B/s    0.00 B/s  0.00 %  0.00 % rsyslogd -n [in:imklog]
   15 be/0 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [kworker/1:0H]
   16 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [kdevtmpfs]
   17 be/0 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [netns]
   18 be/0 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [perf]
   19 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [khungtaskd]
   20 be/0 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [writeback]
   21 be/5 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [ksmd]
```

iostat

```bash
vagrant@ubuntu-xenial:~/myfiles/mai/lab-processes$ iostat
Linux 4.4.0-170-generic (ubuntu-xenial) 	12/24/2019 	_x86_64_	(2 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.37    0.02    5.94    0.08    0.00   93.59

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
loop0             0.00         0.01         0.00          8          0
sdb               0.17         1.85         0.00       2014          0
sda              29.83       401.33     10204.06     435891   11082932
```

