#!/usr/bin/env python
import pika
import time
connection = pika.BlockingConnection(pika.ConnectionParameters(
        host='localhost'))
channel = connection.channel()

channel.queue_declare(queue='hello')

print ' [*] Waiting for messages. To exit press CTRL+C'

def callback(ch, method, properties, body):
    print " [x] Received %r" % (body,)
    time.sleep(body.count('.'))
    print " [x] Done "
    ch.basic_ack(delivery_tag = method.delivery_tag)
# wait for message for queue hello
channel.basic_consume(callback,
                      queue='hello')

channel.start_consuming()