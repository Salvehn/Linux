1 Лаба 3 пункт

```bash

[Unit]
Description=Start process monitor

[Service]
Type=simple
ExecStart=/bin/bash /usr/bin/ProcessLogger.sh
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target

```

Restart=on-failure - перезапускает процесс, если он был завершен с кодом отличным от 0.