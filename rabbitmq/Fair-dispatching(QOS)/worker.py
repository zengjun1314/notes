#!/usr/bin/env python
import pika
import time
connection = pika.BlockingConnection(pika.ConnectionParameters(
        host='localhost'))
channel = connection.channel()

channel.queue_declare(queue='task_queue', durable=True)

print ' [*] Waiting for messages. To exit press CTRL+C'

def callback(ch, method, properties, body):
    print " [x] Received %r" % (body,)
    time.sleep(body.count('.'))
    print " [x] Done "
    ch.basic_ack(delivery_tag = method.delivery_tag)
#  queue  Qos
#  one time one message
channel.basic_qos(prefetch_count=1)
# wait for message for queue hello
channel.basic_consume(callback,
                      queue='task_queue')
try:
    channel.start_consuming()
except pika.exceptions.ConnectionClosed :
    print "test : pika.exceptions.ConnectionClosed"