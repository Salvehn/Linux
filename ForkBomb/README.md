Bash скрипт форк бомбы

```bash
bomb() {
   bomb | bomb &
   };
bomb

```

Для ограничения по ресурсам:

Настройка conf файла с ограничениями кол-ва процессов для пользователей/групп

```bash
vi /etc/security/limits.conf
...
user hard nproc 300
@student hard nproc 50
@teacher soft nproc 100
```

Либо ограничение через ulimit

```bash
ulimit -u 100
```

