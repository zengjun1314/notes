#!/usr/bin/env python
# -*- coding: utf-8 -*-


#import os
#for x in os.listdir("/home/zengjj/study/github/notes/python/demo") :
#	print x
#	if os.path.isfile(x) and os.path.splitext(x)[1]==".py":
#		print x
####  equal to
#>>> [x for x in os.listdir("/home/zengjj/study/github/notes/python/demo") if os.path.isfile(x) and os.path.splitext(x)[1]==".py"]
#['test.py', 'do_stringio.py']


#------------ CLASS OS  用法
####-------demo.1  条件判断方法
#from datetime import datetime
#import os
#pwd = os.path.abspath('.')
#print(' Size Last Modified Name')
#print('------------------------------------------------------------')
#for f in os.listdir(pwd):
#    fsize = os.path.getsize(f)
#    mtime = datetime.fromtimestamp(os.path.getmtime(f)).strftime('%Y-%m-%d %H:%M')
#    flag = '/' if os.path.isdir(f) else ''
#    print('%10d %s %s%s' % (fsize, mtime, f, flag))

####-------demo.1  进程和线程

#import os
#print('Process (%s) start...' % os.getpid())
# Only works on Unix/Linux/Mac:
#pid = os.fork()
#if pid == 0:
#    print('I am child process (%s) and my parent is %s.' % (os.getpid(), os.getppid()))
#else:
#    print('I (%s) just created a child process (%s).' % (os.getpid(), pid))

############## multiprocessing .1
#from multiprocessing import Process
#import os

# 子进程要执行的代码
#def run_proc(name):
#    print('Run child process %s (%s)...' % (name, os.getpid()))

#if __name__=='__main__':
#    print('Parent process %s.' % os.getpid())
#    p = Process(target=run_proc, args=('test',))   #注册子线程
#    print('Child process will start.')
#    p.start()    #启动子线程
#    p.join()    #父进程等待子线程运行完成后运行
#    print('Child process end.')
############## multiprocessing .2
#from multiprocessing import Pool
#import os, time, random

#def long_time_task(name):
#    print('Run task %s (%s)...' % (name, os.getpid()))
#    start = time.time()
#    time.sleep(random.random() * 3)
#    end = time.time()
#    print('Task %s runs %0.2f seconds.' % (name, (end - start)))

#if __name__=='__main__':
#    print('Parent process %s.' % os.getpid())
#    p = Pool(4)
#    for i in range(5):
#        p.apply_async(long_time_task, args=(i,))
#    print('Waiting for all subprocesses done...')
#    p.close()
#    p.join()
#    print('All subprocesses done.')

############## multiprocessing .3
#from multiprocessing import Process, Queue
#import os, time, random

# 写数据进程执行的代码:
#def write(q):
#    print('Process to write: %s' % os.getpid())
#    for value in ['A', 'B', 'C']:
#        print('Put %s to queue...' % value)
#        q.put(value)
#        time.sleep(random.random())

# 读数据进程执行的代码:
#def read(q):
#    print('Process to read: %s' % os.getpid())
#    while True:
#        value = q.get(True)
#        print('Get %s from queue.' % value)

#if __name__=='__main__':
    # 父进程创建Queue，并传给各个子进程：
#    q = Queue()
#    pw = Process(target=write, args=(q,))
#    pr = Process(target=read, args=(q,))
#    # 启动子进程pw，写入:
#    pw.start()
    # 启动子进程pr，读取:
#    pr.start()
    # 等待pw结束:
#    pw.join()
    # pr进程里是死循环，无法等待其结束，只能强行终止:
#    pr.terminate()


#------------CLASS JSON 用法
####-------demo.1  使用方法
#>>> import json
#>>> d = dict(name='Bob', age=20, score=88)
#>>> json.dumps(d)
#'{"age": 20, "score": 88, "name": "Bob"}'

#>>> json_str = '{"age": 20, "score": 88, "name": "Bob"}'
#>>> json.loads(json_str)
#{'age': 20, 'score': 88, 'name': 'Bob'}

#------------CLASS re 正则表达式用法
####-------demo.1  使用方法
import re
test = '123456'
if re.match(r'\d*', test):
    print('ok')
else:
    print('failed')