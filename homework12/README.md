Домашнее задание по управлению процессами
-----------------------------------------
Задание на выбор:
5. реализовать 2 конкурирующих процесса по CPU. пробовать запустить с разными nice
Результат ДЗ - скрипт запускающий 2 процесса с разными nice и замеряющий время выполнения и лог консоли

Результат:
----------
Один и тот же скрипт [fibonach.sh](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework12/fibonach.sh) одновременно запускается с разным параметром nice (команда time используется для измерения времени выполнения):

```
time nice -n 40 ./fibonach.sh 1000000 & time nice -n -30 ./fibonach.sh 1000000
```

лог выполнения:
```
root@evengtest:/home/eve/test_3# time nice -n 40 ./fibonach.sh 1000000 & time nice -n -30 ./fibonach.sh 1000000
[1] 76029
The Fibonacci series is : 
The Fibonacci series is : 
-4249520595888827205

real	0m9.991s
user	0m9.968s
sys	0m0.009s
-4249520595888827205
[1]+  Done                    time nice -n 40 ./fibonach.sh 1000000

real	0m10.207s
user	0m20.160s
sys	0m0.022s
root@evengtest:/home/eve/test_3#
```
